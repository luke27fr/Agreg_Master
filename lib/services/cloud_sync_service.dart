import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'score_service.dart';
import 'favorites_service.dart';
import 'notes_service.dart';
import 'reading_service.dart';
import 'streak_service.dart';
import 'badge_service.dart';
import 'spaced_repetition_service.dart';
import 'lecon_progress_service.dart';
import 'examen_blanc_service.dart';

/// Service de synchronisation cloud avec Firestore
/// Synchronise toutes les données utilisateur entre appareils
class CloudSyncService extends ChangeNotifier {
  static final CloudSyncService _instance = CloudSyncService._internal();
  factory CloudSyncService() => _instance;
  CloudSyncService._internal();

  // État
  bool _isSyncing = false;
  bool _isOnline = false;
  DateTime? _lastSyncTime;
  String? _error;
  String? _userId;
  bool _initialized = false;
  
  // Listeners
  StreamSubscription<User?>? _authSubscription;
  StreamSubscription<List<ConnectivityResult>>? _connectivitySubscription;
  Timer? _autoSyncTimer;

  // Getters
  bool get isSyncing => _isSyncing;
  bool get isOnline => _isOnline;
  DateTime? get lastSyncTime => _lastSyncTime;
  String? get error => _error;
  String? get userId => _userId;
  bool get isAuthenticated => _userId != null;

  /// Vérifie si Firebase est disponible (mobile uniquement)
  bool get _isFirebaseAvailable {
    return !kIsWeb;
  }

  /// Initialiser le service de synchronisation
  Future<void> initialize() async {
    if (_initialized) return;
    
    if (!_isFirebaseAvailable) {
      debugPrint('ℹ️ CloudSync désactivé sur desktop');
      _initialized = true;
      return;
    }

    try {
      // Vérifier la connectivité
      final connectivity = Connectivity();
      final result = await connectivity.checkConnectivity();
      _isOnline = !result.contains(ConnectivityResult.none);

      // Écouter les changements de connectivité
      _connectivitySubscription = connectivity.onConnectivityChanged.listen((result) {
        final wasOnline = _isOnline;
        _isOnline = !result.contains(ConnectivityResult.none);
        
        if (!wasOnline && _isOnline) {
          debugPrint('🌐 Connexion rétablie, synchronisation...');
          syncAll();
        }
        
        notifyListeners();
      });

      // Authentification anonyme
      await _signInAnonymously();

      // Écouter les changements d'authentification
      _authSubscription = FirebaseAuth.instance.authStateChanges().listen((user) {
        _userId = user?.uid;
        debugPrint('🔐 User ID: $_userId');
        notifyListeners();

        if (_userId != null && _isOnline) {
          syncAll();
        }
      });

      // Synchronisation automatique toutes les 5 minutes
      _autoSyncTimer = Timer.periodic(const Duration(minutes: 5), (_) {
        if (_isOnline && _userId != null && !_isSyncing) {
          debugPrint('⏰ Auto-sync...');
          syncAll();
        }
      });

      _initialized = true;
      debugPrint('✅ CloudSyncService initialisé');
    } catch (e) {
      debugPrint('❌ Erreur init CloudSyncService: $e');
      _error = e.toString();
      _initialized = true;
      notifyListeners();
    }
  }

  /// Connexion anonyme Firebase
  Future<void> _signInAnonymously() async {
    if (!_isFirebaseAvailable) return;
    
    try {
      final auth = FirebaseAuth.instance;
      if (auth.currentUser == null) {
        final userCredential = await auth.signInAnonymously();
        _userId = userCredential.user?.uid;
        debugPrint('🔐 Authentification anonyme réussie: $_userId');
      } else {
        _userId = auth.currentUser?.uid;
        debugPrint('🔐 Déjà authentifié: $_userId');
      }
    } catch (e) {
      debugPrint('❌ Erreur authentification: $e');
      _error = 'Erreur d\'authentification: $e';
      notifyListeners();
    }
  }

  /// Synchroniser toutes les données
  Future<void> syncAll() async {
    if (!_isFirebaseAvailable) return;
    
    if (!_isOnline) {
      _error = 'Pas de connexion Internet';
      notifyListeners();
      return;
    }

    if (_userId == null) {
      await _signInAnonymously();
      if (_userId == null) return;
    }

    _isSyncing = true;
    _error = null;
    notifyListeners();

    try {
      final firestore = FirebaseFirestore.instance;
      
      await Future.wait([
        _syncScores(firestore),
        _syncFavorites(firestore),
        _syncNotes(firestore),
        _syncReadingProgress(firestore),
        _syncStreak(firestore),
        _syncBadges(firestore),
        _syncSpacedRepetition(firestore),
        _syncLeconProgress(firestore),
        _syncExamenResults(firestore),
      ]);

      _lastSyncTime = DateTime.now();
      debugPrint('✅ Synchronisation complète réussie');
    } catch (e) {
      debugPrint('❌ Erreur synchronisation: $e');
      _error = 'Erreur de synchronisation: $e';
    } finally {
      _isSyncing = false;
      notifyListeners();
    }
  }

  /// Synchroniser les scores de quiz
  Future<void> _syncScores(FirebaseFirestore firestore) async {
    try {
      final scoreService = ScoreService();
      final docRef = firestore.collection('users').doc(_userId).collection('data').doc('scores');

      final localScores = <String, Map<String, dynamic>>{};
      scoreService.scores.forEach((ficheId, score) {
        localScores[ficheId] = {
          'score': score.score,
          'total': score.total,
          'percentage': score.percentage,
          'date': score.date.millisecondsSinceEpoch,
        };
      });

      final cloudDoc = await docRef.get();
      final cloudScores = cloudDoc.data()?['scores'] as Map<String, dynamic>? ?? {};

      final mergedScores = <String, Map<String, dynamic>>{};
      
      localScores.forEach((ficheId, scoreData) {
        mergedScores[ficheId] = scoreData;
      });

      cloudScores.forEach((ficheId, cloudData) {
        if (cloudData is Map<String, dynamic>) {
          final localDate = localScores[ficheId]?['date'] as int? ?? 0;
          final cloudDate = cloudData['date'] as int? ?? 0;
          
          if (cloudDate > localDate) {
            mergedScores[ficheId] = cloudData;
          }
        }
      });

      await docRef.set({
        'scores': mergedScores,
        'lastSync': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      // Appliquer les changements localement (sans paramètre date)
      for (var entry in mergedScores.entries) {
        final ficheId = entry.key;
        final data = entry.value;
        final cloudDate = data['date'] as int? ?? 0;
        final localDate = localScores[ficheId]?['date'] as int? ?? 0;

        if (cloudDate > localDate) {
          scoreService.saveScore(
            ficheId,
            data['score'] as int,
            data['total'] as int,
          );
        }
      }

      debugPrint('✅ Scores synchronisés: ${mergedScores.length} fiches');
    } catch (e) {
      debugPrint('❌ Erreur sync scores: $e');
    }
  }

  /// Synchroniser les favoris
  Future<void> _syncFavorites(FirebaseFirestore firestore) async {
    try {
      final favoritesService = FavoritesService();
      final docRef = firestore.collection('users').doc(_userId).collection('data').doc('favorites');

      final localFavorites = favoritesService.favorites.toList();

      final cloudDoc = await docRef.get();
      final cloudFavorites = (cloudDoc.data()?['favorites'] as List<dynamic>?)
          ?.map((e) => e.toString())
          .toSet() ?? <String>{};

      final mergedFavorites = {...localFavorites, ...cloudFavorites}.toList();

      await docRef.set({
        'favorites': mergedFavorites,
        'lastSync': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      for (var ficheId in mergedFavorites) {
        if (!favoritesService.isFavorite(ficheId)) {
          favoritesService.addFavorite(ficheId);
        }
      }

      debugPrint('✅ Favoris synchronisés: ${mergedFavorites.length}');
    } catch (e) {
      debugPrint('❌ Erreur sync favoris: $e');
    }
  }

  /// Synchroniser les notes
  Future<void> _syncNotes(FirebaseFirestore firestore) async {
    try {
      final notesService = NotesService();
      final docRef = firestore.collection('users').doc(_userId).collection('data').doc('notes');

      // Notes locales : Map<String, PersonalNote> → extraire le contenu
      final localNotes = <String, String>{};
      notesService.notes.forEach((ficheId, personalNote) {
        localNotes[ficheId] = personalNote.content;
      });

      final cloudDoc = await docRef.get();
      final cloudNotes = (cloudDoc.data()?['notes'] as Map<String, dynamic>?)
          ?.map((k, v) => MapEntry(k, v.toString())) ?? <String, String>{};

      final mergedNotes = <String, String>{};
      
      localNotes.forEach((ficheId, note) {
        mergedNotes[ficheId] = note;
      });

      cloudNotes.forEach((ficheId, cloudNote) {
        final localNote = localNotes[ficheId] ?? '';
        if (cloudNote.length > localNote.length) {
          mergedNotes[ficheId] = cloudNote;
        }
      });

      await docRef.set({
        'notes': mergedNotes,
        'lastSync': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      for (var entry in mergedNotes.entries) {
        final localContent = notesService.notes[entry.key]?.content ?? '';
        if (localContent.length < entry.value.length) {
          notesService.saveNote(entry.key, entry.value);
        }
      }

      debugPrint('✅ Notes synchronisées: ${mergedNotes.length}');
    } catch (e) {
      debugPrint('❌ Erreur sync notes: $e');
    }
  }

  /// Synchroniser la progression de lecture
  Future<void> _syncReadingProgress(FirebaseFirestore firestore) async {
    try {
      final readingService = ReadingService();
      final docRef = firestore.collection('users').doc(_userId).collection('data').doc('reading');

      final localRead = readingService.readFiches.toList();

      final cloudDoc = await docRef.get();
      final cloudRead = (cloudDoc.data()?['read'] as List<dynamic>?)
          ?.map((e) => e.toString())
          .toSet() ?? <String>{};

      final mergedRead = {...localRead, ...cloudRead}.toList();

      await docRef.set({
        'read': mergedRead,
        'lastSync': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      for (var ficheId in mergedRead) {
        if (!readingService.isRead(ficheId)) {
          readingService.markAsRead(ficheId);
        }
      }

      debugPrint('✅ Progression lecture synchronisée: ${mergedRead.length}');
    } catch (e) {
      debugPrint('❌ Erreur sync lecture: $e');
    }
  }

  /// Synchroniser les streaks
  Future<void> _syncStreak(FirebaseFirestore firestore) async {
    try {
      final streakService = StreakService();
      final docRef = firestore.collection('users').doc(_userId).collection('data').doc('streak');

      final localData = {
        'currentStreak': streakService.currentStreak,
        'longestStreak': streakService.longestStreak,
        'lastActivityDate': streakService.lastActivityDate?.millisecondsSinceEpoch,
        'totalDays': streakService.totalDaysActive,
      };

      final cloudDoc = await docRef.get();
      final cloudData = cloudDoc.data() ?? {};

      final mergedData = {
        'currentStreak': _maxInt(localData['currentStreak'] as int, cloudData['currentStreak'] as int? ?? 0),
        'longestStreak': _maxInt(localData['longestStreak'] as int, cloudData['longestStreak'] as int? ?? 0),
        'lastActivityDate': _maxInt(localData['lastActivityDate'] ?? 0, cloudData['lastActivityDate'] as int? ?? 0),
        'totalDays': _maxInt(localData['totalDays'] as int, cloudData['totalDays'] as int? ?? 0),
      };

      await docRef.set({
        ...mergedData,
        'lastSync': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      debugPrint('✅ Streak synchronisé: ${mergedData['currentStreak']} jours');
    } catch (e) {
      debugPrint('❌ Erreur sync streak: $e');
    }
  }

  int _maxInt(int a, int b) => a > b ? a : b;

  /// Synchroniser les badges
  Future<void> _syncBadges(FirebaseFirestore firestore) async {
    try {
      final badgeService = BadgeService();
      final docRef = firestore.collection('users').doc(_userId).collection('data').doc('badges');

      final localBadges = badgeService.unlockedBadges.toList();

      final cloudDoc = await docRef.get();
      final cloudBadges = (cloudDoc.data()?['unlocked'] as List<dynamic>?)
          ?.map((e) => e.toString())
          .toSet() ?? <String>{};

      final mergedBadges = {...localBadges, ...cloudBadges}.toList();

      await docRef.set({
        'unlocked': mergedBadges,
        'lastSync': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      debugPrint('✅ Badges synchronisés: ${mergedBadges.length}');
    } catch (e) {
      debugPrint('❌ Erreur sync badges: $e');
    }
  }

  /// Synchroniser la répétition espacée
  Future<void> _syncSpacedRepetition(FirebaseFirestore firestore) async {
    try {
      final srService = SpacedRepetitionService();
      final docRef = firestore.collection('users').doc(_userId).collection('data').doc('spaced_repetition');

      final localCards = <String, Map<String, dynamic>>{};
      srService.cards.forEach((ficheId, card) {
        localCards[ficheId] = {
          'intervalDays': card.intervalDays,
          'easeFactor': card.easeFactor,
          'repetitionNumber': card.repetitionNumber,
          'nextReviewDate': card.nextReviewDate.millisecondsSinceEpoch,
        };
      });

      final cloudDoc = await docRef.get();
      final cloudCards = cloudDoc.data()?['cards'] as Map<String, dynamic>? ?? {};

      final mergedCards = <String, Map<String, dynamic>>{};
      
      localCards.forEach((ficheId, cardData) {
        mergedCards[ficheId] = cardData;
      });

      cloudCards.forEach((ficheId, cloudData) {
        if (cloudData is Map<String, dynamic>) {
          final localDate = localCards[ficheId]?['nextReviewDate'] as int? ?? 0;
          final cloudDate = cloudData['nextReviewDate'] as int? ?? 0;
          
          if (cloudDate > localDate) {
            mergedCards[ficheId] = cloudData;
          }
        }
      });

      await docRef.set({
        'cards': mergedCards,
        'lastSync': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      debugPrint('✅ Répétition espacée synchronisée: ${mergedCards.length} cartes');
    } catch (e) {
      debugPrint('❌ Erreur sync répétition espacée: $e');
    }
  }

  /// Synchroniser la progression des leçons
  Future<void> _syncLeconProgress(FirebaseFirestore firestore) async {
    try {
      final leconService = LeconProgressService();
      final docRef = firestore.collection('users').doc(_userId).collection('data').doc('lecon_progress');

      final localProgress = <String, Map<String, dynamic>>{};
      leconService.progressMap.forEach((leconId, prog) {
        localProgress[leconId] = {
          'developpementsMaitrises': prog.developpementsMaitrises,
          'tempsEtudeMinutes': prog.tempsEtudeMinutes,
          'nombreRevisions': prog.nombreRevisions,
          'niveauPlan': prog.niveauPlan,
          'niveauDeveloppements': prog.niveauDeveloppements,
          'niveauExemples': prog.niveauExemples,
          'derniereRevision': prog.derniereRevision?.millisecondsSinceEpoch,
        };
      });

      final cloudDoc = await docRef.get();
      final cloudProgress = cloudDoc.data()?['progress'] as Map<String, dynamic>? ?? {};

      final mergedProgress = <String, Map<String, dynamic>>{};
      
      localProgress.forEach((leconId, progData) {
        mergedProgress[leconId] = progData;
      });

      cloudProgress.forEach((leconId, cloudData) {
        if (cloudData is Map<String, dynamic>) {
          final localDate = localProgress[leconId]?['derniereRevision'] as int? ?? 0;
          final cloudDate = cloudData['derniereRevision'] as int? ?? 0;
          
          if (cloudDate > localDate) {
            mergedProgress[leconId] = cloudData;
          }
        }
      });

      await docRef.set({
        'progress': mergedProgress,
        'lastSync': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      debugPrint('✅ Progression leçons synchronisée: ${mergedProgress.length}');
    } catch (e) {
      debugPrint('❌ Erreur sync leçons: $e');
    }
  }

  /// Synchroniser les résultats d'examens blancs
  Future<void> _syncExamenResults(FirebaseFirestore firestore) async {
    try {
      final examenService = ExamenBlancService();
      final docRef = firestore.collection('users').doc(_userId).collection('data').doc('examen_results');

      final localResults = examenService.results.map((result) {
        return {
          'examenId': result.examenId,
          'scoreTotal': result.scoreTotal,
          'baremeTotal': result.baremeTotal,
          'dureeEffective': result.dureeEffective,
          'datePassage': result.datePassage.millisecondsSinceEpoch,
          'termine': result.termine,
        };
      }).toList();

      final cloudDoc = await docRef.get();
      final cloudResults = (cloudDoc.data()?['results'] as List<dynamic>?)
          ?.map((e) => e as Map<String, dynamic>)
          .toList() ?? [];

      // Merge: garder tous les résultats (dédupliquer)
      final mergedResultsMap = <String, Map<String, dynamic>>{};
      
      for (var result in [...localResults, ...cloudResults]) {
        final key = '${result['examenId']}_${result['datePassage']}';
        if (!mergedResultsMap.containsKey(key)) {
          mergedResultsMap[key] = result;
        }
      }

      final mergedResults = mergedResultsMap.values.toList()
        ..sort((a, b) => ((b['datePassage'] as int?) ?? 0).compareTo((a['datePassage'] as int?) ?? 0));

      await docRef.set({
        'results': mergedResults.take(50).toList(),
        'lastSync': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      debugPrint('✅ Résultats examens synchronisés: ${mergedResults.length}');
    } catch (e) {
      debugPrint('❌ Erreur sync examens: $e');
    }
  }

  /// Forcer une synchronisation maintenant
  Future<void> forceSyncNow() async {
    debugPrint('🔄 Synchronisation forcée...');
    await syncAll();
  }

  /// Réinitialiser toutes les données cloud
  Future<void> deleteAllCloudData() async {
    if (!_isFirebaseAvailable || _userId == null) return;

    try {
      final firestore = FirebaseFirestore.instance;
      final dataCollection = firestore.collection('users').doc(_userId).collection('data');
      final docs = await dataCollection.get();
      
      for (var doc in docs.docs) {
        await doc.reference.delete();
      }

      debugPrint('⚠️ Toutes les données cloud supprimées');
      notifyListeners();
    } catch (e) {
      debugPrint('❌ Erreur suppression données cloud: $e');
      _error = e.toString();
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _authSubscription?.cancel();
    _connectivitySubscription?.cancel();
    _autoSyncTimer?.cancel();
    super.dispose();
  }
}

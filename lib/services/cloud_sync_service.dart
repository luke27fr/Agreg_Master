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

  // Firebase
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final Connectivity _connectivity = Connectivity();

  // État
  bool _isSyncing = false;
  bool _isOnline = false;
  DateTime? _lastSyncTime;
  String? _error;
  String? _userId;
  
  // Listeners
  StreamSubscription<User?>? _authSubscription;
  StreamSubscription<ConnectivityResult>? _connectivitySubscription;
  Timer? _autoSyncTimer;

  // Getters
  bool get isSyncing => _isSyncing;
  bool get isOnline => _isOnline;
  DateTime? get lastSyncTime => _lastSyncTime;
  String? get error => _error;
  String? get userId => _userId;
  bool get isAuthenticated => _userId != null;

  /// Initialiser le service de synchronisation
  Future<void> initialize() async {
    try {
      // Vérifier la connectivité
      final result = await _connectivity.checkConnectivity();
      _isOnline = result != ConnectivityResult.none;

      // Écouter les changements de connectivité
      _connectivitySubscription = _connectivity.onConnectivityChanged.listen((result) {
        final wasOnline = _isOnline;
        _isOnline = result != ConnectivityResult.none;
        
        if (!wasOnline && _isOnline) {
          // Connexion rétablie, synchroniser
          debugPrint('🌐 Connexion rétablie, synchronisation...');
          syncAll();
        }
        
        notifyListeners();
      });

      // Authentification anonyme
      await _signInAnonymously();

      // Écouter les changements d'authentification
      _authSubscription = _auth.authStateChanges().listen((user) {
        _userId = user?.uid;
        debugPrint('🔐 User ID: $_userId');
        notifyListeners();

        if (_userId != null && _isOnline) {
          // Synchroniser après l'authentification
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

      debugPrint('✅ CloudSyncService initialisé');
    } catch (e) {
      debugPrint('❌ Erreur init CloudSyncService: $e');
      _error = e.toString();
      notifyListeners();
    }
  }

  /// Connexion anonyme Firebase
  Future<void> _signInAnonymously() async {
    try {
      if (_auth.currentUser == null) {
        final userCredential = await _auth.signInAnonymously();
        _userId = userCredential.user?.uid;
        debugPrint('🔐 Authentification anonyme réussie: $_userId');
      } else {
        _userId = _auth.currentUser?.uid;
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
      // Synchroniser chaque type de données
      await Future.wait([
        _syncScores(),
        _syncFavorites(),
        _syncNotes(),
        _syncReadingProgress(),
        _syncStreak(),
        _syncBadges(),
        _syncSpacedRepetition(),
        _syncLeconProgress(),
        _syncExamenResults(),
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
  Future<void> _syncScores() async {
    try {
      final scoreService = ScoreService();
      final docRef = _firestore.collection('users').doc(_userId).collection('data').doc('scores');

      // Upload local → Cloud
      final localScores = scoreService.scores.map((ficheId, score) {
        return MapEntry(ficheId, {
          'score': score.score,
          'total': score.total,
          'percentage': score.percentage,
          'date': score.date.millisecondsSinceEpoch,
        });
      }).cast<String, Map<String, dynamic>>();

      // Récupérer cloud data
      final cloudDoc = await docRef.get();
      final cloudScores = cloudDoc.data()?['scores'] as Map<String, dynamic>? ?? {};

      // Merge: garder la version la plus récente
      final mergedScores = <String, Map<String, dynamic>>{};
      
      // Ajouter scores locaux
      localScores.forEach((ficheId, scoreData) {
        mergedScores[ficheId] = scoreData;
      });

      // Merger avec cloud (garder le plus récent)
      cloudScores.forEach((ficheId, cloudData) {
        if (cloudData is Map<String, dynamic>) {
          final localDate = localScores[ficheId]?['date'] as int? ?? 0;
          final cloudDate = cloudData['date'] as int? ?? 0;
          
          if (cloudDate > localDate) {
            mergedScores[ficheId] = cloudData;
          }
        }
      });

      // Sauvegarder le merged dans le cloud
      await docRef.set({
        'scores': mergedScores,
        'lastSync': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      // Appliquer les changements localement
      for (var entry in mergedScores.entries) {
        final ficheId = entry.key;
        final data = entry.value;
        final cloudDate = data['date'] as int? ?? 0;
        final localDate = localScores[ficheId]?['date'] as int? ?? 0;

        if (cloudDate > localDate) {
          // Mettre à jour local avec cloud
          scoreService.saveScore(
            ficheId,
            data['score'] as int,
            data['total'] as int,
            date: DateTime.fromMillisecondsSinceEpoch(cloudDate),
          );
        }
      }

      debugPrint('✅ Scores synchronisés: ${mergedScores.length} fiches');
    } catch (e) {
      debugPrint('❌ Erreur sync scores: $e');
      rethrow;
    }
  }

  /// Synchroniser les favoris
  Future<void> _syncFavorites() async {
    try {
      final favoritesService = FavoritesService();
      final docRef = _firestore.collection('users').doc(_userId).collection('data').doc('favorites');

      // Upload local → Cloud
      final localFavorites = favoritesService.favorites.toList();

      // Récupérer cloud data
      final cloudDoc = await docRef.get();
      final cloudFavorites = (cloudDoc.data()?['favorites'] as List<dynamic>?)
          ?.map((e) => e.toString())
          .toSet() ?? <String>{};

      // Merge: union des deux ensembles
      final mergedFavorites = {...localFavorites, ...cloudFavorites}.toList();

      // Sauvegarder dans le cloud
      await docRef.set({
        'favorites': mergedFavorites,
        'lastSync': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      // Appliquer localement
      for (var ficheId in mergedFavorites) {
        if (!favoritesService.isFavorite(ficheId)) {
          favoritesService.addFavorite(ficheId);
        }
      }

      debugPrint('✅ Favoris synchronisés: ${mergedFavorites.length}');
    } catch (e) {
      debugPrint('❌ Erreur sync favoris: $e');
      rethrow;
    }
  }

  /// Synchroniser les notes
  Future<void> _syncNotes() async {
    try {
      final notesService = NotesService();
      final docRef = _firestore.collection('users').doc(_userId).collection('data').doc('notes');

      // Upload local → Cloud
      final localNotes = notesService.notes;

      // Récupérer cloud data
      final cloudDoc = await docRef.get();
      final cloudNotes = (cloudDoc.data()?['notes'] as Map<String, dynamic>?)
          ?.map((k, v) => MapEntry(k, v.toString())) ?? <String, String>{};

      // Merge: garder le plus long (hypothèse : plus de contenu = plus récent)
      final mergedNotes = <String, String>{};
      
      // Ajouter notes locales
      localNotes.forEach((ficheId, note) {
        mergedNotes[ficheId] = note;
      });

      // Merger avec cloud (garder la plus longue)
      cloudNotes.forEach((ficheId, cloudNote) {
        final localNote = localNotes[ficheId] ?? '';
        if (cloudNote.length > localNote.length) {
          mergedNotes[ficheId] = cloudNote;
        }
      });

      // Sauvegarder dans le cloud
      await docRef.set({
        'notes': mergedNotes,
        'lastSync': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      // Appliquer localement
      for (var entry in mergedNotes.entries) {
        if ((notesService.notes[entry.key] ?? '').length < entry.value.length) {
          notesService.saveNote(entry.key, entry.value);
        }
      }

      debugPrint('✅ Notes synchronisées: ${mergedNotes.length}');
    } catch (e) {
      debugPrint('❌ Erreur sync notes: $e');
      rethrow;
    }
  }

  /// Synchroniser la progression de lecture
  Future<void> _syncReadingProgress() async {
    try {
      final readingService = ReadingService();
      final docRef = _firestore.collection('users').doc(_userId).collection('data').doc('reading');

      // Upload local → Cloud
      final localRead = readingService.readFiches.toList();

      // Récupérer cloud data
      final cloudDoc = await docRef.get();
      final cloudRead = (cloudDoc.data()?['read'] as List<dynamic>?)
          ?.map((e) => e.toString())
          .toSet() ?? <String>{};

      // Merge: union
      final mergedRead = {...localRead, ...cloudRead}.toList();

      // Sauvegarder dans le cloud
      await docRef.set({
        'read': mergedRead,
        'lastSync': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      // Appliquer localement
      for (var ficheId in mergedRead) {
        if (!readingService.isRead(ficheId)) {
          readingService.markAsRead(ficheId);
        }
      }

      debugPrint('✅ Progression lecture synchronisée: ${mergedRead.length}');
    } catch (e) {
      debugPrint('❌ Erreur sync lecture: $e');
      rethrow;
    }
  }

  /// Synchroniser les streaks
  Future<void> _syncStreak() async {
    try {
      final streakService = StreakService();
      final docRef = _firestore.collection('users').doc(_userId).collection('data').doc('streak');

      // Upload local → Cloud
      final localData = {
        'currentStreak': streakService.currentStreak,
        'longestStreak': streakService.longestStreak,
        'lastActivityDate': streakService.lastActivityDate?.millisecondsSinceEpoch,
        'totalDays': streakService.totalActiveDays,
      };

      // Récupérer cloud data
      final cloudDoc = await docRef.get();
      final cloudData = cloudDoc.data() ?? {};

      // Merge: garder le max pour les valeurs numériques
      final mergedData = {
        'currentStreak': [
          localData['currentStreak'] as int,
          cloudData['currentStreak'] as int? ?? 0
        ].reduce((a, b) => a > b ? a : b),
        'longestStreak': [
          localData['longestStreak'] as int,
          cloudData['longestStreak'] as int? ?? 0
        ].reduce((a, b) => a > b ? a : b),
        'lastActivityDate': [
          localData['lastActivityDate'] as int? ?? 0,
          cloudData['lastActivityDate'] as int? ?? 0
        ].reduce((a, b) => a > b ? a : b),
        'totalDays': [
          localData['totalDays'] as int,
          cloudData['totalDays'] as int? ?? 0
        ].reduce((a, b) => a > b ? a : b),
      };

      // Sauvegarder dans le cloud
      await docRef.set({
        ...mergedData,
        'lastSync': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      debugPrint('✅ Streak synchronisé: ${mergedData['currentStreak']} jours');
    } catch (e) {
      debugPrint('❌ Erreur sync streak: $e');
      rethrow;
    }
  }

  /// Synchroniser les badges
  Future<void> _syncBadges() async {
    try {
      final badgeService = BadgeService();
      final docRef = _firestore.collection('users').doc(_userId).collection('data').doc('badges');

      // Upload local → Cloud
      final localBadges = badgeService.unlockedBadges.toList();

      // Récupérer cloud data
      final cloudDoc = await docRef.get();
      final cloudBadges = (cloudDoc.data()?['unlocked'] as List<dynamic>?)
          ?.map((e) => e.toString())
          .toSet() ?? <String>{};

      // Merge: union
      final mergedBadges = {...localBadges, ...cloudBadges}.toList();

      // Sauvegarder dans le cloud
      await docRef.set({
        'unlocked': mergedBadges,
        'lastSync': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      debugPrint('✅ Badges synchronisés: ${mergedBadges.length}');
    } catch (e) {
      debugPrint('❌ Erreur sync badges: $e');
      rethrow;
    }
  }

  /// Synchroniser la répétition espacée
  Future<void> _syncSpacedRepetition() async {
    try {
      final srService = SpacedRepetitionService();
      final docRef = _firestore.collection('users').doc(_userId).collection('data').doc('spaced_repetition');

      // Upload local → Cloud
      final localCards = srService.cards.map((ficheId, card) {
        return MapEntry(ficheId, {
          'interval': card.interval,
          'easeFactor': card.easeFactor,
          'repetitions': card.repetitions,
          'nextReviewDate': card.nextReviewDate.millisecondsSinceEpoch,
        });
      }).cast<String, Map<String, dynamic>>();

      // Récupérer cloud data
      final cloudDoc = await docRef.get();
      final cloudCards = cloudDoc.data()?['cards'] as Map<String, dynamic>? ?? {};

      // Merge: garder le plus récent (nextReviewDate)
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

      // Sauvegarder dans le cloud
      await docRef.set({
        'cards': mergedCards,
        'lastSync': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      debugPrint('✅ Répétition espacée synchronisée: ${mergedCards.length} cartes');
    } catch (e) {
      debugPrint('❌ Erreur sync répétition espacée: $e');
      rethrow;
    }
  }

  /// Synchroniser la progression des leçons
  Future<void> _syncLeconProgress() async {
    try {
      final leconService = LeconProgressService();
      final docRef = _firestore.collection('users').doc(_userId).collection('data').doc('lecon_progress');

      // Upload local → Cloud
      final localProgress = leconService.progress.map((leconId, prog) {
        return MapEntry(leconId, {
          'completed': prog.completed,
          'exercicesCompleted': prog.exercicesCompleted,
          'lastStudied': prog.lastStudied?.millisecondsSinceEpoch,
        });
      }).cast<String, Map<String, dynamic>>();

      // Récupérer cloud data
      final cloudDoc = await docRef.get();
      final cloudProgress = cloudDoc.data()?['progress'] as Map<String, dynamic>? ?? {};

      // Merge
      final mergedProgress = <String, Map<String, dynamic>>{};
      
      localProgress.forEach((leconId, progData) {
        mergedProgress[leconId] = progData;
      });

      cloudProgress.forEach((leconId, cloudData) {
        if (cloudData is Map<String, dynamic>) {
          final localDate = localProgress[leconId]?['lastStudied'] as int? ?? 0;
          final cloudDate = cloudData['lastStudied'] as int? ?? 0;
          
          if (cloudDate > localDate) {
            mergedProgress[leconId] = cloudData;
          }
        }
      });

      // Sauvegarder dans le cloud
      await docRef.set({
        'progress': mergedProgress,
        'lastSync': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      debugPrint('✅ Progression leçons synchronisée: ${mergedProgress.length}');
    } catch (e) {
      debugPrint('❌ Erreur sync leçons: $e');
      rethrow;
    }
  }

  /// Synchroniser les résultats d'examens blancs
  Future<void> _syncExamenResults() async {
    try {
      final examenService = ExamenBlancService();
      final docRef = _firestore.collection('users').doc(_userId).collection('data').doc('examen_results');

      // Upload local → Cloud
      final localResults = examenService.results.map((result) {
        return {
          'examenId': result.examenId,
          'note': result.note,
          'dureeEffective': result.dureeEffective,
          'date': result.date.millisecondsSinceEpoch,
          'termine': result.termine,
          'reponses': result.reponses,
        };
      }).toList();

      // Récupérer cloud data
      final cloudDoc = await docRef.get();
      final cloudResults = (cloudDoc.data()?['results'] as List<dynamic>?)
          ?.map((e) => e as Map<String, dynamic>)
          .toList() ?? [];

      // Merge: garder tous les résultats (dédupliquer par examenId + date)
      final mergedResultsMap = <String, Map<String, dynamic>>{};
      
      for (var result in [...localResults, ...cloudResults]) {
        final key = '${result['examenId']}_${result['date']}';
        if (!mergedResultsMap.containsKey(key)) {
          mergedResultsMap[key] = result;
        }
      }

      final mergedResults = mergedResultsMap.values.toList()
        ..sort((a, b) => (b['date'] as int).compareTo(a['date'] as int));

      // Sauvegarder dans le cloud
      await docRef.set({
        'results': mergedResults.take(50).toList(), // Garder les 50 derniers
        'lastSync': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      debugPrint('✅ Résultats examens synchronisés: ${mergedResults.length}');
    } catch (e) {
      debugPrint('❌ Erreur sync examens: $e');
      rethrow;
    }
  }

  /// Forcer une synchronisation maintenant
  Future<void> forceSyncNow() async {
    debugPrint('🔄 Synchronisation forcée...');
    await syncAll();
  }

  /// Réinitialiser toutes les données cloud (dangereux !)
  Future<void> deleteAllCloudData() async {
    if (_userId == null) return;

    try {
      final dataCollection = _firestore.collection('users').doc(_userId).collection('data');
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

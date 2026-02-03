import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import '../models/wellness_model.dart';

class WellnessService extends ChangeNotifier {
  static final WellnessService _instance = WellnessService._internal();
  factory WellnessService() => _instance;
  WellnessService._internal();

  List<StudySession> _sessions = [];
  List<WellnessAlert> _alerts = [];
  DateTime? _lastBreakReminder;

  List<StudySession> get sessions => _sessions;
  List<WellnessAlert> get activeAlerts => 
      _alerts.where((a) => !a.dismissed).toList();

  /// Enregistre une session d'étude
  Future<void> recordSession(StudySession session) async {
    _sessions.insert(0, session);
    
    // Garder seulement les 90 derniers jours
    final cutoff = DateTime.now().subtract(const Duration(days: 90));
    _sessions.removeWhere((s) => s.debut.isBefore(cutoff));
    
    await _saveSessions();
    _checkForAlerts();
    notifyListeners();
  }

  /// Vérifie et génère des alertes si nécessaire
  void _checkForAlerts() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    
    // Sessions d'aujourd'hui
    final todaySessions = _sessions.where((s) {
      final sessionDate = DateTime(s.debut.year, s.debut.month, s.debut.day);
      return sessionDate == today;
    }).toList();

    // 1. Alerte de session trop longue (>3h sans pause)
    for (var session in todaySessions) {
      if (session.dureeMinutes > 180 && (session.pausesPrises ?? 0) == 0) {
        _createAlert(
          type: 'fatigue',
          severite: 'warning',
          titre: 'Session longue détectée',
          message: 'Vous avez étudié ${session.dureeMinutes} minutes sans pause',
          recommandations: [
            'Prenez une pause de 15-20 minutes',
            'Hydratez-vous',
            'Faites quelques étirements',
          ],
        );
      }
    }

    // 2. Alerte de surcharge (>8h par jour)
    final tempsTotalAujourdhui = todaySessions
        .map((s) => s.dureeMinutes)
        .fold(0, (a, b) => a + b);
    
    if (tempsTotalAujourdhui > 480) {
      _createAlert(
        type: 'surcharge',
        severite: 'critical',
        titre: 'Surcharge détectée',
        message: 'Vous avez étudié ${(tempsTotalAujourdhui / 60).toStringAsFixed(1)}h aujourd\'hui',
        recommandations: [
          'Arrêtez-vous pour aujourd\'hui',
          'Le surmenage diminue l\'efficacité',
          'Reposez-vous pour mieux assimiler',
        ],
      );
    }

    // 3. Alerte de concentration faible
    final recentSessions = _sessions.take(5).toList();
    if (recentSessions.length >= 3) {
      final avgConcentration = recentSessions
          .map((s) => s.concentrationNote)
          .fold(0, (a, b) => a + b) / recentSessions.length;
      
      if (avgConcentration < 2.5) {
        _createAlert(
          type: 'fatigue',
          severite: 'warning',
          titre: 'Concentration en baisse',
          message: 'Votre concentration semble diminuer ces dernières sessions',
          recommandations: [
            'Prenez une pause plus longue',
            'Changez de matière ou d\'activité',
            'Considérez une journée de repos',
          ],
        );
      }
    }

    // 4. Alerte de manque de repos
    final last7Days = _sessions.where((s) {
      return s.debut.isAfter(now.subtract(const Duration(days: 7)));
    }).toList();
    
    final groupedByDay = <DateTime, List<StudySession>>{};
    for (var session in last7Days) {
      final day = DateTime(session.debut.year, session.debut.month, session.debut.day);
      groupedByDay.putIfAbsent(day, () => []).add(session);
    }
    
    if (groupedByDay.length >= 7) {
      _createAlert(
        type: 'repos',
        severite: 'warning',
        titre: 'Pas de jour de repos',
        message: 'Vous avez travaillé tous les jours cette semaine',
        recommandations: [
          'Prenez au moins 1 jour de repos complet par semaine',
          'Le repos améliore la mémorisation',
          'Prévoyez une activité relaxante',
        ],
      );
    }
  }

  /// Crée une alerte
  void _createAlert({
    required String type,
    required String severite,
    required String titre,
    required String message,
    required List<String> recommandations,
  }) {
    // Éviter les doublons récents (même type dans les dernières 24h)
    final cutoff = DateTime.now().subtract(const Duration(hours: 24));
    final recentSame = _alerts.any((a) => 
      a.type == type && a.date.isAfter(cutoff) && !a.dismissed
    );
    
    if (recentSame) return;

    final alert = WellnessAlert(
      id: 'alert_${DateTime.now().millisecondsSinceEpoch}',
      date: DateTime.now(),
      type: type,
      severite: severite,
      titre: titre,
      message: message,
      recommandations: recommandations,
    );

    _alerts.insert(0, alert);
    _saveAlerts();
    notifyListeners();
  }

  /// Marque une alerte comme lue
  Future<void> dismissAlert(String alertId) async {
    final index = _alerts.indexWhere((a) => a.id == alertId);
    if (index != -1) {
      _alerts[index] = WellnessAlert(
        id: _alerts[index].id,
        date: _alerts[index].date,
        type: _alerts[index].type,
        severite: _alerts[index].severite,
        titre: _alerts[index].titre,
        message: _alerts[index].message,
        recommandations: _alerts[index].recommandations,
        dismissed: true,
      );
      await _saveAlerts();
      notifyListeners();
    }
  }

  /// Calcule les statistiques de bien-être
  WellnessStatistics getStatistics() {
    if (_sessions.isEmpty) {
      return WellnessStatistics(
        tempsEtudeMoyenParJour: 0,
        nombreSessionsParJour: 0,
        concentrationMoyenne: 0,
        joursRepos: 0,
        alertesActivees: 0,
        risqueBurnout: 0,
      );
    }

    final now = DateTime.now();
    final last30Days = _sessions.where((s) {
      return s.debut.isAfter(now.subtract(const Duration(days: 30)));
    }).toList();

    // Calculer le temps moyen par jour
    final groupedByDay = <DateTime, List<StudySession>>{};
    for (var session in last30Days) {
      final day = DateTime(session.debut.year, session.debut.month, session.debut.day);
      groupedByDay.putIfAbsent(day, () => []).add(session);
    }

    final tempsMoyen = groupedByDay.values
        .map((sessions) => sessions.map((s) => s.dureeMinutes).fold(0, (a, b) => a + b))
        .fold(0, (a, b) => a + b) / (groupedByDay.length > 0 ? groupedByDay.length : 1);

    final sessionsMoyennes = last30Days.length / (groupedByDay.length > 0 ? groupedByDay.length : 1);

    final concentrationMoyenne = last30Days
        .map((s) => s.concentrationNote)
        .fold(0, (a, b) => a + b) / (last30Days.length > 0 ? last30Days.length : 1);

    final joursRepos = 30 - groupedByDay.length;

    // Calcul du risque de burnout
    double risque = 0;
    
    // Facteur 1: Temps moyen trop élevé
    if (tempsMoyen > 480) risque += 30; // >8h/jour
    else if (tempsMoyen > 360) risque += 20; // >6h/jour
    
    // Facteur 2: Manque de repos
    if (joursRepos < 2) risque += 25;
    else if (joursRepos < 4) risque += 15;
    
    // Facteur 3: Concentration en baisse
    if (concentrationMoyenne < 2.5) risque += 20;
    else if (concentrationMoyenne < 3) risque += 10;
    
    // Facteur 4: Alertes non résolues
    final activeAlertsCount = activeAlerts.length;
    risque += activeAlertsCount * 5;

    return WellnessStatistics(
      tempsEtudeMoyenParJour: tempsMoyen.round(),
      nombreSessionsParJour: sessionsMoyennes.round(),
      concentrationMoyenne: concentrationMoyenne,
      joursRepos: joursRepos,
      alertesActivees: activeAlertsCount,
      risqueBurnout: risque.clamp(0, 100),
    );
  }

  /// Suggère une pause intelligente
  bool shouldTakeBreak() {
    final now = DateTime.now();
    
    // Si dernière pause il y a plus de 2h
    if (_lastBreakReminder != null) {
      final elapsed = now.difference(_lastBreakReminder!);
      if (elapsed.inMinutes < 120) {
        return false;
      }
    }

    // Vérifier si en session longue
    final todaySessions = _sessions.where((s) {
      final sessionDate = DateTime(s.debut.year, s.debut.month, s.debut.day);
      final today = DateTime(now.year, now.month, now.day);
      return sessionDate == today;
    }).toList();

    final tempsAujourdhui = todaySessions
        .map((s) => s.dureeMinutes)
        .fold(0, (a, b) => a + b);

    return tempsAujourdhui >= 120; // Après 2h de travail
  }

  /// Marque qu'on a pris une pause
  void recordBreak() {
    _lastBreakReminder = DateTime.now();
  }

  // Persistance
  Future<File> _getSessionsFile() async {
    final dir = await getApplicationDocumentsDirectory();
    return File('${dir.path}/study_sessions.json');
  }

  Future<File> _getAlertsFile() async {
    final dir = await getApplicationDocumentsDirectory();
    return File('${dir.path}/wellness_alerts.json');
  }

  Future<void> loadData() async {
    await Future.wait([
      _loadSessions(),
      _loadAlerts(),
    ]);
  }

  Future<void> _loadSessions() async {
    try {
      final file = await _getSessionsFile();
      if (await file.exists()) {
        final content = await file.readAsString();
        final data = jsonDecode(content) as List<dynamic>;
        _sessions = data
            .map((e) => StudySession.fromJson(e as Map<String, dynamic>))
            .toList();
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Erreur chargement sessions: $e');
    }
  }

  Future<void> _loadAlerts() async {
    try {
      final file = await _getAlertsFile();
      if (await file.exists()) {
        final content = await file.readAsString();
        final data = jsonDecode(content) as List<dynamic>;
        _alerts = data
            .map((e) => WellnessAlert.fromJson(e as Map<String, dynamic>))
            .toList();
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Erreur chargement alertes: $e');
    }
  }

  Future<void> _saveSessions() async {
    try {
      final file = await _getSessionsFile();
      final data = _sessions.map((e) => e.toJson()).toList();
      await file.writeAsString(jsonEncode(data));
    } catch (e) {
      debugPrint('Erreur sauvegarde sessions: $e');
    }
  }

  Future<void> _saveAlerts() async {
    try {
      final file = await _getAlertsFile();
      final data = _alerts.map((e) => e.toJson()).toList();
      await file.writeAsString(jsonEncode(data));
    } catch (e) {
      debugPrint('Erreur sauvegarde alertes: $e');
    }
  }
}

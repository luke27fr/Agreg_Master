import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:agreg_master/constants/app_constants.dart';
import 'package:agreg_master/pages/home_navigation_page.dart';
import 'package:agreg_master/services/score_service.dart';
import 'package:agreg_master/services/favorites_service.dart';
import 'package:agreg_master/services/notes_service.dart';
import 'package:agreg_master/services/settings_service.dart';
import 'package:agreg_master/services/reading_service.dart';
import 'package:agreg_master/services/streak_service.dart';
import 'package:agreg_master/services/badge_service.dart';
import 'package:agreg_master/services/spaced_repetition_service.dart';
import 'package:agreg_master/services/lecon_progress_service.dart';
import 'package:agreg_master/services/examen_blanc_service.dart';
import 'package:agreg_master/services/mind_map_service.dart';
import 'package:agreg_master/services/smart_planner_service.dart';
import 'package:agreg_master/services/jury_virtuel_service.dart';
import 'package:agreg_master/services/structured_notes_service.dart';
import 'package:agreg_master/services/competition_service.dart';
import 'package:agreg_master/services/wellness_service.dart';
import 'package:agreg_master/services/maths_intuitives_service.dart';
import 'package:agreg_master/services/annales_service.dart';
import 'package:agreg_master/services/backup_service.dart';
import 'package:agreg_master/services/subscription_service.dart';
import 'package:agreg_master/services/cloud_sync_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Firebase.initializeApp();

    if (!kIsWeb) {
      // Crashlytics is not supported on web
      FlutterError.onError = (errorDetails) {
        FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
      };
      PlatformDispatcher.instance.onError = (error, stack) {
        FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
        return true;
      };
      await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(!kDebugMode);
    }

    await FirebaseAnalytics.instance.setAnalyticsCollectionEnabled(!kDebugMode);

    // Anonymous auth to get a stable user ID for RevenueCat cross-platform sync
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        final credential = await FirebaseAuth.instance
            .signInAnonymously()
            .timeout(const Duration(seconds: 5));
        user = credential.user;
      }
      debugPrint('Firebase Auth: uid=${user?.uid}');
    } catch (e) {
      debugPrint('Firebase Auth non disponible: $e');
    }

    debugPrint('Firebase initialisé');
  } catch (e) {
    debugPrint('Firebase non disponible: $e');
  }

  runApp(const AgregMasterApp());
}

/// Charge tous les services en arrière-plan
Future<void> _initializeAllServices() async {
  // Charger les services de données (non-bloquants, rapides)
  await Future.wait([
    ScoreService().loadScores(),
    FavoritesService().loadFavorites(),
    NotesService().loadNotes(),
    SettingsService().loadSettings(),
    ReadingService().loadReadingProgress(),
    StreakService().loadData(),
    BadgeService().loadData(),
    SpacedRepetitionService().loadData(),
    LeconProgressService().loadData(),
    ExamenBlancService().loadExamens(),
    ExamenBlancService().loadResults(),
    MindMapService().loadMindMap(),
    AnnalesService().loadAnnales(),
    BackupService().loadBackupInfo(),
    SmartPlannerService().loadData(),
    JuryVirtuelService().loadData(),
    StructuredNotesService().loadData(),
    CompetitionService().loadData(),
    WellnessService().loadData(),
    MathsIntuitivesService().loadConcepts(),
  ]);

  // Initialiser RevenueCat en arrière-plan (ne bloque pas le démarrage)
  // Si ça échoue ou prend trop de temps, l'app démarre quand même.
  _initializeSubscriptions();

  if (!kIsWeb) {
    CloudSyncService().initialize();
  }
}

/// Initialise RevenueCat sans bloquer le démarrage de l'app
Future<void> _initializeSubscriptions() async {
  try {
    final firebaseUser = FirebaseAuth.instance.currentUser;
    final appUserID = firebaseUser?.uid;
    await SubscriptionService()
        .initialize(appUserID: appUserID)
        .timeout(const Duration(seconds: 10), onTimeout: () {
      debugPrint('RevenueCat init timeout - app continue sans abonnements');
    });
  } catch (e) {
    debugPrint('RevenueCat init error (non-bloquant): $e');
  }
}

// ============================================================================
// Modèle ThemeItem - utilisé dans toute l'application
// ============================================================================
class ThemeItem {
  final String id;
  final String label;
  final String path;
  final List<String> files;

  const ThemeItem({
    required this.id,
    required this.label,
    required this.path,
    required this.files,
  });

  factory ThemeItem.fromJson(Map<String, dynamic> json) {
    return ThemeItem(
      id: json['id'] as String,
      label: json['label'] as String,
      path: json['path'] as String,
      files: (json['files'] as List<dynamic>?)?.map((e) => e as String).toList() ?? [],
    );
  }
}

// ============================================================================
// Application principale
// ============================================================================
class AgregMasterApp extends StatefulWidget {
  const AgregMasterApp({super.key});

  @override
  State<AgregMasterApp> createState() => _AgregMasterAppState();
}

class _AgregMasterAppState extends State<AgregMasterApp> {
  final SettingsService _settingsService = SettingsService();
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _settingsService.addListener(_onSettingsChanged);
    _loadServices();
  }

  Future<void> _loadServices() async {
    await _initializeAllServices();
    if (mounted) {
      setState(() => _isInitialized = true);
    }
  }

  @override
  void dispose() {
    _settingsService.removeListener(_onSettingsChanged);
    super.dispose();
  }

  void _onSettingsChanged() {
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppStrings.appName,
      debugShowCheckedModeBanner: false,
      themeMode: _settingsService.themeMode,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primaryDark,
          primary: AppColors.primaryDark,
          surface: AppColors.surfaceLight,
          brightness: Brightness.light,
        ),
        useMaterial3: true,
        textTheme: GoogleFonts.poppinsTextTheme(),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          foregroundColor: AppColors.primaryDark,
          elevation: 0,
          centerTitle: false,
          titleTextStyle: TextStyle(
            color: AppColors.primaryDark,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        cardTheme: CardThemeData(
          elevation: 4,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        ),
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primaryDark,
          primary: AppColors.primaryLight,
          surface: AppColors.surfaceDark,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
        textTheme: GoogleFonts.poppinsTextTheme(ThemeData.dark().textTheme),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.white,
          elevation: 0,
          centerTitle: false,
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        cardTheme: CardThemeData(
          elevation: 4,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          color: AppColors.cardDark,
        ),
      ),
      home: _isInitialized ? const HomeNavigationPage() : const SplashScreen(),
    );
  }
}

// ============================================================================
// Splash Screen
// ============================================================================
class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [AppColors.primaryDark, AppColors.primaryLight, AppColors.primaryAccent],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white.withAlpha(30),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.school, size: 72, color: Colors.white, semanticLabel: 'Agreg Master'),
            ),
            const SizedBox(height: 32),
            Text(
              AppStrings.appName,
              style: GoogleFonts.poppins(
                fontSize: 36,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              AppStrings.appTagline,
              style: GoogleFonts.poppins(fontSize: 16, color: Colors.white70),
            ),
            const SizedBox(height: 48),
            const SizedBox(
              width: 48,
              height: 48,
              child: CircularProgressIndicator(color: Colors.white, strokeWidth: 3),
            ),
            const SizedBox(height: 16),
            Text(
              'Chargement...',
              style: GoogleFonts.poppins(fontSize: 14, color: Colors.white54),
            ),
          ],
        ),
      ),
    );
  }
}

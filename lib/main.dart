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
import 'package:agreg_master/services/content_update_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:agreg_master/services/analytics_service.dart';

const String _sentryDsn = 'https://33cb52a92c996965518833249f93a715@o4510852621205504.ingest.de.sentry.io/4510923076141136';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await _initializeFirebase();

  _initializeAuthAndSubscriptions();

  if (kIsWeb && !kDebugMode) {
    await SentryFlutter.init(
      (options) {
        options.dsn = _sentryDsn;
        options.environment = 'production';
        options.tracesSampleRate = 0.2;
      },
      appRunner: () => runApp(const AgregMasterApp()),
    );
  } else {
    runApp(const AgregMasterApp());
  }
}

Future<void> _initializeFirebase() async {
  try {
    if (kIsWeb) {
      await Firebase.initializeApp(
        options: const FirebaseOptions(
          apiKey: 'AIzaSyC5kcLyzmiEnou4DjXnAYua2iG6GWlAs34',
          appId: '1:189782425075:web:300d849818868809cea686',
          messagingSenderId: '189782425075',
          projectId: 'agreg-master-prod',
          authDomain: 'agreg-master-prod.firebaseapp.com',
          storageBucket: 'agreg-master-prod.firebasestorage.app',
          measurementId: 'G-2DJGQ749PC',
        ),
      );
    } else {
      await Firebase.initializeApp();
    }
    debugPrint('Firebase initialisé avec succès');

    if (!kIsWeb) {
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
    debugPrint('Firebase initialisé');
  } catch (e) {
    debugPrint('Firebase non disponible: $e');
  }
}

/// Auth and RevenueCat load in background without blocking the UI
Future<void> _initializeAuthAndSubscriptions() async {
  try {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      final credential = await FirebaseAuth.instance
          .signInAnonymously()
          .timeout(const Duration(seconds: 5));
      user = credential.user;
    }
    debugPrint('Firebase Auth: uid=${user?.uid}');

    if (kIsWeb && !kDebugMode && user != null) {
      Sentry.configureScope((scope) {
        scope.setUser(SentryUser(
          id: user!.uid,
          email: user.email,
        ));
        scope.setTag('premium', SubscriptionService().isPremium.toString());
      });
    }
  } catch (e) {
    debugPrint('Firebase Auth non disponible: $e');
  }
  _initializeSubscriptions();
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

  CloudSyncService().initialize();
  if (!kIsWeb) {
    ContentUpdateService().initialize();
  }
}

/// Initialise RevenueCat sans bloquer le démarrage de l'app
Future<void> _initializeSubscriptions() async {
  try {
    final firebaseUser = FirebaseAuth.instance.currentUser;
    final appUserID = firebaseUser?.uid;
    await SubscriptionService()
        .initialize(appUserID: appUserID)
        .timeout(Duration(seconds: kIsWeb ? 30 : 10), onTimeout: () {
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

  @override
  void initState() {
    super.initState();
    _settingsService.addListener(_onSettingsChanged);
    _loadServices();
  }

  Future<void> _loadServices() async {
    // Settings first (fast, needed for correct theme)
    await SettingsService().loadSettings();
    if (mounted) setState(() {});
    // All other services load in background — UI updates reactively
    _initializeAllServices();
  }

  @override
  void dispose() {
    _settingsService.removeListener(_onSettingsChanged);
    super.dispose();
  }

  void _onSettingsChanged() {
    if (mounted) setState(() {});
  }

  List<NavigatorObserver> _buildObservers() {
    try {
      return [AnalyticsService().observer];
    } catch (e) {
      debugPrint('Analytics observer unavailable: $e');
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppStrings.appName,
      debugShowCheckedModeBanner: false,
      navigatorObservers: _buildObservers(),
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
      home: const HomeNavigationPage(),
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

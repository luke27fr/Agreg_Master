import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../main.dart'; // ThemeItem
import '../../constants/app_constants.dart';
import '../../utils/theme_utils.dart';
import '../../utils/manifest_loader.dart';
import '../../utils/quiz_loader.dart';
import '../../widgets/shared_widgets.dart';
import '../../fiche_page.dart';
import '../search_page.dart';
import '../settings_page.dart';
import '../review_page.dart';
import '../flashcards_page.dart';
import '../spaced_repetition_page.dart';
import '../fiches_list_screen.dart';
import '../examen_blanc_page.dart';
import '../oral_simulation_page.dart';
import '../jury_virtuel_page.dart';
import '../annales_page.dart';
import '../annales_pedagogiques_page.dart';
import '../simulation_page.dart';
import '../exercices_page.dart';
import '../lecons_page.dart';
import '../developpements_page.dart';
import '../demonstrations_page.dart';
import '../contre_exemples_page.dart';
import '../maths_intuitives_page.dart';
import '../mind_map_page.dart';
import '../bibliotheque_ideale_page.dart';
import '../conseils_agreg_page.dart';
import '../../services/conseils_data.dart';
import '../../services/score_service.dart';
import '../../services/favorites_service.dart';
import '../../services/streak_service.dart';
import '../../services/spaced_repetition_service.dart';
import '../../services/wellness_service.dart';
import '../../services/reading_service.dart';
import '../../services/auth_service.dart';

class AccueilTab extends StatefulWidget {
  final void Function(int tabIndex)? onNavigateToTab;

  const AccueilTab({super.key, this.onNavigateToTab});

  @override
  State<AccueilTab> createState() => _AccueilTabState();
}

class _AccueilTabState extends State<AccueilTab> {
  final ScoreService _scoreService = ScoreService();
  final FavoritesService _favoritesService = FavoritesService();
  final StreakService _streakService = StreakService();
  final SpacedRepetitionService _srsService = SpacedRepetitionService();
  final WellnessService _wellnessService = WellnessService();
  final ReadingService _readingService = ReadingService();
  final AuthService _authService = AuthService();
  int _totalFiches = 0;
  List<ThemeItem> _themes = [];

  @override
  void initState() {
    super.initState();
    _authService.addListener(_onChanged);
    _loadManifest();
    _showWelcomeIfFirstLaunch().catchError((_) {});
    _scoreService.addListener(_onChanged);
    _streakService.addListener(_onChanged);
    _srsService.addListener(_onChanged);
    _wellnessService.addListener(_onChanged);
    _favoritesService.addListener(_onChanged);
    _readingService.addListener(_onChanged);
  }

  @override
  void dispose() {
    _authService.removeListener(_onChanged);
    _scoreService.removeListener(_onChanged);
    _streakService.removeListener(_onChanged);
    _srsService.removeListener(_onChanged);
    _wellnessService.removeListener(_onChanged);
    _favoritesService.removeListener(_onChanged);
    _readingService.removeListener(_onChanged);
    super.dispose();
  }

  void _onChanged() {
    if (mounted) setState(() {});
  }

  Future<void> _loadManifest() async {
    try {
      final results = await Future.wait([
        ManifestLoader.getTotalFiches(),
        ManifestLoader.loadThemes(),
      ]);
      if (mounted) {
        setState(() {
          _totalFiches = results[0] as int;
          _themes = results[1] as List<ThemeItem>;
        });
      }
    } catch (e) {
      debugPrint('Erreur chargement manifest: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text(AppStrings.errorLoadingData)),
        );
      }
    }
  }

  bool get _showAppleSignIn =>
      kIsWeb || defaultTargetPlatform == TargetPlatform.iOS;

  Future<void> _showWelcomeIfFirstLaunch() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      if (prefs.getBool('welcome_shown') == true) return;
      await prefs.setBool('welcome_shown', true);

      if (!mounted || _authService.isSignedIn) return;

      await Future.delayed(const Duration(milliseconds: 1200));
      if (!mounted) return;

    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        bool loading = false;
        return StatefulBuilder(builder: (ctx, setSheetState) {
          return Container(
            padding: const EdgeInsets.fromLTRB(24, 28, 24, 32),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            ),
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              Container(
                width: 40, height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 20),
              const Icon(Icons.waving_hand, size: 48, color: Colors.amber),
              const SizedBox(height: 16),
              const Text(
                'Bienvenue sur Agreg Master !',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Text(
                'Connectez-vous pour synchroniser votre progression sur tous vos appareils (iOS, Android, Web).',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              ),
              const SizedBox(height: 24),
              if (loading)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  child: CircularProgressIndicator(),
                )
              else ...[
                SizedBox(
                  width: double.infinity, height: 48,
                  child: ElevatedButton.icon(
                    onPressed: () async {
                      setSheetState(() => loading = true);
                      try {
                        await _authService.signInWithGoogle();
                        if (ctx.mounted) Navigator.pop(ctx);
                      } catch (e) {
                        setSheetState(() => loading = false);
                      }
                    },
                    icon: const Icon(Icons.g_mobiledata, size: 24),
                    label: const Text('Continuer avec Google',
                        style: TextStyle(fontWeight: FontWeight.w600)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black87,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(color: Colors.grey[300]!),
                      ),
                    ),
                  ),
                ),
                if (_showAppleSignIn) ...[
                  const SizedBox(height: 10),
                  SizedBox(
                    width: double.infinity, height: 48,
                    child: ElevatedButton.icon(
                      onPressed: () async {
                        setSheetState(() => loading = true);
                        try {
                          await _authService.signInWithApple();
                          if (ctx.mounted) Navigator.pop(ctx);
                        } catch (e) {
                          setSheetState(() => loading = false);
                        }
                      },
                      icon: const Icon(Icons.apple, size: 24),
                      label: const Text('Continuer avec Apple',
                          style: TextStyle(fontWeight: FontWeight.w600)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                ],
                const SizedBox(height: 16),
                TextButton(
                  onPressed: () => Navigator.pop(ctx),
                  child: Text(
                    'Plus tard',
                    style: TextStyle(color: Colors.grey[500], fontSize: 14),
                  ),
                ),
              ],
            ]),
          );
        });
      },
    );
    } catch (e) {
      debugPrint('Welcome sheet error: $e');
    }
  }

  void _showSignInSheet() {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        bool loading = false;
        return StatefulBuilder(builder: (ctx, setSheetState) {
          return Container(
            padding: const EdgeInsets.fromLTRB(24, 28, 24, 32),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            ),
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              Container(
                width: 40, height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 20),
              const Icon(Icons.cloud_sync, size: 48, color: Colors.indigo),
              const SizedBox(height: 16),
              const Text(
                'Synchronisez vos données',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Text(
                'Connectez-vous pour retrouver votre progression et votre abonnement sur tous vos appareils.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              ),
              const SizedBox(height: 24),
              if (loading)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  child: CircularProgressIndicator(),
                )
              else ...[
                SizedBox(
                  width: double.infinity, height: 48,
                  child: ElevatedButton.icon(
                    onPressed: () async {
                      setSheetState(() => loading = true);
                      try {
                        await _authService.signInWithGoogle();
                        if (ctx.mounted) Navigator.pop(ctx);
                      } catch (e) {
                        setSheetState(() => loading = false);
                      }
                    },
                    icon: const Icon(Icons.g_mobiledata, size: 24),
                    label: const Text('Continuer avec Google',
                        style: TextStyle(fontWeight: FontWeight.w600)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black87,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(color: Colors.grey[300]!),
                      ),
                    ),
                  ),
                ),
                if (_showAppleSignIn) ...[
                  const SizedBox(height: 10),
                  SizedBox(
                    width: double.infinity, height: 48,
                    child: ElevatedButton.icon(
                      onPressed: () async {
                        setSheetState(() => loading = true);
                        try {
                          await _authService.signInWithApple();
                          if (ctx.mounted) Navigator.pop(ctx);
                        } catch (e) {
                          setSheetState(() => loading = false);
                        }
                      },
                      icon: const Icon(Icons.apple, size: 24),
                      label: const Text('Continuer avec Apple',
                          style: TextStyle(fontWeight: FontWeight.w600)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                ],
                const SizedBox(height: 16),
                TextButton(
                  onPressed: () => Navigator.pop(ctx),
                  child: Text(
                    'Annuler',
                    style: TextStyle(color: Colors.grey[500], fontSize: 14),
                  ),
                ),
              ],
            ]),
          );
        });
      },
    );
  }

  void _showFavoritesSheet() async {
    final favorites = _favoritesService.favorites.toList();
    if (favorites.isEmpty) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text(AppStrings.errorNoFavorites)),
        );
      }
      return;
    }
    try {
      final pathMap = await ManifestLoader.getPathMap();
      if (!mounted) return;

      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        builder: (ctx) => DraggableScrollableSheet(
          initialChildSize: 0.5, minChildSize: 0.3, maxChildSize: 0.9, expand: false,
          builder: (_, controller) => Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(children: [
                  const Icon(Icons.star, color: Colors.amber),
                  const SizedBox(width: 8),
                  Text('Mes Favoris (${favorites.length})',
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ]),
              ),
              Expanded(
                child: ListView.builder(
                  controller: controller,
                  itemCount: favorites.length,
                  itemBuilder: (_, index) {
                    final ficheId = favorites[index];
                    final path = pathMap[ficheId];
                    return ListTile(
                      leading: const Icon(Icons.article),
                      title: Text(ThemeUtils.getFicheTitle(ficheId)),
                      onTap: path != null ? () {
                        Navigator.pop(ctx);
                        Navigator.push(context, MaterialPageRoute(builder: (_) => FichePage(assetPath: path)));
                      } : null,
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      );
    } catch (e) {
      debugPrint('Erreur chargement favoris: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text(AppStrings.errorLoadingData)),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = ThemeUtils.isDark(context);
    final globalAvg = _scoreService.getGlobalAverage();
    final completedCount = _scoreService.scores.length;
    final streak = _streakService.currentStreak;
    final longestStreak = _streakService.longestStreak;
    final dueCards = _srsService.getDueCards().length;
    final reviewCount = _scoreService.getFichesToReview().length;
    final favCount = _favoritesService.favorites.length;
    final pepiteDuJour = ConseilsData.getPepiteDuJour();
    final pepiteIndex = ConseilsData.getPepiteIndex();

    return SafeArea(
      child: CustomScrollView(
        slivers: [
          // ================================================================
          // Header
          // ================================================================
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Bonjour !", style: TextStyle(fontSize: 15, color: Colors.grey[500])),
                      const SizedBox(height: 2),
                      Text(AppStrings.appName, style: TextStyle(
                        fontSize: 28, fontWeight: FontWeight.bold,
                        color: ThemeUtils.titleColor(context),
                      )),
                    ],
                  ),
                  Row(children: [
                    if (_authService.isAnonymous)
                      IconButton(
                        icon: const Icon(Icons.login_rounded),
                        tooltip: 'Se connecter',
                        onPressed: _showSignInSheet,
                      ),
                    IconButton(
                      icon: const Icon(Icons.search),
                      tooltip: 'Rechercher',
                      onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SearchPage())),
                    ),
                    IconButton(
                      icon: const Icon(Icons.settings_outlined),
                      tooltip: 'Paramètres',
                      onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SettingsPage())),
                    ),
                  ]),
                ],
              ),
            ),
          ),

          // Wellness alert
          if (_wellnessService.activeAlerts.isNotEmpty)
            SliverToBoxAdapter(
              child: Semantics(
                liveRegion: true,
                child: Container(
                  margin: const EdgeInsets.fromLTRB(20, 12, 20, 0),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.orange.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.orange.withValues(alpha: 0.3)),
                  ),
                  child: Row(children: [
                    const Icon(Icons.self_improvement, color: Colors.orange, size: 20, semanticLabel: 'Alerte bien-être'),
                    const SizedBox(width: 8),
                    Expanded(child: Text(
                      'Pensez à faire une pause !',
                      style: TextStyle(color: Colors.orange[800], fontSize: 13),
                    )),
                  ]),
                ),
              ),
            ),

          // ================================================================
          // Content principal
          // ================================================================
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // Streak card
                _buildStreakCard(streak, longestStreak),
                const SizedBox(height: 16),

                // Quick stats row
                Row(children: [
                  Expanded(child: StatCard(
                    icon: Icons.library_books,
                    value: '$_totalFiches',
                    label: 'Fiches',
                    color: Colors.blue,
                  )),
                  const SizedBox(width: 10),
                  Expanded(child: StatCard(
                    icon: Icons.quiz,
                    value: '$completedCount',
                    label: 'Quiz faits',
                    color: Colors.green,
                  )),
                  const SizedBox(width: 10),
                  Expanded(child: StatCard(
                    icon: Icons.trending_up,
                    value: completedCount > 0 ? '${globalAvg.round()}%' : '--',
                    label: 'Moyenne',
                    color: Colors.purple,
                  )),
                ]),

                const SizedBox(height: 20),

                // Objectives
                _buildObjectivesCard(isDark),

                const SizedBox(height: 16),

                // Actions rapides
                Text('Actions rapides', style: TextStyle(
                  fontSize: 18, fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : Colors.black87,
                )),
                const SizedBox(height: 10),

                Row(children: [
                  Expanded(child: _buildQuickAction(
                    icon: Icons.flash_on, label: 'Quiz\nrapide', color: Colors.orange,
                    onTap: () => QuizLoader.startQuickQuiz(context), isDark: isDark,
                  )),
                  const SizedBox(width: 10),
                  Expanded(child: _buildQuickAction(
                    icon: Icons.psychology, label: 'Réviser\n($reviewCount)', color: Colors.deepPurple,
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ReviewPage())),
                    isDark: isDark,
                  )),
                  const SizedBox(width: 10),
                  Expanded(child: _buildQuickAction(
                    icon: Icons.star, label: 'Favoris\n($favCount)', color: Colors.amber,
                    onTap: _showFavoritesSheet, isDark: isDark,
                  )),
                  const SizedBox(width: 10),
                  Expanded(child: _buildQuickAction(
                    icon: Icons.style, label: 'Flash\ncards', color: Colors.teal,
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const FlashcardsPage())),
                    isDark: isDark,
                  )),
                ]),

                // SRS due notification
                if (dueCards > 0) ...[
                  const SizedBox(height: 16),
                  _buildSrsNotification(dueCards, isDark),
                ],

                const SizedBox(height: 24),

                // ==============================================================
                // Section Apprendre
                // ==============================================================
                SectionHeaderWithAction(
                  title: 'Apprendre',
                  onAction: widget.onNavigateToTab != null
                      ? () => widget.onNavigateToTab!(1)
                      : null,
                ),
                const SizedBox(height: 10),
              ]),
            ),
          ),

          // Scroll horizontal des matières
          SliverToBoxAdapter(
            child: _buildApprendreCarousel(isDark),
          ),

          // ==============================================================
          // Section S'entraîner
          // ==============================================================
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                SectionHeaderWithAction(
                  title: "S'entraîner",
                  onAction: widget.onNavigateToTab != null
                      ? () => widget.onNavigateToTab!(2)
                      : null,
                ),
                const SizedBox(height: 10),
              ]),
            ),
          ),

          // Scroll horizontal S'entraîner
          SliverToBoxAdapter(
            child: _buildEntrainerCarousel(isDark),
          ),

          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // Pépite du jour
                ConseilCard(
                  text: pepiteDuJour,
                  badge: '#${pepiteIndex + 1}/${ConseilsData.pepitesDuJour.length}',
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ConseilsAgregPage())),
                ),

                const SizedBox(height: 16),

                // Multiplatform banner
                _buildMultiplatformBanner(isDark),

                if (kIsWeb) ...[
                  const SizedBox(height: 16),
                  _buildStoreDownloadBanner(isDark),
                ],
              ]),
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================================================
  // Streak card
  // ==========================================================================
  Widget _buildStreakCard(int streak, int longestStreak) {
    return Semantics(
      label: streak > 0
          ? 'Streak: $streak jours de suite. Record: $longestStreak jours'
          : 'Pas de streak actif. Record: $longestStreak jours',
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: streak > 0
                ? [const Color(0xFFFF8A65), const Color(0xFFFF5722)]
                : [Colors.grey.shade400, Colors.grey.shade600],
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(children: [
          Text(streak > 0 ? '🔥' : '💤', style: const TextStyle(fontSize: 36)),
          const SizedBox(width: 14),
          Expanded(child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                streak > 0 ? '$streak jour${streak > 1 ? 's' : ''} de suite !' : 'Commencez votre streak !',
                style: const TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 2),
              Text('Record : $longestStreak jours', style: const TextStyle(color: Colors.white70, fontSize: 12)),
            ],
          )),
          if (streak > 0)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(children: [
                const Icon(Icons.local_fire_department, color: Colors.white, size: 16),
                const SizedBox(width: 4),
                Text('$streak', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ]),
            ),
        ]),
      ),
    );
  }

  // ==========================================================================
  // Objectifs du jour
  // ==========================================================================
  Widget _buildObjectivesCard(bool isDark) {
    final objectives = _streakService.todayObjectives;
    final completionRate = _streakService.getTodayCompletionRate();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: ThemeUtils.cardColor(context),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isDark ? Colors.white.withValues(alpha: 0.06) : Colors.grey.withValues(alpha: 0.12),
        ),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: Colors.green.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.flag, color: Colors.green, size: 18, semanticLabel: 'Objectifs'),
          ),
          const SizedBox(width: 10),
          const Expanded(child: Text('Objectifs du jour', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16))),
          Semantics(
            label: 'Progression: ${(completionRate * 100).round()} pourcent',
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: (completionRate >= 1 ? Colors.green : Colors.orange).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text('${(completionRate * 100).round()}%', style: TextStyle(
                fontWeight: FontWeight.bold, fontSize: 13,
                color: completionRate >= 1 ? Colors.green : Colors.orange,
              )),
            ),
          ),
        ]),
        const SizedBox(height: 12),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: completionRate,
            backgroundColor: isDark ? Colors.white.withValues(alpha: 0.08) : Colors.grey.withValues(alpha: 0.12),
            valueColor: AlwaysStoppedAnimation(completionRate >= 1 ? Colors.green : Colors.orange),
            minHeight: 6,
          ),
        ),
        const SizedBox(height: 12),
        ...objectives.values.map((obj) => Padding(
          padding: const EdgeInsets.only(bottom: 6),
          child: Semantics(
            label: '${obj.title}: ${obj.progress} sur ${obj.target}${obj.isCompleted ? ', terminé' : ''}',
            child: Row(children: [
              Icon(obj.isCompleted ? Icons.check_circle : Icons.circle_outlined,
                color: obj.isCompleted ? Colors.green : Colors.grey, size: 18),
              const SizedBox(width: 8),
              Expanded(child: Text(obj.title, style: const TextStyle(fontSize: 13))),
              Text('${obj.progress}/${obj.target}', style: TextStyle(
                fontWeight: FontWeight.bold, fontSize: 12,
                color: obj.isCompleted ? Colors.green : Colors.grey,
              )),
            ]),
          ),
        )),
      ]),
    );
  }

  // ==========================================================================
  // Quick action button
  // ==========================================================================
  Widget _buildQuickAction({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
    required bool isDark,
  }) {
    return Material(
      color: ThemeUtils.cardColor(context),
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Semantics(
          button: true,
          label: label.replaceAll('\n', ' '),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 6),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: isDark ? Colors.white.withValues(alpha: 0.06) : Colors.grey.withValues(alpha: 0.12),
              ),
            ),
            child: Column(children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: isDark ? 0.2 : 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: color, size: 22),
              ),
              const SizedBox(height: 8),
              Text(label, style: TextStyle(
                fontSize: 11, fontWeight: FontWeight.w500,
                color: isDark ? Colors.white70 : Colors.grey[700],
              ), textAlign: TextAlign.center),
            ]),
          ),
        ),
      ),
    );
  }

  // ==========================================================================
  // Multiplatform / Sign-in banner
  // ==========================================================================
  Widget _buildMultiplatformBanner(bool isDark) {
    if (_authService.isAnonymous) {
      return GestureDetector(
        onTap: _showSignInSheet,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: isDark
                  ? [const Color(0xFF1A237E), const Color(0xFF283593)]
                  : [const Color(0xFFE8EAF6), const Color(0xFFC5CAE9)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Row(children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: (isDark ? Colors.white : Colors.indigo).withAlpha(30),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(Icons.cloud_sync, size: 28,
                  color: isDark ? Colors.white : Colors.indigo[700]),
            ),
            const SizedBox(width: 14),
            Expanded(child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Connectez-vous',
                  style: TextStyle(
                    fontWeight: FontWeight.bold, fontSize: 15,
                    color: isDark ? Colors.white : Colors.indigo[800],
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  'Synchronisez progression et abonnement sur tous vos appareils.',
                  style: TextStyle(
                    fontSize: 12,
                    color: isDark ? Colors.white60 : Colors.indigo[400],
                  ),
                ),
              ],
            )),
            Icon(Icons.arrow_forward_ios, size: 16,
                color: isDark ? Colors.white38 : Colors.indigo[300]),
          ]),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDark
              ? [const Color(0xFF1A237E), const Color(0xFF283593)]
              : [const Color(0xFFE8EAF6), const Color(0xFFC5CAE9)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: (isDark ? Colors.white : Colors.indigo).withAlpha(30),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(Icons.check_circle, size: 28,
              color: Colors.green[400]),
        ),
        const SizedBox(width: 14),
        Expanded(child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Connecté — ${_authService.displayName ?? _authService.email ?? ''}',
              style: TextStyle(
                fontWeight: FontWeight.bold, fontSize: 14,
                color: isDark ? Colors.white : Colors.indigo[800],
              ),
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 3),
            Text(
              'Vos données sont synchronisées sur iOS, Android et Web.',
              style: TextStyle(
                fontSize: 12,
                color: isDark ? Colors.white60 : Colors.indigo[400],
              ),
            ),
          ],
        )),
      ]),
    );
  }

  // ==========================================================================
  // Store download banner (web only)
  // ==========================================================================
  Widget _buildStoreDownloadBanner(bool isDark) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: ThemeUtils.cardColor(context),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isDark ? Colors.white.withValues(alpha: 0.06) : Colors.grey.withValues(alpha: 0.12),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            Icon(Icons.phone_iphone, size: 20, color: isDark ? Colors.white70 : Colors.grey[700]),
            const SizedBox(width: 8),
            Text(
              'Aussi disponible sur mobile',
              style: TextStyle(
                fontWeight: FontWeight.bold, fontSize: 15,
                color: isDark ? Colors.white : Colors.black87,
              ),
            ),
          ]),
          const SizedBox(height: 12),
          Row(children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () => launchUrl(
                  Uri.parse('https://apps.apple.com/app/agreg-master/id6740000879'),
                  mode: LaunchMode.externalApplication,
                ),
                icon: const Icon(Icons.apple, size: 20),
                label: const Text('App Store', style: TextStyle(fontWeight: FontWeight.w600)),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () => launchUrl(
                  Uri.parse('https://play.google.com/store/apps/details?id=com.agregmaster.app'),
                  mode: LaunchMode.externalApplication,
                ),
                icon: const Icon(Icons.shop, size: 20),
                label: const Text('Google Play', style: TextStyle(fontWeight: FontWeight.w600)),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
              ),
            ),
          ]),
        ],
      ),
    );
  }

  // ==========================================================================
  // SRS notification
  // ==========================================================================
  Widget _buildSrsNotification(int dueCards, bool isDark) {
    return Material(
      color: Colors.deepOrange.withValues(alpha: isDark ? 0.15 : 0.04),
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SpacedRepetitionPage())),
        borderRadius: BorderRadius.circular(14),
        child: Semantics(
          button: true,
          label: '$dueCards fiches à réviser avec la répétition espacée',
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: Colors.deepOrange.withValues(alpha: 0.2)),
            ),
            child: Row(children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.deepOrange.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.psychology, color: Colors.deepOrange, size: 24),
              ),
              const SizedBox(width: 14),
              Expanded(child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('$dueCards fiche${dueCards > 1 ? 's' : ''} à réviser',
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                  const SizedBox(height: 2),
                  Text('Répétition espacée', style: TextStyle(color: Colors.grey[500], fontSize: 12)),
                ],
              )),
              const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.deepOrange),
            ]),
          ),
        ),
      ),
    );
  }

  // ==========================================================================
  // Section Apprendre — carousel horizontal (matières + outils)
  // ==========================================================================
  Widget _buildApprendreCarousel(bool isDark) {
    // Outils d'apprentissage
    final outils = <_OutilItem>[
      _OutilItem(icon: Icons.menu_book, title: 'Leçons', color: Colors.blue,
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const LeconsPage()))),
      _OutilItem(icon: Icons.science, title: 'Développements', color: Colors.purple,
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const DeveloppementsPage()))),
      _OutilItem(icon: Icons.functions, title: 'Démonstrations', color: Colors.green,
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const DemonstrationsPage()))),
      _OutilItem(icon: Icons.warning_amber, title: 'Contre-exemples', color: Colors.red,
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ContreExemplesPage()))),
      _OutilItem(icon: Icons.lightbulb_outline, title: 'Maths Intuitives', color: Colors.purple.shade600,
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const MathsIntuitivesPage()))),
      _OutilItem(icon: Icons.account_tree, title: 'Carte Mentale', color: Colors.indigo,
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const MindMapPage()))),
      _OutilItem(icon: Icons.auto_stories, title: 'Bibliothèque', color: Colors.amber.shade800,
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const BibliothequeIdealePage()))),
      _OutilItem(icon: Icons.emoji_events, title: 'Conseils', color: Colors.deepOrange,
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ConseilsAgregPage()))),
    ];

    final totalItems = _themes.length + outils.length;

    if (_themes.isEmpty && outils.isEmpty) {
      return const SizedBox(height: 40, child: Center(child: CircularProgressIndicator(strokeWidth: 2)));
    }

    return SizedBox(
      height: 110,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: totalItems,
        itemBuilder: (context, index) {
          final isMatiere = index < _themes.length;

          if (isMatiere) {
            return _buildMatiereChip(_themes[index], isDark, index < totalItems - 1);
          } else {
            final outil = outils[index - _themes.length];
            return _buildOutilChip(outil, isDark, index < totalItems - 1);
          }
        },
      ),
    );
  }

  Widget _buildMatiereChip(ThemeItem theme, bool isDark, bool hasMargin) {
    final color = ThemeUtils.getThemeColor(theme.id);
    final icon = ThemeUtils.getThemeIcon(theme.id);
    final readCount = _readingService.getReadCount(theme.files);
    final totalCount = theme.files.length;
    final progress = totalCount > 0 ? readCount / totalCount : 0.0;

    return Padding(
      padding: EdgeInsets.only(right: hasMargin ? 10 : 0),
      child: Material(
        color: ThemeUtils.cardColor(context),
        borderRadius: BorderRadius.circular(14),
        child: InkWell(
          onTap: () => Navigator.push(context,
            MaterialPageRoute(builder: (_) => FichesListScreen(theme: theme)),
          ),
          borderRadius: BorderRadius.circular(14),
          child: Container(
            width: 130,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: isDark ? Colors.white.withValues(alpha: 0.06) : Colors.grey.withValues(alpha: 0.12),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: isDark ? 0.2 : 0.08),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(icon, color: color, size: 18),
                ),
                const Spacer(),
                Text(
                  theme.label,
                  style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      '$readCount/$totalCount',
                      style: TextStyle(fontSize: 10, color: Colors.grey[500]),
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(2),
                        child: LinearProgressIndicator(
                          value: progress,
                          backgroundColor: isDark
                              ? Colors.white.withValues(alpha: 0.08)
                              : Colors.grey.withValues(alpha: 0.12),
                          color: color,
                          minHeight: 3,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildOutilChip(_OutilItem outil, bool isDark, bool hasMargin) {
    return Padding(
      padding: EdgeInsets.only(right: hasMargin ? 10 : 0),
      child: Material(
        color: ThemeUtils.cardColor(context),
        borderRadius: BorderRadius.circular(14),
        child: InkWell(
          onTap: outil.onTap,
          borderRadius: BorderRadius.circular(14),
          child: Container(
            width: 110,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: isDark ? Colors.white.withValues(alpha: 0.06) : Colors.grey.withValues(alpha: 0.12),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: outil.color.withValues(alpha: isDark ? 0.2 : 0.08),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(outil.icon, color: outil.color, size: 18),
                ),
                const Spacer(),
                Text(
                  outil.title,
                  style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ==========================================================================
  // Section S'entraîner — carousel horizontal compact
  // ==========================================================================
  Widget _buildEntrainerCarousel(bool isDark) {
    final items = [
      _EntrainerItem(
        icon: Icons.flash_on,
        title: 'Grand Quiz',
        subtitle: 'Tous domaines',
        color: Colors.orange,
        onTap: () => QuizLoader.startGrandQuiz(context),
      ),
      _EntrainerItem(
        icon: Icons.assignment_turned_in,
        title: 'Examens Blancs',
        subtitle: 'Sujets corrigés',
        color: Colors.purple,
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ExamenBlancPage())),
      ),
      _EntrainerItem(
        icon: Icons.record_voice_over,
        title: 'Simulation Oral',
        subtitle: 'Tirage + oral',
        color: Colors.deepPurple,
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const OralSimulationPage())),
      ),
      _EntrainerItem(
        icon: Icons.gavel,
        title: 'Jury Virtuel',
        subtitle: 'Questions jury',
        color: const Color(0xFF7E57C2),
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const JuryVirtuelMainPage())),
      ),
      _EntrainerItem(
        icon: Icons.history_edu,
        title: 'Annales',
        subtitle: 'Sujets 2017-2025',
        color: Colors.indigo,
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AnnalesPage())),
      ),
      _EntrainerItem(
        icon: Icons.school,
        title: 'Annales pédagogiques',
        subtitle: 'Corrigés pas à pas',
        color: Colors.amber.shade800,
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AnnalesPedagogiquesPage())),
      ),
      _EntrainerItem(
        icon: Icons.timer,
        title: 'Simulation Écrit',
        subtitle: '5h chronométrées',
        color: const Color(0xFF1A237E),
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SimulationPage())),
      ),
      _EntrainerItem(
        icon: Icons.fitness_center,
        title: 'Exercices',
        subtitle: 'Incontournables',
        color: Colors.teal,
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ExercicesPage())),
      ),
      _EntrainerItem(
        icon: Icons.psychology,
        title: 'Répétition Espacée',
        subtitle: 'Mémorisation SRS',
        color: Colors.deepOrange,
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SpacedRepetitionPage())),
      ),
      _EntrainerItem(
        icon: Icons.style,
        title: 'Flashcards',
        subtitle: 'Révision rapide',
        color: Colors.teal.shade300,
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const FlashcardsPage())),
      ),
    ];

    return SizedBox(
      height: 110,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];
          return Padding(
            padding: EdgeInsets.only(right: index < items.length - 1 ? 10 : 0),
            child: Material(
              color: ThemeUtils.cardColor(context),
              borderRadius: BorderRadius.circular(14),
              child: InkWell(
                onTap: item.onTap,
                borderRadius: BorderRadius.circular(14),
                child: Container(
                  width: 130,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: isDark ? Colors.white.withValues(alpha: 0.06) : Colors.grey.withValues(alpha: 0.12),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: item.color.withValues(alpha: isDark ? 0.2 : 0.08),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(item.icon, color: item.color, size: 18),
                      ),
                      const Spacer(),
                      Text(item.title, style: const TextStyle(
                        fontWeight: FontWeight.w600, fontSize: 12,
                      ), maxLines: 1, overflow: TextOverflow.ellipsis),
                      const SizedBox(height: 2),
                      Text(item.subtitle, style: TextStyle(
                        fontSize: 10, color: Colors.grey[500],
                      ), maxLines: 1, overflow: TextOverflow.ellipsis),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

// Helper classes
class _EntrainerItem {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;

  const _EntrainerItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.onTap,
  });
}

class _OutilItem {
  final IconData icon;
  final String title;
  final Color color;
  final VoidCallback onTap;

  const _OutilItem({
    required this.icon,
    required this.title,
    required this.color,
    required this.onTap,
  });
}

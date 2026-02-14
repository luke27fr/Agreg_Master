import 'package:flutter/material.dart';
import '../main.dart'; // ThemeItem
import '../constants/app_constants.dart';
import '../utils/theme_utils.dart';
import '../utils/manifest_loader.dart';
import '../utils/quiz_loader.dart';
import '../widgets/shared_widgets.dart';
import '../services/score_service.dart';
import '../services/favorites_service.dart';
import '../fiche_page.dart';
import 'search_page.dart';
import 'settings_page.dart';
import 'review_page.dart';
import 'stats_page.dart';
import 'flashcards_page.dart';
import 'agregation_hub_page.dart';
import 'fiches_list_screen.dart';

class ThemesScreen extends StatefulWidget {
  const ThemesScreen({super.key});

  @override
  State<ThemesScreen> createState() => _ThemesScreenState();
}

class _ThemesScreenState extends State<ThemesScreen> {
  List<ThemeItem> _themes = [];
  int _totalFiches = 0;
  bool _loading = true;
  String? _error;
  final ScoreService _scoreService = ScoreService();
  final FavoritesService _favoritesService = FavoritesService();

  @override
  void initState() {
    super.initState();
    _loadManifest();
    _scoreService.addListener(_onScoreChanged);
    _favoritesService.addListener(_onScoreChanged);
  }

  @override
  void dispose() {
    _scoreService.removeListener(_onScoreChanged);
    _favoritesService.removeListener(_onScoreChanged);
    super.dispose();
  }

  void _onScoreChanged() {
    if (mounted) setState(() {});
  }

  Future<void> _loadManifest() async {
    try {
      final themes = await ManifestLoader.loadThemes();
      final total = await ManifestLoader.getTotalFiches();
      if (mounted) {
        setState(() {
          _themes = themes;
          _totalFiches = total;
          _loading = false;
        });
      }
    } catch (e) {
      debugPrint("Erreur chargement manifest: $e");
      if (mounted) {
        setState(() {
          _loading = false;
          _error = AppStrings.errorLoadingData;
        });
      }
    }
  }

  Widget _buildStatsCard() {
    final globalAvg = _scoreService.getGlobalAverage();
    final completedCount = _scoreService.scores.length;
    final message = AppStrings.getScoreMessage(completedCount, globalAvg);

    return Semantics(
      label: '$_totalFiches fiches, $completedCount testées. $message',
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [AppColors.primaryDark, AppColors.primaryLight],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(color: Colors.blue.withValues(alpha: 0.3), blurRadius: 10, offset: const Offset(0, 5))
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.library_books, color: Colors.white, size: 28),
                      const SizedBox(width: 10),
                      Flexible(
                        child: Text(
                          "$_totalFiches Fiches • $completedCount testées",
                          style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(message, style: const TextStyle(color: Colors.white70, fontSize: 14)),
                ],
              ),
            ),
            if (completedCount > 0)
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    Text(
                      "${globalAvg.round()}%",
                      style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    const Text("Moyenne", style: TextStyle(color: Colors.white70, fontSize: 12)),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
    String? badge,
  }) {
    final isDark = ThemeUtils.isDark(context);
    return GestureDetector(
      onTap: onTap,
      child: Semantics(
        button: true,
        label: '$label${badge != null ? ', $badge notifications' : ''}',
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
          decoration: BoxDecoration(
            color: ThemeUtils.cardColor(context),
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(color: Colors.grey.withValues(alpha: 0.1), blurRadius: 4)
            ],
          ),
          child: Column(
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Icon(icon, color: color, size: 28),
                  if (badge != null)
                    Positioned(
                      right: -8,
                      top: -4,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle),
                        child: Text(
                          badge,
                          style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: isDark ? Colors.white70 : Colors.grey[700],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showFavoritesDialog(BuildContext context) async {
    final favorites = _favoritesService.favorites.toList();
    if (favorites.isEmpty) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text(AppStrings.errorNoFavorites)),
        );
      }
      return;
    }

    try {
      final pathMap = await ManifestLoader.getPathMap();
      if (!context.mounted) return;

      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        builder: (ctx) => DraggableScrollableSheet(
          initialChildSize: 0.5,
          minChildSize: 0.3,
          maxChildSize: 0.9,
          expand: false,
          builder: (_, controller) => Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    const Icon(Icons.star, color: Colors.amber),
                    const SizedBox(width: 8),
                    Text(
                      'Mes Favoris (${favorites.length})',
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
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
                      trailing: IconButton(
                        icon: const Icon(Icons.close, color: Colors.red),
                        tooltip: 'Retirer des favoris',
                        onPressed: () {
                          _favoritesService.removeFavorite(ficheId);
                          Navigator.pop(ctx);
                          if (favorites.length > 1) {
                            _showFavoritesDialog(context);
                          }
                        },
                      ),
                      onTap: path != null
                          ? () {
                              Navigator.pop(ctx);
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (_) => FichePage(assetPath: path)),
                              );
                            }
                          : null,
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
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text(AppStrings.errorLoadingData)),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = ThemeUtils.isDark(context);
    final favCount = _favoritesService.favorites.length;
    final reviewCount = _scoreService.getFichesToReview().length;

    return Scaffold(
      backgroundColor: ThemeUtils.scaffoldBackground(context),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              // En-tête
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Bonjour !", style: TextStyle(fontSize: 16, color: Colors.grey[600])),
                      Text(
                        AppStrings.appName,
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: ThemeUtils.titleColor(context),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.search),
                        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SearchPage())),
                        tooltip: 'Rechercher',
                      ),
                      IconButton(
                        icon: const Icon(Icons.settings),
                        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SettingsPage())),
                        tooltip: 'Paramètres',
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 20),
              _buildStatsCard(),
              const SizedBox(height: 16),

              // Bouton Préparation Agrégation
              Container(
                width: double.infinity,
                margin: const EdgeInsets.only(bottom: 12),
                child: ElevatedButton.icon(
                  onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AgregationHubPage())),
                  icon: const Icon(Icons.school, size: 20),
                  label: const Text('Préparation Agrégation'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryDark,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ),

              // Boutons rapides
              Row(
                children: [
                  Expanded(child: _buildQuickButton(
                    icon: Icons.psychology, label: 'Révision',
                    badge: reviewCount > 0 ? '$reviewCount' : null,
                    color: Colors.orange,
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ReviewPage())),
                  )),
                  const SizedBox(width: 8),
                  Expanded(child: _buildQuickButton(
                    icon: Icons.bar_chart, label: 'Stats', color: Colors.purple,
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const StatsPage())),
                  )),
                  const SizedBox(width: 8),
                  Expanded(child: _buildQuickButton(
                    icon: Icons.style, label: 'Flashcards', color: Colors.teal,
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const FlashcardsPage())),
                  )),
                  const SizedBox(width: 8),
                  Expanded(child: _buildQuickButton(
                    icon: Icons.star, label: 'Favoris',
                    badge: favCount > 0 ? '$favCount' : null,
                    color: Colors.amber,
                    onTap: () => _showFavoritesDialog(context),
                  )),
                ],
              ),

              const SizedBox(height: 24),
              Text("Matières", style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : Colors.black87,
              )),
              const SizedBox(height: 15),

              // Grille responsive des matières
              Expanded(
                child: _loading
                    ? const LoadingWidget(message: 'Chargement des matières...')
                    : _error != null
                        ? ErrorStateWidget(message: _error!, onRetry: _loadManifest)
                        : LayoutBuilder(
                            builder: (context, constraints) {
                              int crossAxisCount;
                              if (constraints.maxWidth > AppNumbers.breakpointLargeDesktop) {
                                crossAxisCount = 4;
                              } else if (constraints.maxWidth > AppNumbers.breakpointTablet) {
                                crossAxisCount = 2;
                              } else {
                                crossAxisCount = 1;
                              }

                              return GridView.builder(
                                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: crossAxisCount,
                                  childAspectRatio: 1.1,
                                  crossAxisSpacing: 20,
                                  mainAxisSpacing: 20,
                                ),
                                itemCount: _themes.length,
                                itemBuilder: (context, index) {
                                  final theme = _themes[index];
                                  final color = ThemeUtils.getThemeColor(theme.id);
                                  final icon = ThemeUtils.getThemeIcon(theme.id);
                                  final avgScore = _scoreService.getAverageForFiches(theme.files);
                                  final completedCount = _scoreService.getCompletedCount(theme.files);

                                  return _buildThemeCard(theme, color, icon, avgScore, completedCount, isDark);
                                },
                              );
                            },
                          ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => QuizLoader.startGrandQuiz(context),
        backgroundColor: const Color(0xFFFF9800),
        icon: const Icon(Icons.flash_on, color: Colors.white),
        label: const Text("Grand Quiz", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );
  }

  Widget _buildThemeCard(ThemeItem theme, Color color, IconData icon, double avgScore, int completedCount, bool isDark) {
    return GestureDetector(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => FichesListScreen(theme: theme))),
      child: Semantics(
        button: true,
        label: '${theme.label}: ${theme.files.length} fiches, $completedCount testées',
        child: Container(
          decoration: BoxDecoration(
            color: ThemeUtils.cardColor(context),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(color: Colors.grey.withValues(alpha: isDark ? 0.05 : 0.1), blurRadius: 5, offset: const Offset(0, 2))
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(color: color.withValues(alpha: 0.1), shape: BoxShape.circle),
                  child: Icon(icon, color: color, size: 36, semanticLabel: theme.label),
                ),
                const SizedBox(height: 12),
                Text(theme.label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18), textAlign: TextAlign.center),
                const SizedBox(height: 6),
                Text("${theme.files.length} fiches • $completedCount testées",
                  style: TextStyle(color: Colors.grey[500], fontSize: 12)),
                const SizedBox(height: 8),
                if (avgScore >= 0) ...[
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: avgScore / 100,
                      backgroundColor: Colors.grey[200],
                      color: AppColors.getScoreColor(avgScore),
                      minHeight: 6,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "${avgScore.round()}% moyenne",
                    style: TextStyle(color: AppColors.getScoreColor(avgScore), fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                ] else
                  Text("Pas encore testé", style: TextStyle(color: Colors.grey[400], fontSize: 12, fontStyle: FontStyle.italic)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

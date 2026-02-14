import 'package:flutter/material.dart';
import '../../main.dart'; // ThemeItem
import '../../constants/app_constants.dart';
import '../../utils/theme_utils.dart';
import '../../utils/manifest_loader.dart';
import '../../widgets/shared_widgets.dart';
import '../../services/score_service.dart';
import '../../services/reading_service.dart';
import '../fiches_list_screen.dart';
import '../lecons_page.dart';
import '../developpements_page.dart';
import '../contre_exemples_page.dart';
import '../demonstrations_page.dart';
import '../maths_intuitives_page.dart';
import '../mind_map_page.dart';
import '../bibliotheque_ideale_page.dart';
import '../conseils_agreg_page.dart';

class ApprendreTab extends StatefulWidget {
  const ApprendreTab({super.key});

  @override
  State<ApprendreTab> createState() => _ApprendreTabState();
}

class _ApprendreTabState extends State<ApprendreTab> {
  List<ThemeItem> _themes = [];
  bool _loading = true;
  String? _error;
  final ScoreService _scoreService = ScoreService();
  final ReadingService _readingService = ReadingService();

  @override
  void initState() {
    super.initState();
    _loadManifest();
    _scoreService.addListener(_onChanged);
    _readingService.addListener(_onChanged);
  }

  @override
  void dispose() {
    _scoreService.removeListener(_onChanged);
    _readingService.removeListener(_onChanged);
    super.dispose();
  }

  void _onChanged() {
    if (mounted) setState(() {});
  }

  Future<void> _loadManifest() async {
    try {
      final themes = await ManifestLoader.loadThemes();
      if (mounted) {
        setState(() {
          _themes = themes;
          _loading = false;
        });
      }
    } catch (e) {
      debugPrint("Erreur chargement: $e");
      if (mounted) {
        setState(() {
          _loading = false;
          _error = AppStrings.errorLoadingData;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = ThemeUtils.isDark(context);

    return SafeArea(
      child: CustomScrollView(
        slivers: [
          // Titre de la page
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
              child: Text('Apprendre', style: TextStyle(
                fontSize: 28, fontWeight: FontWeight.bold,
                color: ThemeUtils.titleColor(context),
              )),
            ),
          ),

          // Section Matières
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 12),
              child: Text('Matières', style: TextStyle(
                fontSize: 18, fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : Colors.black87,
              )),
            ),
          ),

          // Liste des matières — cartes horizontales enrichies
          _loading
              ? const SliverToBoxAdapter(child: LoadingWidget(message: 'Chargement des matières...'))
              : _error != null
                  ? SliverToBoxAdapter(child: ErrorStateWidget(message: _error!, onRetry: _loadManifest))
                  : SliverPadding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      sliver: SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            final theme = _themes[index];
                            return _buildMatiereCard(theme, isDark);
                          },
                          childCount: _themes.length,
                        ),
                      ),
                    ),

          // Section Outils
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 28, 20, 12),
              child: Text('Outils', style: TextStyle(
                fontSize: 18, fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : Colors.black87,
              )),
            ),
          ),

          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                ToolCard(
                  icon: Icons.menu_book, title: 'Leçons', subtitle: '70+ leçons avec plans détaillés',
                  color: Colors.blue,
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const LeconsPage())),
                ),
                ToolCard(
                  icon: Icons.science, title: 'Développements', subtitle: 'Plans et démonstrations détaillées',
                  color: Colors.purple,
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const DeveloppementsPage())),
                ),
                ToolCard(
                  icon: Icons.functions, title: 'Démonstrations', subtitle: 'Théorèmes clés avec preuves',
                  color: Colors.green,
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const DemonstrationsPage())),
                ),
                ToolCard(
                  icon: Icons.warning_amber, title: 'Contre-exemples', subtitle: 'Erreurs classiques à éviter',
                  color: Colors.red,
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ContreExemplesPage())),
                ),
                ToolCard(
                  icon: Icons.lightbulb_outline, title: 'Maths Intuitives', subtitle: 'Concepts expliqués simplement',
                  color: Colors.purple.shade600,
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const MathsIntuitivesPage())),
                ),
                ToolCard(
                  icon: Icons.account_tree, title: 'Carte Mentale', subtitle: 'Liens entre concepts et parcours',
                  color: Colors.indigo,
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const MindMapPage())),
                ),
                ToolCard(
                  icon: Icons.auto_stories, title: 'Bibliothèque idéale', subtitle: 'Livres commentés avec pages des développements',
                  color: Colors.amber.shade800,
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const BibliothequeIdealePage())),
                ),
                ToolCard(
                  icon: Icons.emoji_events, title: 'Conseils & Stratégies', subtitle: 'Retours de candidats admis et rapports du jury',
                  color: Colors.deepOrange,
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ConseilsAgregPage())),
                ),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================================================
  // Carte matière enrichie (style Apple Education)
  // ==========================================================================
  Widget _buildMatiereCard(ThemeItem theme, bool isDark) {
    final color = ThemeUtils.getThemeColor(theme.id);
    final icon = ThemeUtils.getThemeIcon(theme.id);
    final avgScore = _scoreService.getAverageForFiches(theme.files);
    final readCount = _readingService.getReadCount(theme.files);
    final totalCount = theme.files.length;
    final progress = totalCount > 0 ? readCount / totalCount : 0.0;

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Material(
        color: ThemeUtils.cardColor(context),
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          onTap: () => Navigator.push(context,
            MaterialPageRoute(builder: (_) => FichesListScreen(theme: theme)),
          ),
          borderRadius: BorderRadius.circular(16),
          child: Semantics(
            button: true,
            label: '${theme.label}: $readCount sur $totalCount lues',
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isDark ? Colors.white.withValues(alpha: 0.06) : Colors.grey.withValues(alpha: 0.12),
                ),
              ),
              child: Row(
                children: [
                  // Icône dans un conteneur coloré
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: isDark ? 0.2 : 0.08),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Icon(icon, color: color, size: 28, semanticLabel: theme.label),
                  ),
                  const SizedBox(width: 16),

                  // Titre + progression
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          theme.label,
                          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 6),
                        Text(
                          '$readCount/$totalCount fiches lues',
                          style: TextStyle(color: Colors.grey[500], fontSize: 13),
                        ),
                        const SizedBox(height: 8),
                        // Barre de progression épaisse
                        ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: LinearProgressIndicator(
                            value: progress,
                            backgroundColor: isDark ? Colors.white.withValues(alpha: 0.08) : Colors.grey.withValues(alpha: 0.12),
                            color: color,
                            minHeight: 6,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),

                  // Score circulaire ou chevron
                  if (avgScore >= 0)
                    CircularScoreIndicator(score: avgScore, size: 44, strokeWidth: 4)
                  else
                    Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey[400]),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

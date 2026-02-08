import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../main.dart'; // ThemeItem, FichesListScreen
import '../../services/score_service.dart';
import '../../services/reading_service.dart';
import '../lecons_page.dart';
import '../developpements_page.dart';
import '../contre_exemples_page.dart';
import '../demonstrations_page.dart';
import '../maths_intuitives_page.dart';
import '../mind_map_page.dart';

class ApprendreTab extends StatefulWidget {
  const ApprendreTab({super.key});

  @override
  State<ApprendreTab> createState() => _ApprendreTabState();
}

class _ApprendreTabState extends State<ApprendreTab> {
  List<ThemeItem> _themes = [];
  bool _loading = true;
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
      final json = await rootBundle.loadString('assets/fiches/manifest.json');
      final data = jsonDecode(json) as Map<String, dynamic>;
      final list = (data['themes'] as List<dynamic>?)
          ?.map((e) => ThemeItem.fromJson(e as Map<String, dynamic>))
          .toList();
      if (mounted) {
        setState(() {
          _themes = list ?? [];
          _loading = false;
        });
      }
    } catch (e) {
      debugPrint("Erreur chargement: $e");
    }
  }

  Color _getThemeColor(String id) {
    if (id.contains('algebre')) return const Color(0xFF3F51B5);
    if (id.contains('analyse')) return const Color(0xFFE91E63);
    if (id.contains('proba')) return const Color(0xFF009688);
    if (id.contains('geo')) return const Color(0xFFFF9800);
    return const Color(0xFF607D8B);
  }

  IconData _getThemeIcon(String id) {
    if (id.contains('algebre')) return Icons.functions;
    if (id.contains('analyse')) return Icons.show_chart;
    if (id.contains('proba')) return Icons.casino;
    if (id.contains('geo')) return Icons.architecture;
    return Icons.book;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SafeArea(
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: Text('Apprendre', style: TextStyle(
                fontSize: 26, fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : const Color(0xFF1A237E),
              )),
            ),
          ),

          // Section Matières
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
              child: Text('Matières', style: TextStyle(
                fontSize: 17, fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : Colors.black87,
              )),
            ),
          ),

          // Grid des 4 matières
          _loading
              ? const SliverToBoxAdapter(child: Center(child: Padding(
                  padding: EdgeInsets.all(40),
                  child: CircularProgressIndicator(),
                )))
              : SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  sliver: SliverGrid(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 1.3,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                    ),
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final theme = _themes[index];
                        final color = _getThemeColor(theme.id);
                        final icon = _getThemeIcon(theme.id);
                        final avgScore = _scoreService.getAverageForFiches(theme.files);
                        final readCount = _readingService.getReadCount(theme.files);

                        return GestureDetector(
                          onTap: () => Navigator.push(context,
                            MaterialPageRoute(builder: (_) => FichesListScreen(theme: theme)),
                          ),
                          child: Container(
                            decoration: BoxDecoration(
                              color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [BoxShadow(
                                color: Colors.grey.withOpacity(isDark ? 0.05 : 0.08),
                                blurRadius: 4, offset: const Offset(0, 2),
                              )],
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(14),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: color.withOpacity(0.1),
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(icon, color: color, size: 26),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(theme.label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                                    textAlign: TextAlign.center),
                                  const SizedBox(height: 4),
                                  Text('${readCount}/${theme.files.length} lues',
                                    style: TextStyle(color: Colors.grey[500], fontSize: 11)),
                                  if (avgScore >= 0) ...[
                                    const SizedBox(height: 4),
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(3),
                                      child: LinearProgressIndicator(
                                        value: avgScore / 100,
                                        backgroundColor: Colors.grey[200],
                                        color: avgScore >= 80 ? Colors.green : (avgScore >= 60 ? Colors.orange : Colors.red),
                                        minHeight: 4,
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                      childCount: _themes.length,
                    ),
                  ),
                ),

          // Section Outils d'apprentissage
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 8),
              child: Text('Outils', style: TextStyle(
                fontSize: 17, fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : Colors.black87,
              )),
            ),
          ),

          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                _buildToolCard(
                  icon: Icons.menu_book, title: 'Leçons', subtitle: '70+ leçons avec plans détaillés',
                  color: Colors.blue, isDark: isDark,
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const LeconsPage())),
                ),
                _buildToolCard(
                  icon: Icons.science, title: 'Développements', subtitle: 'Plans et démonstrations détaillées',
                  color: Colors.purple, isDark: isDark,
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const DeveloppementsPage())),
                ),
                _buildToolCard(
                  icon: Icons.functions, title: 'Démonstrations', subtitle: 'Théorèmes clés avec preuves',
                  color: Colors.green, isDark: isDark,
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const DemonstrationsPage())),
                ),
                _buildToolCard(
                  icon: Icons.warning_amber, title: 'Contre-exemples', subtitle: 'Erreurs classiques à éviter',
                  color: Colors.red, isDark: isDark,
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ContreExemplesPage())),
                ),
                _buildToolCard(
                  icon: Icons.lightbulb_outline, title: 'Maths Intuitives', subtitle: 'Concepts expliqués simplement',
                  color: Colors.purple.shade600, isDark: isDark,
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const MathsIntuitivesPage())),
                ),
                _buildToolCard(
                  icon: Icons.account_tree, title: 'Carte Mentale', subtitle: 'Liens entre concepts et parcours',
                  color: Colors.indigo, isDark: isDark,
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const MindMapPage())),
                ),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildToolCard({
    required IconData icon, required String title, required String subtitle,
    required Color color, required bool isDark, required VoidCallback onTap,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
      elevation: 0.5,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: color, size: 22),
            ),
            const SizedBox(width: 14),
            Expanded(child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                const SizedBox(height: 2),
                Text(subtitle, style: TextStyle(color: Colors.grey[600], fontSize: 12)),
              ],
            )),
            Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey[400]),
          ]),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import '../main.dart'; // ThemeItem
import '../constants/app_constants.dart';
import '../utils/theme_utils.dart';
import '../utils/quiz_loader.dart';
import '../services/score_service.dart';
import '../services/favorites_service.dart';
import '../services/reading_service.dart';
import '../fiche_page.dart';

class FichesListScreen extends StatefulWidget {
  final ThemeItem theme;
  const FichesListScreen({super.key, required this.theme});

  @override
  State<FichesListScreen> createState() => _FichesListScreenState();
}

class _FichesListScreenState extends State<FichesListScreen> {
  final ScoreService _scoreService = ScoreService();
  final FavoritesService _favoritesService = FavoritesService();
  final ReadingService _readingService = ReadingService();

  @override
  void initState() {
    super.initState();
    _scoreService.addListener(_onDataChanged);
    _favoritesService.addListener(_onDataChanged);
    _readingService.addListener(_onDataChanged);
  }

  @override
  void dispose() {
    _scoreService.removeListener(_onDataChanged);
    _favoritesService.removeListener(_onDataChanged);
    _readingService.removeListener(_onDataChanged);
    super.dispose();
  }

  void _onDataChanged() {
    if (mounted) setState(() {});
  }

  Widget _buildScoreBadge(String ficheId) {
    final score = _scoreService.getScore(ficheId);
    if (score == null) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Text("—", style: TextStyle(color: Colors.grey, fontSize: 12)),
      );
    }

    final color = AppColors.getScoreColor(score.percentage);
    return Semantics(
      label: 'Score: ${score.score} sur ${score.total}',
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withValues(alpha: 0.5)),
        ),
        child: Text(
          "${score.score}/${score.total}",
          style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = ThemeUtils.isDark(context);
    final avgScore = _scoreService.getAverageForFiches(widget.theme.files);
    final completedCount = _scoreService.getCompletedCount(widget.theme.files);
    final readCount = _readingService.getReadCount(widget.theme.files);

    return Scaffold(
      backgroundColor: ThemeUtils.scaffoldBackground(context),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: BackButton(color: ThemeUtils.titleColor(context)),
        title: Text(widget.theme.label, style: TextStyle(color: ThemeUtils.titleColor(context), fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Carte résumé
          Container(
            margin: const EdgeInsets.all(20),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: ThemeUtils.cardColor(context),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [BoxShadow(color: Colors.grey.withValues(alpha: isDark ? 0.05 : 0.1), blurRadius: 5)],
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Icon(Icons.menu_book, color: Colors.blue[400], size: 20, semanticLabel: 'Fiches lues'),
                    const SizedBox(width: 8),
                    Text("$readCount/${widget.theme.files.length} lues", style: TextStyle(color: Colors.grey[600], fontSize: 13)),
                    const SizedBox(width: 16),
                    Icon(Icons.quiz, color: Colors.green[400], size: 20, semanticLabel: 'Fiches testées'),
                    const SizedBox(width: 8),
                    Text("$completedCount/${widget.theme.files.length} testées", style: TextStyle(color: Colors.grey[600], fontSize: 13)),
                  ],
                ),
                const SizedBox(height: 12),
                if (avgScore >= 0) ...[
                  Row(
                    children: [
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: LinearProgressIndicator(
                            value: avgScore / 100,
                            backgroundColor: Colors.grey[200],
                            color: AppColors.getScoreColor(avgScore),
                            minHeight: 8,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        "${avgScore.round()}%",
                        style: TextStyle(color: AppColors.getScoreColor(avgScore), fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                    ],
                  ),
                ] else
                  const Text("Commencez un quiz !", style: TextStyle(color: Colors.grey, fontStyle: FontStyle.italic)),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () => QuizLoader.startSectionQuiz(context, widget.theme.label, widget.theme.files),
                    icon: const Icon(Icons.school, size: 18),
                    label: const Text("Quiz du chapitre"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryDark,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Liste des fiches
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: widget.theme.files.length,
              itemBuilder: (context, index) {
                final file = widget.theme.files[index];
                final ficheId = file.replaceAll('.md', '');
                final score = _scoreService.getScore(ficheId);
                final isFavorite = _favoritesService.isFavorite(ficheId);
                final isRead = _readingService.isRead(ficheId);

                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: ThemeUtils.cardColor(context),
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [BoxShadow(color: Colors.grey.withValues(alpha: isDark ? 0.05 : 0.1), blurRadius: 5)],
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    leading: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          width: 32,
                          child: Checkbox(
                            value: isRead,
                            onChanged: (_) => _readingService.toggleRead(ficheId),
                            activeColor: Colors.blue,
                            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: score != null
                                ? AppColors.getScoreColor(score.percentage).withValues(alpha: 0.1)
                                : (isDark ? Colors.grey[800] : AppColors.primaryDark.withValues(alpha: 0.1)),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            score != null ? (score.percentage >= AppNumbers.scoreExcellentThreshold ? Icons.check_circle : Icons.article) : Icons.article,
                            color: score != null ? AppColors.getScoreColor(score.percentage) : (isDark ? Colors.grey[400] : AppColors.primaryDark),
                            size: 20,
                          ),
                        ),
                      ],
                    ),
                    title: Text(ThemeUtils.getFicheTitle(ficheId), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                    subtitle: score != null
                        ? Text("Score: ${score.percentage.round()}% • ${ThemeUtils.formatRelativeDate(score.date)}",
                            style: TextStyle(fontSize: 12, color: Colors.grey[600]))
                        : Text(isRead ? "Lu" : "Non lu",
                            style: TextStyle(fontSize: 12, color: isRead ? Colors.blue : Colors.grey[400])),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(
                            isFavorite ? Icons.star : Icons.star_border,
                            color: isFavorite ? Colors.amber : Colors.grey,
                            size: 20,
                          ),
                          onPressed: () => _favoritesService.toggleFavorite(ficheId),
                          tooltip: isFavorite ? "Retirer des favoris" : "Ajouter aux favoris",
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                        ),
                        const SizedBox(width: 4),
                        _buildScoreBadge(ficheId),
                        const SizedBox(width: 4),
                        IconButton(
                          icon: Icon(Icons.quiz, color: isDark ? Colors.blue[300] : AppColors.primaryDark, size: 20),
                          onPressed: () => QuizLoader.startFicheQuiz(context, ficheId),
                          tooltip: "Quiz de cette fiche",
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                        ),
                      ],
                    ),
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (_) => FichePage(assetPath: '${widget.theme.path}/$file')));
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

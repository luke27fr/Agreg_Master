import 'package:flutter/material.dart';
import '../services/spaced_repetition_service.dart';
import '../models/spaced_repetition_model.dart';
import 'package:intl/intl.dart';

import '../widgets/global_search_button.dart';

class SpacedRepetitionPage extends StatefulWidget {
  const SpacedRepetitionPage({super.key});

  @override
  State<SpacedRepetitionPage> createState() => _SpacedRepetitionPageState();
}

class _SpacedRepetitionPageState extends State<SpacedRepetitionPage> with SingleTickerProviderStateMixin {
  final SpacedRepetitionService _srsService = SpacedRepetitionService();
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _srsService.addListener(_onDataChanged);
    _srsService.resetDailyReviews(); // Réinitialise si nouveau jour
  }

  @override
  void dispose() {
    _tabController.dispose();
    _srsService.removeListener(_onDataChanged);
    super.dispose();
  }

  void _onDataChanged() {
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final stats = _srsService.getStatistics();

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF121212) : const Color(0xFFF5F7FA),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('Répétition Espacée', style: TextStyle(fontWeight: FontWeight.bold)),
        $1
        actions: const [GlobalSearchButton()],
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Aujourd\'hui', icon: Icon(Icons.today)),
            Tab(text: 'À venir', icon: Icon(Icons.calendar_today)),
            Tab(text: 'Statistiques', icon: Icon(Icons.bar_chart)),
          ],
        ),
      ),
      body: Column(
        children: [
          // Carte de statistiques rapides
          _buildQuickStatsCard(stats, isDark),
          
          // Contenu des tabs
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildTodayTab(isDark),
                _buildUpcomingTab(isDark),
                _buildStatisticsTab(isDark),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickStatsCard(ReviewStatistics stats, bool isDark) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF1A237E), Color(0xFF3949AB)],
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem('À réviser', '${stats.dueToday}', Icons.schedule),
          _buildStatItem('Révisées', '${stats.reviewedToday}', Icons.check_circle),
          _buildStatItem('Maîtrisées', '${stats.masteredCards}', Icons.emoji_events),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: Colors.white, size: 28),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: const TextStyle(color: Colors.white70, fontSize: 12),
        ),
      ],
    );
  }

  Widget _buildTodayTab(bool isDark) {
    final dueCards = _srsService.getDueCards();

    if (dueCards.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.celebration, size: 80, color: Colors.green[400]),
            const SizedBox(height: 16),
            const Text(
              'Bravo ! Tout est à jour !',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Aucune fiche à réviser aujourd\'hui',
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: dueCards.length,
      itemBuilder: (context, index) {
        final card = dueCards[index];
        return _buildCardItem(card, isDark, isPriority: true);
      },
    );
  }

  Widget _buildUpcomingTab(bool isDark) {
    final upcomingCards = _srsService.getUpcomingCards(days: 30);

    if (upcomingCards.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.inbox, size: 80, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              'Aucune révision planifiée',
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
          ],
        ),
      );
    }

    // Grouper par semaine
    final grouped = <String, List<SpacedRepetitionCard>>{};
    for (var card in upcomingCards) {
      final key = _getWeekLabel(card.nextReviewDate);
      grouped.putIfAbsent(key, () => []).add(card);
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: grouped.length,
      itemBuilder: (context, index) {
        final entry = grouped.entries.elementAt(index);
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Text(
                entry.key,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            ...entry.value.map((card) => _buildCardItem(card, isDark)),
            const SizedBox(height: 16),
          ],
        );
      },
    );
  }

  Widget _buildStatisticsTab(bool isDark) {
    final stats = _srsService.getStatistics();
    final byMastery = _srsService.getCardsByMasteryLevel();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Vue d'ensemble
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Vue d\'ensemble',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                _buildStatRow('Total de fiches', '${stats.totalCards}'),
                _buildStatRow('Niveau moyen', '${stats.averageMastery.round()}%'),
                _buildStatRow('Fiches maîtrisées', '${stats.masteredCards}'),
                const SizedBox(height: 12),
                LinearProgressIndicator(
                  value: stats.averageMastery / 100,
                  backgroundColor: Colors.grey[200],
                  valueColor: AlwaysStoppedAnimation(
                    stats.averageMastery >= 80 ? Colors.green :
                    stats.averageMastery >= 60 ? Colors.orange : Colors.red,
                  ),
                  minHeight: 8,
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Par niveau de maîtrise
          const Text(
            'Répartition par niveau',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),

          ...byMastery.entries.map((entry) {
            final count = entry.value.length;
            if (count == 0) return const SizedBox.shrink();
            
            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Icon(
                    _getMasteryIcon(entry.key),
                    color: _getMasteryColor(entry.key),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          entry.key,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          '$count fiche${count > 1 ? 's' : ''}',
                          style: const TextStyle(color: Colors.grey, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: _getMasteryColor(entry.key).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '$count',
                      style: TextStyle(
                        color: _getMasteryColor(entry.key),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildCardItem(SpacedRepetitionCard card, bool isDark, {bool isPriority = false}) {
    final masteryLevel = card.getMasteryLevel();
    final masteryColor = masteryLevel >= 80 ? Colors.green :
                        masteryLevel >= 60 ? Colors.blue :
                        masteryLevel >= 40 ? Colors.orange : Colors.red;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: isPriority ? Border.all(color: Colors.orange, width: 2) : null,
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: masteryColor.withOpacity(0.1),
          child: Text(
            '${masteryLevel}%',
            style: TextStyle(
              color: masteryColor,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ),
        title: Text(
          card.ficheId,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          isPriority 
              ? 'À réviser maintenant • ${card.repetitionNumber} répétition${card.repetitionNumber > 1 ? 's' : ''}'
              : 'Dans ${card.daysUntilReview()} jour${card.daysUntilReview() > 1 ? 's' : ''} • ${_formatDate(card.nextReviewDate)}',
          style: const TextStyle(fontSize: 12),
        ),
        trailing: isPriority
            ? ElevatedButton(
                onPressed: () => _showReviewDialog(card),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  foregroundColor: Colors.white,
                ),
                child: const Text('Réviser'),
              )
            : Icon(
                _getMasteryIconSimple(masteryLevel),
                color: masteryColor,
              ),
      ),
    );
  }

  void _showReviewDialog(SpacedRepetitionCard card) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Réviser : ${card.ficheId}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Comment évaluez-vous votre maîtrise ?',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _buildQualityButton(ctx, card, 5, '😄 Parfait', 'Réponse immédiate et sûre'),
            _buildQualityButton(ctx, card, 4, '😊 Bien', 'Réponse correcte après réflexion'),
            _buildQualityButton(ctx, card, 3, '😐 Difficile', 'Réponse correcte mais hésitante'),
            _buildQualityButton(ctx, card, 2, '😕 Oublié', 'Réponse incorrecte mais familier'),
            _buildQualityButton(ctx, card, 0, '😫 Aucune idée', 'Échec complet'),
          ],
        ),
      ),
    );
  }

  Widget _buildQualityButton(BuildContext ctx, SpacedRepetitionCard card, int quality, String label, String description) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          Navigator.pop(ctx);
          _srsService.reviewCard(card.ficheId, quality);
          
          // Afficher un feedback
          final nextDays = card.intervalDays;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                quality >= 3
                    ? 'Bravo ! Prochaine révision dans $nextDays jour${nextDays > 1 ? 's' : ''}'
                    : 'À revoir demain pour mieux mémoriser',
              ),
              backgroundColor: quality >= 3 ? Colors.green : Colors.orange,
            ),
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: _getQualityColor(quality),
          foregroundColor: Colors.white,
          padding: const EdgeInsets.all(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
            Text(description, style: const TextStyle(fontSize: 11)),
          ],
        ),
      ),
    );
  }

  Widget _buildStatRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Color _getQualityColor(int quality) {
    switch (quality) {
      case 5: return Colors.green;
      case 4: return Colors.blue;
      case 3: return Colors.orange;
      case 2: return Colors.deepOrange;
      default: return Colors.red;
    }
  }

  IconData _getMasteryIcon(String level) {
    if (level.contains('Maîtrisé')) return Icons.emoji_events;
    if (level.contains('Avancé')) return Icons.trending_up;
    if (level.contains('Intermédiaire')) return Icons.school;
    if (level.contains('Apprentissage')) return Icons.auto_stories;
    return Icons.fiber_new;
  }

  IconData _getMasteryIconSimple(int level) {
    if (level >= 80) return Icons.star;
    if (level >= 60) return Icons.trending_up;
    if (level >= 40) return Icons.remove;
    return Icons.trending_down;
  }

  Color _getMasteryColor(String level) {
    if (level.contains('Maîtrisé')) return Colors.green;
    if (level.contains('Avancé')) return Colors.blue;
    if (level.contains('Intermédiaire')) return Colors.orange;
    if (level.contains('Apprentissage')) return Colors.amber;
    return Colors.red;
  }

  String _getWeekLabel(DateTime date) {
    final now = DateTime.now();
    final diff = date.difference(now).inDays;
    
    if (diff <= 7) return 'Cette semaine';
    if (diff <= 14) return 'Semaine prochaine';
    if (diff <= 21) return 'Dans 2-3 semaines';
    return 'Dans un mois';
  }

  String _formatDate(DateTime date) {
    return DateFormat('dd MMM', 'fr_FR').format(date);
  }
}

import 'package:flutter/material.dart';
import '../services/competition_service.dart';
import '../models/competition_model.dart';

import '../widgets/global_search_button.dart';

class CompetitionPage extends StatefulWidget {
  const CompetitionPage({super.key});

  @override
  State<CompetitionPage> createState() => _CompetitionPageState();
}

class _CompetitionPageState extends State<CompetitionPage> with SingleTickerProviderStateMixin {
  final CompetitionService _service = CompetitionService();
  late TabController _tabController;
  String _periodSelection = 'semaine';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _service.addListener(_onDataChanged);
    
    // Créer un profil si nécessaire
    if (_service.profile == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _showCreateProfileDialog());
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    _service.removeListener(_onDataChanged);
    super.dispose();
  }

  void _onDataChanged() {
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF121212) : const Color(0xFFF5F7FA),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('Compétition', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Classement', icon: Icon(Icons.leaderboard)),
            Tab(text: 'Comparaison', icon: Icon(Icons.trending_up)),
            Tab(text: 'Défis', icon: Icon(Icons.emoji_events)),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildLeaderboardTab(isDark),
          _buildComparisonTab(isDark),
          _buildChallengesTab(isDark),
        ],
      ),
    );
  }

  Widget _buildLeaderboardTab(bool isDark) {
    final leaderboard = _service.generateLeaderboard(_periodSelection);

    return Column(
      children: [
        // Sélecteur de période
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              _buildPeriodChip('jour'),
              const SizedBox(width: 8),
              _buildPeriodChip('semaine'),
              const SizedBox(width: 8),
              _buildPeriodChip('mois'),
              const SizedBox(width: 8),
              _buildPeriodChip('all-time'),
            ],
          ),
        ),

        // Top 3
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
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
              if (leaderboard.entries.length > 1)
                _buildPodium(leaderboard.entries[1], 2, Colors.grey),
              if (leaderboard.entries.isNotEmpty)
                _buildPodium(leaderboard.entries[0], 1, Colors.amber),
              if (leaderboard.entries.length > 2)
                _buildPodium(leaderboard.entries[2], 3, Colors.brown),
            ],
          ),
        ),

        const SizedBox(height: 16),

        // Liste complète
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: leaderboard.entries.skip(3).length,
            itemBuilder: (context, index) {
              final entry = leaderboard.entries[index + 3];
              return _buildLeaderboardEntry(entry, isDark);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildPodium(LeaderboardEntry entry, int position, Color medalColor) {
    return Column(
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: position == 1 ? 70 : 60,
              height: position == 1 ? 70 : 60,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  entry.avatar ?? '👤',
                  style: TextStyle(fontSize: position == 1 ? 32 : 28),
                ),
              ),
            ),
            if (position <= 3)
              Positioned(
                bottom: 0,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: medalColor,
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    '$position',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          entry.pseudonyme,
          style: TextStyle(
            color: Colors.white,
            fontWeight: entry.isCurrentUser ? FontWeight.bold : FontWeight.normal,
            fontSize: position == 1 ? 14 : 12,
          ),
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        Text(
          '${entry.score.round()} pts',
          style: const TextStyle(color: Colors.white70, fontSize: 11),
        ),
      ],
    );
  }

  Widget _buildLeaderboardEntry(LeaderboardEntry entry, bool isDark) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: entry.isCurrentUser
            ? const Color(0xFF1A237E).withValues(alpha: 0.2)
            : (isDark ? const Color(0xFF1E1E1E) : Colors.white),
        borderRadius: BorderRadius.circular(12),
        border: entry.isCurrentUser ? Border.all(color: const Color(0xFF1A237E), width: 2) : null,
      ),
      child: Row(
        children: [
          SizedBox(
            width: 40,
            child: Text(
              '#${entry.rang}',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: entry.rang <= 10 ? 16 : 14,
              ),
            ),
          ),
          Text(
            entry.avatar ?? '👤',
            style: const TextStyle(fontSize: 24),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              entry.pseudonyme,
              style: TextStyle(
                fontWeight: entry.isCurrentUser ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
          Text(
            '${entry.score.round()}',
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
        ],
      ),
    );
  }

  Widget _buildComparisonTab(bool isDark) {
    final comparisons = _service.generateComparisons();

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: comparisons.length,
      itemBuilder: (context, index) {
        final comp = comparisons[index];
        return _buildComparisonCard(comp, isDark);
      },
    );
  }

  Widget _buildComparisonCard(ComparisonStats comp, bool isDark) {
    final color = comp.tendance == 'superieur' ? Colors.green : Colors.orange;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  comp.categorie,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  comp.interpretationPercentile,
                  style: TextStyle(
                    color: color,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                children: [
                  Text(
                    comp.valeurUtilisateur.toStringAsFixed(1),
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
                  ),
                  const Text('Vous', style: TextStyle(color: Colors.grey, fontSize: 12)),
                ],
              ),
              Column(
                children: [
                  Icon(
                    comp.tendance == 'superieur' ? Icons.trending_up : Icons.trending_down,
                    color: color,
                    size: 32,
                  ),
                  Text(
                    '${comp.ecartMoyenne >= 0 ? '+' : ''}${comp.ecartMoyenne.toStringAsFixed(1)}',
                    style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              Column(
                children: [
                  Text(
                    comp.moyenneNationale.toStringAsFixed(1),
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const Text('Moyenne', style: TextStyle(color: Colors.grey, fontSize: 12)),
                ],
              ),
            ],
          ),
          
          const SizedBox(height: 12),
          
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: comp.percentile / 100,
              backgroundColor: Colors.grey[200],
              valueColor: AlwaysStoppedAnimation(color),
              minHeight: 8,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChallengesTab(bool isDark) {
    final challenges = _service.activeChallenges;

    if (challenges.isEmpty) {
      return const Center(
        child: Text('Aucun défi disponible', style: TextStyle(color: Colors.grey)),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: challenges.length,
      itemBuilder: (context, index) {
        return _buildChallengeCard(challenges[index], isDark);
      },
    );
  }

  Widget _buildChallengeCard(Challenge challenge, bool isDark) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.amber.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.emoji_events, color: Colors.amber, size: 32),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      challenge.titre,
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      challenge.description,
                      style: const TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.amber.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Récompense: ${challenge.pointsRecompense} points',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  '${challenge.joursRestants} jours restants',
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPeriodChip(String period) {
    final isSelected = _periodSelection == period;
    return ChoiceChip(
      label: Text(period),
      selected: isSelected,
      onSelected: (selected) => setState(() => _periodSelection = period),
      selectedColor: const Color(0xFF1A237E),
      labelStyle: TextStyle(
        color: isSelected ? Colors.white : null,
      ),
    );
  }

  void _showCreateProfileDialog() {
    final controller = TextEditingController();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        title: const Text('Créer votre profil'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Choisissez un pseudonyme anonyme pour participer au classement',
              style: TextStyle(fontSize: 13),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: controller,
              decoration: const InputDecoration(
                labelText: 'Pseudonyme',
                hintText: 'MathGenius2024',
                border: OutlineInputBorder(),
              ),
              maxLength: 20,
            ),
          ],
        ),
        actions: [
          const GlobalSearchButton(),
          
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Plus tard'),
          ),
          ElevatedButton(
            onPressed: () {
              if (controller.text.isNotEmpty) {
                _service.createProfile(controller.text);
                Navigator.pop(ctx);
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF1A237E),
              foregroundColor: Colors.white,
            ),
            child: const Text('Créer'),
          ),
        ],
      ),
    );
  }
}

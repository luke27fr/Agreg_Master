import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../models/quiz_model.dart';
import '../quiz_page.dart';
import '../examen_blanc_page.dart';
import '../annales_page.dart';
import '../simulation_page.dart';
import '../oral_simulation_page.dart';
import '../jury_virtuel_page.dart';
import '../exercices_page.dart';
import '../spaced_repetition_page.dart';
import '../flashcards_page.dart';
import '../../services/spaced_repetition_service.dart';
import '../../services/examen_blanc_service.dart';

class EntrainerTab extends StatefulWidget {
  const EntrainerTab({super.key});

  @override
  State<EntrainerTab> createState() => _EntrainerTabState();
}

class _EntrainerTabState extends State<EntrainerTab> {
  final SpacedRepetitionService _srsService = SpacedRepetitionService();
  final ExamenBlancService _examenService = ExamenBlancService();

  @override
  void initState() {
    super.initState();
    _srsService.addListener(_onChanged);
    _examenService.addListener(_onChanged);
  }

  @override
  void dispose() {
    _srsService.removeListener(_onChanged);
    _examenService.removeListener(_onChanged);
    super.dispose();
  }

  void _onChanged() {
    if (mounted) setState(() {});
  }

  Future<void> _startGrandQuiz() async {
    try {
      final String response = await rootBundle.loadString('assets/data/quiz.json');
      final Map<String, dynamic> data = json.decode(response);
      List<QuizQuestion> allQuestions = [];
      data.forEach((key, value) {
        if (value is List) {
          for (var q in value) allQuestions.add(QuizQuestion.fromJson(q));
        }
      });
      if (allQuestions.isEmpty) return;
      allQuestions.shuffle(Random());
      if (allQuestions.length > 20) allQuestions = allQuestions.sublist(0, 20);
      if (mounted) {
        Navigator.push(context, MaterialPageRoute(
          builder: (_) => QuizPage(title: "Grand Quiz Général", questions: allQuestions),
        ));
      }
    } catch (e) {
      debugPrint('Erreur quiz: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final dueCards = _srsService.getDueCards().length;
    final examCount = _examenService.examens.length;

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("S'entraîner", style: TextStyle(
              fontSize: 26, fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : const Color(0xFF1A237E),
            )),

            const SizedBox(height: 20),

            // Grand Quiz - bouton proéminent
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFFF9800), Color(0xFFFF5722)],
                ),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: _startGrandQuiz,
                  borderRadius: BorderRadius.circular(14),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Row(children: [
                      const Icon(Icons.flash_on, color: Colors.white, size: 32),
                      const SizedBox(width: 16),
                      Expanded(child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Grand Quiz', style: TextStyle(
                            color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 4),
                          Text('20 questions aléatoires de tous les domaines',
                            style: TextStyle(color: Colors.white.withOpacity(0.85), fontSize: 13)),
                        ],
                      )),
                      const Icon(Icons.play_arrow, color: Colors.white, size: 28),
                    ]),
                  ),
                ),
              ),
            ),

            // Épreuves Écrites
            _buildSectionHeader('Épreuves Écrites'),
            _buildToolCard(
              icon: Icons.assignment_turned_in, title: 'Examens Blancs',
              subtitle: '$examCount sujets avec correction détaillée',
              color: Colors.purple, isDark: isDark,
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ExamenBlancPage())),
            ),
            _buildToolCard(
              icon: Icons.history_edu, title: 'Annales Officielles',
              subtitle: 'Sujets réels 2017-2024 avec corrections',
              color: Colors.indigo, isDark: isDark,
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AnnalesPage())),
            ),
            _buildToolCard(
              icon: Icons.timer, title: 'Simulation Écrit',
              subtitle: 'Conditions réelles (5h chronométrées)',
              color: const Color(0xFF1A237E), isDark: isDark,
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SimulationPage())),
            ),

            // Épreuves Orales
            _buildSectionHeader('Épreuves Orales'),
            _buildToolCard(
              icon: Icons.record_voice_over, title: 'Simulation Oral',
              subtitle: 'Tirage de 2 leçons + préparation + présentation',
              color: Colors.deepPurple, isDark: isDark,
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const OralSimulationPage())),
            ),
            _buildToolCard(
              icon: Icons.gavel, title: 'Jury Virtuel',
              subtitle: 'Questions types et simulation interactive',
              color: Colors.deepPurple.shade300, isDark: isDark,
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const JuryVirtuelMainPage())),
            ),

            // Entraînement quotidien
            _buildSectionHeader('Entraînement Quotidien'),
            _buildToolCard(
              icon: Icons.fitness_center, title: 'Exercices Classiques',
              subtitle: 'Incontournables de chaque domaine',
              color: Colors.teal, isDark: isDark,
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ExercicesPage())),
            ),
            _buildToolCard(
              icon: Icons.psychology, title: 'Répétition Espacée (SRS)',
              subtitle: dueCards > 0 ? '$dueCards fiche${dueCards > 1 ? 's' : ''} à réviser maintenant' : 'Mémorisation optimale',
              color: Colors.deepOrange, isDark: isDark,
              badge: dueCards > 0 ? '$dueCards' : null,
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SpacedRepetitionPage())),
            ),
            _buildToolCard(
              icon: Icons.style, title: 'Flashcards',
              subtitle: 'Révision rapide par cartes',
              color: Colors.teal.shade300, isDark: isDark,
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const FlashcardsPage())),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 24, bottom: 10),
      child: Text(title, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
    );
  }

  Widget _buildToolCard({
    required IconData icon, required String title, required String subtitle,
    required Color color, required bool isDark, required VoidCallback onTap,
    String? badge,
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
            Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(icon, color: color, size: 22),
                ),
                if (badge != null)
                  Positioned(
                    right: -6, top: -6,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle),
                      child: Text(badge, style: const TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold)),
                    ),
                  ),
              ],
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

import 'package:flutter/material.dart';
import '../../constants/app_constants.dart';
import '../../utils/theme_utils.dart';
import '../../utils/quiz_loader.dart';
import '../../widgets/shared_widgets.dart';
import '../examen_blanc_page.dart';
import '../annales_page.dart';
import '../annales_pedagogiques_page.dart';
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

  @override
  Widget build(BuildContext context) {
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
              color: ThemeUtils.titleColor(context),
            )),

            const SizedBox(height: 20),

            // Grand Quiz
            Semantics(
              button: true,
              label: 'Grand Quiz: ${AppNumbers.grandQuizLimit} questions aléatoires de tous les domaines',
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(colors: [Color(0xFFFF9800), Color(0xFFFF5722)]),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () => QuizLoader.startGrandQuiz(context),
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
                            Text('${AppNumbers.grandQuizLimit} questions aléatoires de tous les domaines',
                              style: TextStyle(color: Colors.white.withValues(alpha: 0.85), fontSize: 13)),
                          ],
                        )),
                        const Icon(Icons.play_arrow, color: Colors.white, size: 28),
                      ]),
                    ),
                  ),
                ),
              ),
            ),

            // Épreuves Écrites
            const SectionHeader(title: 'Épreuves Écrites'),
            ToolCard(
              icon: Icons.assignment_turned_in, title: 'Examens Blancs',
              subtitle: '$examCount sujets avec correction détaillée',
              color: Colors.purple,
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ExamenBlancPage())),
            ),
            ToolCard(
              icon: Icons.history_edu, title: 'Annales Officielles',
              subtitle: 'Sujets réels 2017-2025 avec corrections',
              color: Colors.indigo,
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AnnalesPage())),
            ),
            ToolCard(
              icon: Icons.school, title: 'Annales Pédagogiques',
              subtitle: 'Corrigés ultra-détaillés pas à pas',
              color: Colors.amber.shade800,
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AnnalesPedagogiquesPage())),
            ),
            ToolCard(
              icon: Icons.timer, title: 'Simulation Écrit',
              subtitle: 'Conditions réelles (5h chronométrées)',
              color: AppColors.primaryDark,
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SimulationPage())),
            ),

            // Épreuves Orales
            const SectionHeader(title: 'Épreuves Orales'),
            ToolCard(
              icon: Icons.record_voice_over, title: 'Simulation Oral',
              subtitle: 'Tirage de 2 leçons + préparation + présentation',
              color: Colors.deepPurple,
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const OralSimulationPage())),
            ),
            ToolCard(
              icon: Icons.gavel, title: 'Jury Virtuel',
              subtitle: 'Questions types et simulation interactive',
              color: Colors.deepPurple.shade300,
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const JuryVirtuelMainPage())),
            ),

            // Entraînement quotidien
            const SectionHeader(title: 'Entraînement Quotidien'),
            ToolCard(
              icon: Icons.fitness_center, title: 'Exercices Classiques',
              subtitle: 'Incontournables de chaque domaine',
              color: Colors.teal,
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ExercicesPage())),
            ),
            ToolCard(
              icon: Icons.psychology, title: 'Répétition Espacée (SRS)',
              subtitle: dueCards > 0 ? '$dueCards fiche${dueCards > 1 ? 's' : ''} à réviser maintenant' : 'Mémorisation optimale',
              color: Colors.deepOrange,
              badge: dueCards > 0 ? '$dueCards' : null,
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SpacedRepetitionPage())),
            ),
            ToolCard(
              icon: Icons.style, title: 'Flashcards',
              subtitle: 'Révision rapide par cartes',
              color: Colors.teal.shade300,
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const FlashcardsPage())),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

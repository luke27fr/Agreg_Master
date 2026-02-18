import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import '../utils/content_loader.dart';
import 'jury_virtuel_page.dart';

import '../widgets/global_search_button.dart';

// Re-export LeconReferencePage for use in this file
// (already imported via jury_virtuel_page.dart)

class OralSimulationPage extends StatefulWidget {
  const OralSimulationPage({super.key});

  @override
  State<OralSimulationPage> createState() => _OralSimulationPageState();
}

class _OralSimulationPageState extends State<OralSimulationPage> {
  // États de la simulation
  SimulationState _state = SimulationState.setup;
  
  // Leçons
  List<dynamic> _allLecons = [];
  List<dynamic> _drawnLecons = [];
  Map<String, dynamic>? _selectedLecon;
  
  // Timer
  Timer? _timer;
  int _remainingSeconds = 0;
  int _preparationMinutes = 180; // 3h par défaut
  int _presentationMinutes = 40; // 40 min présentation
  
  // Notes
  final _notesController = TextEditingController();
  
  // Domaine sélectionné
  String _selectedDomain = 'Tous';

  @override
  void initState() {
    super.initState();
    _loadLecons();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _loadLecons() async {
    try {
      final json = await ContentLoader.loadString('assets/data/lecons.json');
      final data = Map<String, dynamic>.from(jsonDecode(json) as Map);
      setState(() {
        _allLecons = [
          ...(data['algebre'] as List).map((l) => Map<String, dynamic>.from({...Map<String, dynamic>.from(l as Map), 'domaine': 'Algèbre'})),
          ...(data['analyse'] as List).map((l) => Map<String, dynamic>.from({...Map<String, dynamic>.from(l as Map), 'domaine': 'Analyse'})),
        ];
      });
    } catch (e) {
      debugPrint('Erreur chargement leçons: $e');
    }
  }

  List<dynamic> _getFilteredLecons() {
    if (_selectedDomain == 'Tous') return _allLecons;
    return _allLecons.where((l) => l['domaine'] == _selectedDomain).toList();
  }

  void _drawLecons() {
    final filtered = _getFilteredLecons();
    if (filtered.length < 2) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Pas assez de leçons disponibles')),
      );
      return;
    }
    
    final random = Random();
    final shuffled = List.from(filtered)..shuffle(random);
    
    setState(() {
      _drawnLecons = shuffled.take(2).toList();
      _state = SimulationState.choice;
    });
  }

  void _selectLecon(Map<String, dynamic> lecon) {
    setState(() {
      _selectedLecon = lecon;
      _state = SimulationState.preparation;
      _remainingSeconds = _preparationMinutes * 60;
    });
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_remainingSeconds > 0) {
          _remainingSeconds--;
        } else {
          _timer?.cancel();
          if (_state == SimulationState.preparation) {
            _startPresentation();
          } else if (_state == SimulationState.presentation) {
            _endSimulation();
          }
        }
      });
    });
  }

  void _startPresentation() {
    _timer?.cancel();
    setState(() {
      _state = SimulationState.presentation;
      _remainingSeconds = _presentationMinutes * 60;
    });
    _startTimer();
  }

  void _startJurySession() {
    _timer?.cancel();
    
    if (_selectedLecon == null) return;
    
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => JuryVirtuelPage(
          leconId: _selectedLecon!['numero'].toString(),
          leconTitre: 'Leçon ${_selectedLecon!['numero']} – ${_selectedLecon!['titre'] ?? ''}',
        ),
      ),
    ).then((_) {
      // Après le jury, terminer la simulation
      _endSimulation();
    });
  }

  void _endSimulation() {
    _timer?.cancel();
    setState(() {
      _state = SimulationState.finished;
    });
  }

  void _resetSimulation() {
    _timer?.cancel();
    setState(() {
      _state = SimulationState.setup;
      _drawnLecons = [];
      _selectedLecon = null;
      _notesController.clear();
    });
  }

  /// Ouvre la fiche de la leçon sélectionnée (pause le timer)
  void _openLeconReference([Map<String, dynamic>? lecon]) {
    final target = lecon ?? _selectedLecon;
    if (target == null) return;
    
    _timer?.cancel(); // Pause le timer
    
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => LeconReferencePage(
          leconNumero: target['numero'].toString(),
          leconData: target,
        ),
      ),
    ).then((_) {
      // Reprendre le timer au retour
      if (mounted && (_state == SimulationState.preparation || _state == SimulationState.presentation)) {
        _startTimer();
      }
    });
  }

  String _formatTime(int seconds) {
    final hours = seconds ~/ 3600;
    final minutes = (seconds % 3600) ~/ 60;
    final secs = seconds % 60;
    if (hours > 0) {
      return '${hours}h ${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
    }
    return '${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  Color _getTimeColor() {
    final totalSeconds = _state == SimulationState.preparation 
        ? _preparationMinutes * 60 
        : _presentationMinutes * 60;
    final ratio = _remainingSeconds / totalSeconds;
    
    if (ratio < 0.1) return Colors.red;
    if (ratio < 0.25) return Colors.orange;
    return Colors.green;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF121212) : const Color(0xFFF5F7FA),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: _state == SimulationState.setup 
            ? const BackButton()
            : IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => _showExitConfirmation(),
              ),
        title: const Text('Simulation Oral', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        actions: const [GlobalSearchButton()],
      ),
      body: _buildBody(isDark),
    );
  }

  Widget _buildBody(bool isDark) {
    switch (_state) {
      case SimulationState.setup:
        return _buildSetupView(isDark);
      case SimulationState.choice:
        return _buildChoiceView(isDark);
      case SimulationState.preparation:
        return _buildPreparationView(isDark);
      case SimulationState.presentation:
        return _buildPresentationView(isDark);
      case SimulationState.finished:
        return _buildFinishedView(isDark);
    }
  }

  Widget _buildSetupView(bool isDark) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Info card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF1A237E), Color(0xFF3949AB)],
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Row(
              children: [
                Icon(Icons.record_voice_over, color: Colors.white, size: 40),
                SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Simulation d\'oral',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Entraînez-vous comme le jour J',
                        style: TextStyle(color: Colors.white70),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Domaine
          const Text(
            'Domaine',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              _buildDomainChip('Tous', isDark),
              const SizedBox(width: 8),
              _buildDomainChip('Algèbre', isDark),
              const SizedBox(width: 8),
              _buildDomainChip('Analyse', isDark),
            ],
          ),

          const SizedBox(height: 24),

          // Durée préparation
          const Text(
            'Durée de préparation',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              _buildDurationChip(120, '2h', isDark),
              const SizedBox(width: 8),
              _buildDurationChip(150, '2h30', isDark),
              const SizedBox(width: 8),
              _buildDurationChip(180, '3h', isDark),
            ],
          ),

          const SizedBox(height: 24),

          // Durée présentation
          const Text(
            'Durée de présentation',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              _buildPresentationChip(30, '30 min', isDark),
              const SizedBox(width: 8),
              _buildPresentationChip(40, '40 min', isDark),
              const SizedBox(width: 8),
              _buildPresentationChip(50, '50 min', isDark),
            ],
          ),

          const SizedBox(height: 24),

          // Déroulement
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
                  'Déroulement de l\'épreuve',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                _buildStep('1', 'Tirage de 2 leçons au hasard'),
                _buildStep('2', 'Choix d\'une des 2 leçons'),
                _buildStep('3', 'Préparation (sans documents)'),
                _buildStep('4', 'Présentation au tableau'),
                _buildStep('5', 'Questions du jury (simulées)'),
              ],
            ),
          ),

          const SizedBox(height: 32),

          // Bouton démarrer
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: _drawLecons,
              icon: const Icon(Icons.shuffle),
              label: const Text('Tirer 2 leçons'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1A237E),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDomainChip(String domain, bool isDark) {
    final isSelected = _selectedDomain == domain;
    return ChoiceChip(
      label: Text(domain),
      selected: isSelected,
      onSelected: (selected) => setState(() => _selectedDomain = domain),
      selectedColor: const Color(0xFF1A237E),
      labelStyle: TextStyle(
        color: isSelected ? Colors.white : (isDark ? Colors.white70 : Colors.black87),
      ),
    );
  }

  Widget _buildDurationChip(int minutes, String label, bool isDark) {
    final isSelected = _preparationMinutes == minutes;
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) => setState(() => _preparationMinutes = minutes),
      selectedColor: const Color(0xFF1A237E),
      labelStyle: TextStyle(
        color: isSelected ? Colors.white : (isDark ? Colors.white70 : Colors.black87),
      ),
    );
  }

  Widget _buildPresentationChip(int minutes, String label, bool isDark) {
    final isSelected = _presentationMinutes == minutes;
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) => setState(() => _presentationMinutes = minutes),
      selectedColor: Colors.green,
      labelStyle: TextStyle(
        color: isSelected ? Colors.white : (isDark ? Colors.white70 : Colors.black87),
      ),
    );
  }

  Widget _buildStep(String number, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          CircleAvatar(
            radius: 12,
            backgroundColor: const Color(0xFF1A237E).withValues(alpha: 0.1),
            child: Text(
              number,
              style: const TextStyle(
                color: Color(0xFF1A237E),
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(child: Text(text)),
        ],
      ),
    );
  }

  Widget _buildChoiceView(bool isDark) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          const Icon(Icons.shuffle, size: 64, color: Color(0xFF1A237E)),
          const SizedBox(height: 16),
          const Text(
            'Vos 2 leçons tirées au sort',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            'Choisissez celle que vous souhaitez présenter',
            style: TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 32),
          
          ..._drawnLecons.map((lecon) => _buildLeconCard(lecon, isDark)),
        ],
      ),
    );
  }

  Widget _buildLeconCard(Map<String, dynamic> lecon, bool isDark) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
      child: InkWell(
        onTap: () => _selectLecon(lecon),
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1A237E),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      'Leçon ${lecon['numero']}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: lecon['domaine'] == 'Algèbre' 
                          ? Colors.blue.withValues(alpha: 0.1)
                          : Colors.pink.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      lecon['domaine'],
                      style: TextStyle(
                        color: lecon['domaine'] == 'Algèbre' ? Colors.blue : Colors.pink,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                lecon['titre'],
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  OutlinedButton.icon(
                    onPressed: () => _openLeconReference(lecon),
                    icon: const Icon(Icons.menu_book, size: 18),
                    label: const Text('Voir la leçon'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFF1A237E),
                      side: const BorderSide(color: Color(0xFF1A237E)),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => _selectLecon(lecon),
                      icon: const Icon(Icons.check),
                      label: const Text('Choisir'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPreparationView(bool isDark) {
    return Column(
      children: [
        // Timer
        Container(
          margin: const EdgeInsets.all(16),
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 10,
              ),
            ],
          ),
          child: Column(
            children: [
              const Text(
                'PRÉPARATION',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
                  color: Colors.orange,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                _formatTime(_remainingSeconds),
                style: TextStyle(
                  fontSize: 56,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'monospace',
                  color: _getTimeColor(),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Leçon ${_selectedLecon?['numero']}',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),

        // Leçon info
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF1A237E).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _selectedLecon?['titre'] ?? '',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                if (_selectedLecon?['points_cles'] != null) ...[
                  const SizedBox(height: 12),
                  const Text('Points clés :', style: TextStyle(fontWeight: FontWeight.w500)),
                  ...(_selectedLecon!['points_cles'] as List).map((p) => Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('• ', style: TextStyle(color: Color(0xFF1A237E))),
                        Expanded(child: Text(p.toString(), style: const TextStyle(fontSize: 13))),
                      ],
                    ),
                  )),
                ],
              ],
            ),
          ),
        ),

        // Bouton voir la leçon complète
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: _openLeconReference,
              icon: const Icon(Icons.menu_book),
              label: const Text('Consulter la fiche de la leçon'),
              style: OutlinedButton.styleFrom(
                foregroundColor: const Color(0xFF1A237E),
                side: const BorderSide(color: Color(0xFF1A237E)),
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ),
        ),

        const Spacer(),

        // Boutons
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => _showExitConfirmation(),
                  icon: const Icon(Icons.close),
                  label: const Text('Abandonner'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: _startPresentation,
                  icon: const Icon(Icons.arrow_forward),
                  label: const Text('Présenter'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPresentationView(bool isDark) {
    return Column(
      children: [
        // Timer
        Container(
          margin: const EdgeInsets.all(16),
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            children: [
              const Text(
                'PRÉSENTATION',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
                  color: Colors.green,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                _formatTime(_remainingSeconds),
                style: TextStyle(
                  fontSize: 56,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'monospace',
                  color: _getTimeColor(),
                ),
              ),
            ],
          ),
        ),

        // Notes
        Expanded(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Notes de présentation',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Expanded(
                  child: TextField(
                    controller: _notesController,
                    maxLines: null,
                    expands: true,
                    decoration: const InputDecoration(
                      hintText: 'Notez vos remarques pendant la présentation...',
                      border: InputBorder.none,
                    ),
                    textAlignVertical: TextAlignVertical.top,
                  ),
                ),
              ],
            ),
          ),
        ),

        // Boutons
        Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: _openLeconReference,
                  icon: const Icon(Icons.menu_book),
                  label: const Text('Consulter la fiche de la leçon'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFF1A237E),
                    side: const BorderSide(color: Color(0xFF1A237E)),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _startJurySession,
                  icon: const Icon(Icons.gavel),
                  label: const Text('Questions du jury'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.purple,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: _endSimulation,
                  icon: const Icon(Icons.stop),
                  label: const Text('Terminer sans jury'),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFinishedView(bool isDark) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          const Icon(Icons.celebration, size: 80, color: Colors.amber),
          const SizedBox(height: 16),
          const Text(
            'Simulation terminée !',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 32),

          // Résumé
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                _buildSummaryRow('Leçon', '${_selectedLecon?['numero']} - ${_selectedLecon?['titre']}'),
                const Divider(),
                _buildSummaryRow('Préparation', '$_preparationMinutes minutes'),
                const Divider(),
                _buildSummaryRow('Présentation', '$_presentationMinutes minutes'),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Conseils
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.blue.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.blue.withValues(alpha: 0.3)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(Icons.lightbulb, color: Colors.blue),
                    SizedBox(width: 8),
                    Text(
                      'Auto-évaluation',
                      style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                _buildCheckItem('Plan clair et structuré ?'),
                _buildCheckItem('Développements bien choisis ?'),
                _buildCheckItem('Gestion du temps correcte ?'),
                _buildCheckItem('Exemples pertinents ?'),
                _buildCheckItem('Maîtrise des démonstrations ?'),
              ],
            ),
          ),

          const SizedBox(height: 32),

          // Boutons
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: _resetSimulation,
                  icon: const Icon(Icons.replay),
                  label: const Text('Nouvelle simulation'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.home),
                  label: const Text('Terminer'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1A237E),
                    foregroundColor: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey)),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.bold),
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCheckItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          const Icon(Icons.check_box_outline_blank, size: 18, color: Colors.blue),
          const SizedBox(width: 8),
          Text(text),
        ],
      ),
    );
  }

  void _showExitConfirmation() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Abandonner la simulation ?'),
        content: const Text('Votre progression sera perdue.'),
        actions: [
          const GlobalSearchButton(),
          
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Continuer'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              _resetSimulation();
            },
            child: const Text('Abandonner', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}

enum SimulationState {
  setup,
  choice,
  preparation,
  presentation,
  finished,
}

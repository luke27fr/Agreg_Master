import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import '../services/storage_service.dart';

class SimulationPage extends StatefulWidget {
  const SimulationPage({super.key});

  @override
  State<SimulationPage> createState() => _SimulationPageState();
}

class _SimulationPageState extends State<SimulationPage> {
  // Configuration par défaut : 5 heures
  int _totalMinutes = 300;
  int _remainingSeconds = 0;
  Timer? _timer;
  bool _isRunning = false;
  bool _isPaused = false;
  // Sujet choisi
  String? _selectedSubject;
  List<String> _subjects = [];
  
  // Notes de l'utilisateur
  final _notesController = TextEditingController();

  // Historique
  List<SimulationHistory> _history = [];

  @override
  void initState() {
    super.initState();
    _remainingSeconds = _totalMinutes * 60;
    _loadSubjects();
    _loadHistory();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _loadSubjects() async {
    // Sujets types pour simulation
    setState(() {
      _subjects = [
        "Composition d'Algèbre et Géométrie",
        "Composition d'Analyse et Probabilités",
        "Problème d'Algèbre",
        "Problème d'Analyse",
        "Épreuve de Modélisation (Option A)",
        "Épreuve de Modélisation (Option B)",
        "Sujet libre (entraînement)",
      ];
    });
  }

  Future<void> _loadHistory() async {
    try {
      final content = await StorageService.instance.read('agreg_master_simulations.json');
      if (content != null) {
        final List<dynamic> data = jsonDecode(content);
        setState(() {
          _history = data.map((e) => SimulationHistory.fromJson(e)).toList();
        });
      }
    } catch (e) {
      debugPrint('Erreur chargement historique simulations: $e');
    }
  }

  Future<void> _saveHistory() async {
    try {
      final data = _history.map((e) => e.toJson()).toList();
      await StorageService.instance.write('agreg_master_simulations.json', jsonEncode(data));
    } catch (e) {
      debugPrint('Erreur sauvegarde historique: $e');
    }
  }

  void _startSimulation() {
    if (_selectedSubject == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Veuillez choisir un sujet')),
      );
      return;
    }

    setState(() {
      _isRunning = true;
      _isPaused = false;
      _notesController.clear();
    });

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!_isPaused) {
        setState(() {
          if (_remainingSeconds > 0) {
            _remainingSeconds--;
          } else {
            _endSimulation(completed: true);
          }
        });
      }
    });
  }

  void _pauseSimulation() {
    setState(() {
      _isPaused = !_isPaused;
    });
  }

  void _endSimulation({bool completed = false}) {
    _timer?.cancel();
    
    final elapsedMinutes = _totalMinutes - (_remainingSeconds ~/ 60);
    
    // Sauvegarder dans l'historique
    final historyEntry = SimulationHistory(
      subject: _selectedSubject!,
      date: DateTime.now(),
      durationMinutes: elapsedMinutes,
      completed: completed,
      notes: _notesController.text,
    );
    
    _history.insert(0, historyEntry);
    if (_history.length > 20) {
      _history = _history.take(20).toList();
    }
    _saveHistory();

    setState(() {
      _isRunning = false;
      _isPaused = false;
      _remainingSeconds = _totalMinutes * 60;
    });

    // Afficher le récapitulatif
    _showSummaryDialog(historyEntry);
  }

  void _showSummaryDialog(SimulationHistory entry) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        title: Row(
          children: [
            Icon(
              entry.completed ? Icons.check_circle : Icons.stop_circle,
              color: entry.completed ? Colors.green : Colors.orange,
            ),
            const SizedBox(width: 8),
            const Text('Fin de la simulation'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Sujet: ${entry.subject}'),
            const SizedBox(height: 8),
            Text('Durée: ${entry.durationMinutes} minutes'),
            const SizedBox(height: 8),
            Text(
              entry.completed 
                  ? 'Simulation complétée dans le temps imparti !' 
                  : 'Simulation interrompue',
              style: TextStyle(
                color: entry.completed ? Colors.green : Colors.orange,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Fermer'),
          ),
        ],
      ),
    );
  }

  String _formatTime(int seconds) {
    final hours = seconds ~/ 3600;
    final minutes = (seconds % 3600) ~/ 60;
    final secs = seconds % 60;
    return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  Color _getTimeColor() {
    if (_remainingSeconds < 600) return Colors.red; // < 10 min
    if (_remainingSeconds < 1800) return Colors.orange; // < 30 min
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
        leading: _isRunning 
            ? IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => _showExitConfirmation(),
              )
            : const BackButton(),
        title: const Text('Simulation Écrit', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        actions: [
          if (!_isRunning)
            IconButton(
              icon: const Icon(Icons.history),
              onPressed: () => _showHistoryDialog(),
              tooltip: 'Historique',
            ),
        ],
      ),
      body: _isRunning ? _buildRunningView(isDark) : _buildSetupView(isDark),
    );
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
              color: Colors.blue.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.blue.withValues(alpha: 0.3)),
            ),
            child: const Row(
              children: [
                Icon(Icons.info_outline, color: Colors.blue),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Simulez les conditions réelles de l\'épreuve écrite : '
                    '5 heures de concentration intense.',
                    style: TextStyle(color: Colors.blue),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Durée
          const Text(
            'Durée de l\'épreuve',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _buildDurationChip(180, '3h', isDark),
              const SizedBox(width: 8),
              _buildDurationChip(240, '4h', isDark),
              const SizedBox(width: 8),
              _buildDurationChip(300, '5h', isDark),
              const SizedBox(width: 8),
              _buildDurationChip(360, '6h', isDark),
            ],
          ),

          const SizedBox(height: 24),

          // Choix du sujet
          const Text(
            'Choisir un sujet',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 12),
          RadioGroup<String>(
            groupValue: _selectedSubject,
            onChanged: (value) => setState(() => _selectedSubject = value),
            child: Column(
              children: _subjects.map((subject) => RadioListTile<String>(
                title: Text(subject),
                value: subject,
                contentPadding: EdgeInsets.zero,
              )).toList(),
            ),
          ),

          const SizedBox(height: 24),

          // Conseils
          const Text(
            'Conseils pour la simulation',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 12),
          _buildTip(Icons.phone_disabled, 'Éteignez votre téléphone'),
          _buildTip(Icons.coffee, 'Préparez de l\'eau et une collation'),
          _buildTip(Icons.timer, 'Respectez le temps imparti'),
          _buildTip(Icons.edit, 'Travaillez comme le jour J'),

          const SizedBox(height: 32),

          // Bouton démarrer
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: _startSimulation,
              icon: const Icon(Icons.play_arrow),
              label: const Text('Démarrer la simulation'),
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

  Widget _buildDurationChip(int minutes, String label, bool isDark) {
    final isSelected = _totalMinutes == minutes;
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        setState(() {
          _totalMinutes = minutes;
          _remainingSeconds = minutes * 60;
        });
      },
      selectedColor: const Color(0xFF1A237E),
      labelStyle: TextStyle(
        color: isSelected ? Colors.white : (isDark ? Colors.white70 : Colors.black87),
      ),
    );
  }

  Widget _buildTip(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.grey),
          const SizedBox(width: 12),
          Text(text, style: TextStyle(color: Colors.grey[600])),
        ],
      ),
    );
  }

  Widget _buildRunningView(bool isDark) {
    final progress = 1 - (_remainingSeconds / (_totalMinutes * 60));
    
    return Column(
      children: [
        // Timer principal
        Container(
          margin: const EdgeInsets.all(16),
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: [
              Text(
                _selectedSubject ?? '',
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              Text(
                _formatTime(_remainingSeconds),
                style: TextStyle(
                  fontSize: 64,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'monospace',
                  color: _getTimeColor(),
                ),
              ),
              const SizedBox(height: 16),
              LinearProgressIndicator(
                value: progress,
                backgroundColor: Colors.grey.withValues(alpha: 0.2),
                valueColor: AlwaysStoppedAnimation(_getTimeColor()),
                minHeight: 8,
              ),
              const SizedBox(height: 8),
              Text(
                '${(progress * 100).toStringAsFixed(1)}% du temps écoulé',
                style: TextStyle(color: Colors.grey[600]),
              ),
            ],
          ),
        ),

        // Contrôles
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton.icon(
                onPressed: _pauseSimulation,
                icon: Icon(_isPaused ? Icons.play_arrow : Icons.pause),
                label: Text(_isPaused ? 'Reprendre' : 'Pause'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  foregroundColor: Colors.white,
                ),
              ),
              ElevatedButton.icon(
                onPressed: () => _showEndConfirmation(),
                icon: const Icon(Icons.stop),
                label: const Text('Terminer'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 16),

        // Zone de notes
        Expanded(
          child: Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Notes personnelles',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Expanded(
                  child: TextField(
                    controller: _notesController,
                    maxLines: null,
                    expands: true,
                    decoration: const InputDecoration(
                      hintText: 'Notez vos remarques, difficultés rencontrées...',
                      border: InputBorder.none,
                    ),
                    textAlignVertical: TextAlignVertical.top,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _showExitConfirmation() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Quitter la simulation ?'),
        content: const Text('Votre progression sera perdue.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Continuer'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              _endSimulation(completed: false);
            },
            child: const Text('Quitter', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _showEndConfirmation() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Terminer la simulation ?'),
        content: const Text('Êtes-vous sûr de vouloir rendre votre copie ?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Continuer'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              _endSimulation(completed: true);
            },
            child: const Text('Terminer'),
          ),
        ],
      ),
    );
  }

  void _showHistoryDialog() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => DraggableScrollableSheet(
        initialChildSize: 0.6,
        minChildSize: 0.3,
        maxChildSize: 0.9,
        expand: false,
        builder: (_, controller) => Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  const Text(
                    'Historique des simulations',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(ctx),
                  ),
                ],
              ),
            ),
            Expanded(
              child: _history.isEmpty
                  ? const Center(child: Text('Aucune simulation effectuée'))
                  : ListView.builder(
                      controller: controller,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: _history.length,
                      itemBuilder: (context, index) {
                        final entry = _history[index];
                        return Card(
                          margin: const EdgeInsets.only(bottom: 12),
                          child: ListTile(
                            leading: Icon(
                              entry.completed ? Icons.check_circle : Icons.stop_circle,
                              color: entry.completed ? Colors.green : Colors.orange,
                            ),
                            title: Text(entry.subject),
                            subtitle: Text(
                              '${_formatDateTime(entry.date)} - ${entry.durationMinutes} min',
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDateTime(DateTime date) {
    return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }
}

class SimulationHistory {
  final String subject;
  final DateTime date;
  final int durationMinutes;
  final bool completed;
  final String notes;

  SimulationHistory({
    required this.subject,
    required this.date,
    required this.durationMinutes,
    required this.completed,
    required this.notes,
  });

  Map<String, dynamic> toJson() => {
    'subject': subject,
    'date': date.toIso8601String(),
    'durationMinutes': durationMinutes,
    'completed': completed,
    'notes': notes,
  };

  factory SimulationHistory.fromJson(Map<String, dynamic> json) => SimulationHistory(
    subject: json['subject'],
    date: DateTime.parse(json['date']),
    durationMinutes: json['durationMinutes'],
    completed: json['completed'],
    notes: json['notes'] ?? '',
  );
}

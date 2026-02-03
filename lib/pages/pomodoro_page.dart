import 'dart:async';
import 'package:flutter/material.dart';
import '../services/streak_service.dart';

class PomodoroPage extends StatefulWidget {
  const PomodoroPage({super.key});

  @override
  State<PomodoroPage> createState() => _PomodoroPageState();
}

class _PomodoroPageState extends State<PomodoroPage> {
  // Configuration
  int _workMinutes = 25;
  int _shortBreakMinutes = 5;
  int _longBreakMinutes = 15;
  int _sessionsBeforeLongBreak = 4;

  // État
  PomodoroState _state = PomodoroState.idle;
  int _remainingSeconds = 0;
  int _completedSessions = 0;
  Timer? _timer;
  
  // Statistiques de la session
  int _totalWorkMinutes = 0;
  DateTime? _sessionStartTime;

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startWork() {
    setState(() {
      _state = PomodoroState.working;
      _remainingSeconds = _workMinutes * 60;
      _sessionStartTime = DateTime.now();
    });
    _startTimer();
  }

  void _startShortBreak() {
    setState(() {
      _state = PomodoroState.shortBreak;
      _remainingSeconds = _shortBreakMinutes * 60;
    });
    _startTimer();
  }

  void _startLongBreak() {
    setState(() {
      _state = PomodoroState.longBreak;
      _remainingSeconds = _longBreakMinutes * 60;
    });
    _startTimer();
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_remainingSeconds > 0) {
          _remainingSeconds--;
        } else {
          _onTimerComplete();
        }
      });
    });
  }

  void _onTimerComplete() {
    _timer?.cancel();
    
    if (_state == PomodoroState.working) {
      _completedSessions++;
      _totalWorkMinutes += _workMinutes;
      
      // Enregistrer l'activité
      StreakService().recordActivity('revision', amount: _workMinutes);
      
      // Déterminer le type de pause
      if (_completedSessions % _sessionsBeforeLongBreak == 0) {
        _showBreakDialog(isLong: true);
      } else {
        _showBreakDialog(isLong: false);
      }
    } else {
      // Fin de pause
      _showWorkDialog();
    }
  }

  void _pause() {
    _timer?.cancel();
    setState(() {
      _state = PomodoroState.paused;
    });
  }

  void _resume() {
    setState(() {
      if (_remainingSeconds > _shortBreakMinutes * 60) {
        _state = PomodoroState.working;
      } else {
        _state = PomodoroState.shortBreak;
      }
    });
    _startTimer();
  }

  void _reset() {
    _timer?.cancel();
    setState(() {
      _state = PomodoroState.idle;
      _remainingSeconds = 0;
    });
  }

  void _showBreakDialog({required bool isLong}) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        title: Row(
          children: [
            const Icon(Icons.celebration, color: Colors.amber),
            const SizedBox(width: 8),
            const Text('Session terminée !'),
          ],
        ),
        content: Text(
          isLong
              ? 'Bravo ! Vous avez complété $_sessionsBeforeLongBreak sessions.\nPrenez une longue pause de $_longBreakMinutes minutes.'
              : 'Bien joué ! Prenez une courte pause de $_shortBreakMinutes minutes.',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              if (isLong) {
                _startLongBreak();
              } else {
                _startShortBreak();
              }
            },
            child: const Text('Commencer la pause'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              _startWork();
            },
            child: const Text('Continuer à travailler'),
          ),
        ],
      ),
    );
  }

  void _showWorkDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.play_circle, color: Colors.green),
            SizedBox(width: 8),
            Text('Pause terminée !'),
          ],
        ),
        content: const Text('Prêt pour une nouvelle session de travail ?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              _reset();
            },
            child: const Text('Terminer'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              _startWork();
            },
            child: const Text('C\'est parti !'),
          ),
        ],
      ),
    );
  }

  String _formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final secs = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  Color _getStateColor() {
    switch (_state) {
      case PomodoroState.working:
        return Colors.red;
      case PomodoroState.shortBreak:
        return Colors.green;
      case PomodoroState.longBreak:
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  String _getStateLabel() {
    switch (_state) {
      case PomodoroState.working:
        return 'TRAVAIL';
      case PomodoroState.shortBreak:
        return 'PAUSE COURTE';
      case PomodoroState.longBreak:
        return 'PAUSE LONGUE';
      case PomodoroState.paused:
        return 'EN PAUSE';
      default:
        return 'PRÊT';
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF121212) : const Color(0xFFF5F7FA),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const BackButton(),
        title: const Text('Pomodoro', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => _showSettingsDialog(),
          ),
        ],
      ),
      body: Column(
        children: [
          // Timer principal
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // État
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: _getStateColor().withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      _getStateLabel(),
                      style: TextStyle(
                        color: _getStateColor(),
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2,
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 32),
                  
                  // Timer circulaire
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      SizedBox(
                        width: 250,
                        height: 250,
                        child: CircularProgressIndicator(
                          value: _state == PomodoroState.idle
                              ? 0
                              : 1 - (_remainingSeconds / (_state == PomodoroState.working
                                  ? _workMinutes * 60
                                  : (_state == PomodoroState.longBreak
                                      ? _longBreakMinutes * 60
                                      : _shortBreakMinutes * 60))),
                          strokeWidth: 12,
                          backgroundColor: Colors.grey.withOpacity(0.2),
                          valueColor: AlwaysStoppedAnimation(_getStateColor()),
                        ),
                      ),
                      Column(
                        children: [
                          Text(
                            _state == PomodoroState.idle
                                ? _formatTime(_workMinutes * 60)
                                : _formatTime(_remainingSeconds),
                            style: TextStyle(
                              fontSize: 56,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'monospace',
                              color: _getStateColor(),
                            ),
                          ),
                          Text(
                            'Session $_completedSessions',
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                        ],
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 48),
                  
                  // Contrôles
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (_state == PomodoroState.idle)
                        ElevatedButton.icon(
                          onPressed: _startWork,
                          icon: const Icon(Icons.play_arrow),
                          label: const Text('Démarrer'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                          ),
                        )
                      else if (_state == PomodoroState.paused)
                        Row(
                          children: [
                            ElevatedButton.icon(
                              onPressed: _resume,
                              icon: const Icon(Icons.play_arrow),
                              label: const Text('Reprendre'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                                foregroundColor: Colors.white,
                              ),
                            ),
                            const SizedBox(width: 12),
                            OutlinedButton.icon(
                              onPressed: _reset,
                              icon: const Icon(Icons.stop),
                              label: const Text('Arrêter'),
                            ),
                          ],
                        )
                      else
                        Row(
                          children: [
                            ElevatedButton.icon(
                              onPressed: _pause,
                              icon: const Icon(Icons.pause),
                              label: const Text('Pause'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.orange,
                                foregroundColor: Colors.white,
                              ),
                            ),
                            const SizedBox(width: 12),
                            OutlinedButton.icon(
                              onPressed: _reset,
                              icon: const Icon(Icons.stop),
                              label: const Text('Arrêter'),
                            ),
                          ],
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // Stats de la session
          Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatItem('Sessions', '$_completedSessions', Icons.check_circle),
                _buildStatItem('Travail', '$_totalWorkMinutes min', Icons.timer),
                _buildStatItem(
                  'Objectif',
                  '${(_totalWorkMinutes / 60).toStringAsFixed(1)}h',
                  Icons.flag,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: Colors.grey),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        Text(
          label,
          style: TextStyle(color: Colors.grey[600], fontSize: 12),
        ),
      ],
    );
  }

  void _showSettingsDialog() {
    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('Paramètres Pomodoro'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildSettingSlider(
                'Travail',
                _workMinutes,
                5,
                60,
                (value) => setDialogState(() => _workMinutes = value.round()),
              ),
              _buildSettingSlider(
                'Pause courte',
                _shortBreakMinutes,
                1,
                15,
                (value) => setDialogState(() => _shortBreakMinutes = value.round()),
              ),
              _buildSettingSlider(
                'Pause longue',
                _longBreakMinutes,
                10,
                30,
                (value) => setDialogState(() => _longBreakMinutes = value.round()),
              ),
              _buildSettingSlider(
                'Sessions avant pause longue',
                _sessionsBeforeLongBreak,
                2,
                6,
                (value) => setDialogState(() => _sessionsBeforeLongBreak = value.round()),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {});
                Navigator.pop(ctx);
              },
              child: const Text('Fermer'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingSlider(
    String label,
    int value,
    int min,
    int max,
    Function(double) onChanged,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label),
            Text('$value min', style: const TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
        Slider(
          value: value.toDouble(),
          min: min.toDouble(),
          max: max.toDouble(),
          divisions: max - min,
          onChanged: onChanged,
        ),
      ],
    );
  }
}

enum PomodoroState {
  idle,
  working,
  shortBreak,
  longBreak,
  paused,
}

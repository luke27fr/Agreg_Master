import 'dart:async';
import '../constants/app_constants.dart';

/// Utilitaire de debounce pour les champs de recherche
class Debouncer {
  final int milliseconds;
  Timer? _timer;

  Debouncer({this.milliseconds = AppNumbers.searchDebounceDurationMs});

  /// Exécute l'action après le délai de debounce
  void run(void Function() action) {
    _timer?.cancel();
    _timer = Timer(Duration(milliseconds: milliseconds), action);
  }

  /// Annule le timer en cours
  void cancel() {
    _timer?.cancel();
  }

  /// Dispose le debouncer
  void dispose() {
    _timer?.cancel();
    _timer = null;
  }
}

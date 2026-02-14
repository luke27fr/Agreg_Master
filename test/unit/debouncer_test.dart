import 'package:flutter_test/flutter_test.dart';
import 'package:agreg_master/utils/debouncer.dart';

void main() {
  group('Debouncer', () {
    test('should execute action after delay', () async {
      final debouncer = Debouncer(milliseconds: 100);
      int callCount = 0;
      
      debouncer.run(() => callCount++);
      
      expect(callCount, 0); // Not yet executed
      
      await Future.delayed(const Duration(milliseconds: 150));
      
      expect(callCount, 1); // Executed after delay
      
      debouncer.dispose();
    });

    test('should cancel previous call on rapid successive calls', () async {
      final debouncer = Debouncer(milliseconds: 100);
      int callCount = 0;
      
      debouncer.run(() => callCount++);
      debouncer.run(() => callCount++);
      debouncer.run(() => callCount++);
      
      await Future.delayed(const Duration(milliseconds: 150));
      
      expect(callCount, 1); // Only last call executed
      
      debouncer.dispose();
    });

    test('should not execute after cancel', () async {
      final debouncer = Debouncer(milliseconds: 100);
      int callCount = 0;
      
      debouncer.run(() => callCount++);
      debouncer.cancel();
      
      await Future.delayed(const Duration(milliseconds: 150));
      
      expect(callCount, 0); // Cancelled, not executed
      
      debouncer.dispose();
    });

    test('dispose should cancel pending action', () async {
      final debouncer = Debouncer(milliseconds: 100);
      int callCount = 0;
      
      debouncer.run(() => callCount++);
      debouncer.dispose();
      
      await Future.delayed(const Duration(milliseconds: 150));
      
      expect(callCount, 0);
    });
  });
}

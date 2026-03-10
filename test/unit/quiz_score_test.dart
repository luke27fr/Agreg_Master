import 'package:flutter_test/flutter_test.dart';
import 'package:agreg_master/services/score_service.dart';

void main() {
  group('QuizScore', () {
    test('should create with required fields', () {
      final date = DateTime(2025, 6, 15, 10, 30);
      final score = QuizScore(score: 8, total: 10, date: date);

      expect(score.score, 8);
      expect(score.total, 10);
      expect(score.date, date);
    });

    test('percentage returns correct value for positive total', () {
      final score = QuizScore(
        score: 7,
        total: 10,
        date: DateTime.now(),
      );
      expect(score.percentage, 70.0);
    });

    test('percentage returns 100 for perfect score', () {
      final score = QuizScore(
        score: 10,
        total: 10,
        date: DateTime.now(),
      );
      expect(score.percentage, 100.0);
    });

    test('percentage returns 0 for zero score', () {
      final score = QuizScore(
        score: 0,
        total: 10,
        date: DateTime.now(),
      );
      expect(score.percentage, 0.0);
    });

    test('percentage returns 0 when total is 0', () {
      final score = QuizScore(
        score: 0,
        total: 0,
        date: DateTime.now(),
      );
      expect(score.percentage, 0.0);
    });

    test('percentage handles fractional results', () {
      final score = QuizScore(
        score: 1,
        total: 3,
        date: DateTime.now(),
      );
      expect(score.percentage, closeTo(33.33, 0.01));
    });

    test('toJson produces correct map', () {
      final date = DateTime(2025, 6, 15, 10, 30);
      final score = QuizScore(score: 8, total: 10, date: date);
      final json = score.toJson();

      expect(json['score'], 8);
      expect(json['total'], 10);
      expect(json['date'], date.toIso8601String());
    });

    test('fromJson restores correct object', () {
      final date = DateTime(2025, 6, 15, 10, 30);
      final json = {
        'score': 8,
        'total': 10,
        'date': date.toIso8601String(),
      };
      final score = QuizScore.fromJson(json);

      expect(score.score, 8);
      expect(score.total, 10);
      expect(score.date, date);
    });

    test('serialization roundtrip preserves data', () {
      final original = QuizScore(
        score: 15,
        total: 20,
        date: DateTime(2025, 3, 10, 14, 0),
      );
      final restored = QuizScore.fromJson(original.toJson());

      expect(restored.score, original.score);
      expect(restored.total, original.total);
      expect(restored.date, original.date);
      expect(restored.percentage, original.percentage);
    });
  });

  group('QuizHistoryEntry', () {
    test('should create with all required fields', () {
      final date = DateTime(2025, 6, 15);
      final entry = QuizHistoryEntry(
        ficheId: 'algebre_01',
        score: 8,
        total: 10,
        date: date,
        wrongQuestionIndices: [2, 5],
      );

      expect(entry.ficheId, 'algebre_01');
      expect(entry.score, 8);
      expect(entry.total, 10);
      expect(entry.date, date);
      expect(entry.wrongQuestionIndices, [2, 5]);
    });

    test('percentage returns correct value', () {
      final entry = QuizHistoryEntry(
        ficheId: 'test',
        score: 3,
        total: 4,
        date: DateTime.now(),
        wrongQuestionIndices: [1],
      );
      expect(entry.percentage, 75.0);
    });

    test('percentage returns 0 when total is 0', () {
      final entry = QuizHistoryEntry(
        ficheId: 'test',
        score: 0,
        total: 0,
        date: DateTime.now(),
        wrongQuestionIndices: [],
      );
      expect(entry.percentage, 0.0);
    });

    test('toJson produces correct map', () {
      final date = DateTime(2025, 6, 15);
      final entry = QuizHistoryEntry(
        ficheId: 'analyse_03',
        score: 9,
        total: 10,
        date: date,
        wrongQuestionIndices: [7],
      );
      final json = entry.toJson();

      expect(json['ficheId'], 'analyse_03');
      expect(json['score'], 9);
      expect(json['total'], 10);
      expect(json['date'], date.toIso8601String());
      expect(json['wrongQuestionIndices'], [7]);
    });

    test('fromJson restores correct object', () {
      final date = DateTime(2025, 6, 15);
      final json = {
        'ficheId': 'analyse_03',
        'score': 9,
        'total': 10,
        'date': date.toIso8601String(),
        'wrongQuestionIndices': [7],
      };
      final entry = QuizHistoryEntry.fromJson(json);

      expect(entry.ficheId, 'analyse_03');
      expect(entry.score, 9);
      expect(entry.total, 10);
      expect(entry.date, date);
      expect(entry.wrongQuestionIndices, [7]);
    });

    test('fromJson handles null wrongQuestionIndices', () {
      final json = {
        'ficheId': 'test',
        'score': 5,
        'total': 5,
        'date': DateTime.now().toIso8601String(),
      };
      final entry = QuizHistoryEntry.fromJson(json);
      expect(entry.wrongQuestionIndices, isEmpty);
    });

    test('fromJson handles empty wrongQuestionIndices', () {
      final json = {
        'ficheId': 'test',
        'score': 5,
        'total': 5,
        'date': DateTime.now().toIso8601String(),
        'wrongQuestionIndices': <int>[],
      };
      final entry = QuizHistoryEntry.fromJson(json);
      expect(entry.wrongQuestionIndices, isEmpty);
    });

    test('serialization roundtrip preserves data', () {
      final original = QuizHistoryEntry(
        ficheId: 'proba_02',
        score: 6,
        total: 8,
        date: DateTime(2025, 1, 20, 9, 0),
        wrongQuestionIndices: [0, 3],
      );
      final restored = QuizHistoryEntry.fromJson(original.toJson());

      expect(restored.ficheId, original.ficheId);
      expect(restored.score, original.score);
      expect(restored.total, original.total);
      expect(restored.date, original.date);
      expect(restored.wrongQuestionIndices, original.wrongQuestionIndices);
    });
  });
}

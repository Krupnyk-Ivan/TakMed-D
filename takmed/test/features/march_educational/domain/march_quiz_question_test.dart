import 'package:flutter_test/flutter_test.dart';
import 'package:takmed/features/march/domain/models/march_step.dart';
import 'package:takmed/features/march_educational/domain/entities/march_quiz_question.dart';

void main() {
  group('MarchQuizQuestion Randomization', () {
    test('shuffled() should keep the correct answer valid', () {
      const question = MarchQuizQuestion(
        step: MarchStep.massiveHemorrhage,
        question: 'Test Question',
        options: ['Correct', 'Wrong 1', 'Wrong 2', 'Wrong 3'],
        correctIndex: 0,
        explanation: 'Test Exp',
      );

      final shuffled = question.shuffled();

      // Текст правильної відповіді має залишитися таким самим
      final originalCorrectText = question.options[question.correctIndex];
      final shuffledCorrectText = shuffled.options[shuffled.correctIndex];

      expect(shuffledCorrectText, equals(originalCorrectText));
      expect(shuffled.options.length, equals(question.options.length));
      expect(shuffled.options, containsAll(question.options));
    });

    test('shuffled() should eventually change the order (statistical)', () {
      const question = MarchQuizQuestion(
        step: MarchStep.massiveHemorrhage,
        question: 'Test Question',
        options: ['A', 'B', 'C', 'D', 'E', 'F'],
        correctIndex: 0,
        explanation: 'Test Exp',
      );

      bool orderChanged = false;
      for (int i = 0; i < 10; i++) {
        final shuffled = question.shuffled();
        if (shuffled.options[0] != 'A') {
          orderChanged = true;
          break;
        }
      }

      expect(orderChanged, isTrue, reason: 'Order should change at least once in 10 shuffles');
    });
  });
}

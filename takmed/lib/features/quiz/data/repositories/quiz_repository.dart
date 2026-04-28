import 'dart:convert';
import '../../domain/entities/answer_option.dart';
import '../../domain/entities/quiz_question.dart';
import '../../domain/entities/sequence_item.dart';
import '../../../../core/database/app_database.dart';

class QuizRepository {
  final AppDatabase _db;

  QuizRepository(this._db);

  Future<List<QuizQuestion>> getQuizQuestions(String topicId) async {
    final lessonId = int.tryParse(topicId);
    if (lessonId == null) {
      return _getMockQuestions();
    }

    final lesson = await _db.lessonDao.getLessonById(lessonId);
    if (lesson == null || lesson.contentJson.isEmpty) {
      return _getMockQuestions();
    }

    try {
      final decoded = jsonDecode(lesson.contentJson);
      
      List<dynamic> rawQuestions = [];
      if (decoded is List) {
        rawQuestions = decoded;
      } else if (decoded is Map<String, dynamic> && decoded.containsKey('questions')) {
        rawQuestions = decoded['questions'] as List<dynamic>;
      }

      final List<QuizQuestion> result = [];
      for (int i = 0; i < rawQuestions.length; i++) {
        final q = rawQuestions[i] as Map<String, dynamic>;
        final type = q['type'] as String?;
        final id = 'q_$i';
        
        if (type == 'multiple_choice' || type == null) {
          final questionText = (q['question'] ?? '') as String;
          final explanation = (q['explanation'] ?? '') as String;
          final rawOptions = q['options'] as List<dynamic>? ?? [];
          final correctIndex = q['correctIndex'] as int? ?? 0;
          final tags = (q['tags'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [];
          
          final options = <AnswerOption>[];
          String correctId = 'opt_0';
          for (int j = 0; j < rawOptions.length; j++) {
            final optId = 'opt_$j';
            options.add(AnswerOption(id: optId, text: rawOptions[j].toString()));
            if (j == correctIndex) correctId = optId;
          }
          
          // Перемішуємо варіанти відповідей
          options.shuffle();

          result.add(QuizQuestion.multipleChoice(
            id: id,
            text: questionText,
            tags: tags,
            options: options,
            correctId: correctId,
            explanation: explanation,
          ));
        } else if (type == 'true_false') {
          final questionText = (q['question'] ?? '') as String;
          final explanation = (q['explanation'] ?? '') as String;
          final correctAnswer = q['correctAnswer'] as bool? ?? true;
          final tags = (q['tags'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [];
          
          result.add(QuizQuestion.trueFalse(
            id: id,
            statement: questionText,
            tags: tags,
            correctAnswer: correctAnswer,
            explanation: explanation,
          ));
        } else if (type == 'sequence') {
          final questionText = (q['question'] ?? '') as String;
          final explanation = (q['explanation'] ?? '') as String;
          final tags = (q['tags'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [];
          final correctOrder = q['correctOrder'] as List<dynamic>? ?? [];
          
          final items = <SequenceItem>[];
          for (int j = 0; j < correctOrder.length; j++) {
            items.add(SequenceItem(
              id: 'seq_$j',
              text: correctOrder[j].toString(),
              correctIndex: j,
            ));
          }
          
          // Перемішуємо елементи послідовності (correctIndex на кожному елементі зберігається)
          items.shuffle();

          result.add(QuizQuestion.sequence(
            id: id,
            instruction: questionText,
            tags: tags,
            items: items,
            explanation: explanation,
          ));
        }
      }
      return result;
    } catch (e) {
      print('Error parsing quiz JSON: $e');
      return _getMockQuestions();
    }
  }

  List<QuizQuestion> _getMockQuestions() {
    return [
      const QuizQuestion.multipleChoice(
        id: 'q1',
        text: 'Що означає літера "M" у протоколі MARCH?',
        options: [
          AnswerOption(id: 'a1', text: 'Massive Hemorrhage (Масивна кровотеча)'),
          AnswerOption(id: 'a2', text: 'Movement (Рух)'),
        ],
        correctId: 'a1',
        explanation: 'Першим кроком є зупинка масивної кровотечі.',
      ),
    ];
  }
}

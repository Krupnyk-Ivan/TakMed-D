import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:takmed/features/gamification/data/services/gamification_service.dart';
import 'package:takmed/features/learning/domain/repositories/learning_repository.dart';
import 'package:takmed/features/march/domain/models/march_step.dart';
import 'package:takmed/features/march_educational/domain/entities/march_item.dart';
import 'package:takmed/features/march_educational/domain/entities/march_session.dart';
import 'package:takmed/features/march_educational/domain/repositories/march_repository.dart';
import 'package:takmed/features/march_educational/presentation/bloc/march_educational_bloc.dart';
import 'package:takmed/features/march_educational/presentation/bloc/march_educational_event.dart';
import 'package:takmed/features/march_educational/presentation/bloc/march_educational_state.dart';
import 'package:takmed/core/errors/failures.dart';

class FakeMarchRepository implements MarchRepository {
  int saveCalls = 0;
  @override
  Future<Either<Failure, int>> saveSession(MarchSession session) async {
    saveCalls++;
    return const Right(1);
  }
}

class FakeLearningRepository implements LearningRepository {
  int completeCalls = 0;
  int lastScore = -1;
  @override
  Future<Either<Failure, Unit>> completeLesson(int lessonId, int score) async {
    completeCalls++;
    lastScore = score;
    return const Right(unit);
  }
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late FakeMarchRepository mockRepo;
  late FakeLearningRepository learningRepo;
  late GamificationService gamification;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    gamification = GamificationService(prefs);
    mockRepo = FakeMarchRepository();
    learningRepo = FakeLearningRepository();
  });

  MarchEducationalBloc buildBloc({int? lessonId}) =>
      MarchEducationalBloc(mockRepo, gamification, learningRepo, lessonId: lessonId);

  group('MarchSessionStarted', () {
    blocTest<MarchEducationalBloc, MarchEducationalState>(
      'створює свіжу сесію з активним M',
      build: buildBloc,
      act: (bloc) => bloc.add(const MarchSessionStarted()),
      expect: () => [
        isA<MarchEducationalState>()
            .having((s) => s.status, 'status', MarchEducationalStatus.running)
            .having((s) => s.session?.items.first.step,
                'first step', MarchStep.massiveHemorrhage)
            .having((s) => s.session?.items.first.status,
                'first.status', MarchItemStatus.active),
      ],
    );
  });

  group('MarchQuizAnswered', () {
    blocTest<MarchEducationalBloc, MarchEducationalState>(
      'неправильна відповідь → quizAnsweredCorrectly = false',
      build: buildBloc,
      act: (bloc) async {
        bloc.add(const MarchSessionStarted());
        await Future<void>.delayed(Duration.zero);
        bloc.add(const MarchStepCompleteRequested());
        await Future<void>.delayed(Duration.zero);
        bloc.add(const MarchQuizAnswered(2)); // Wrong answer
      },
      skip: 2,
      expect: () => [
        isA<MarchEducationalState>()
            .having((s) => s.session?.items[0].quizAnsweredCorrectly, 'correct', false)
            .having((s) => s.status, 'status', MarchEducationalStatus.quizFailed),
      ],
    );
  });

  group('Final completion with real score', () {
    blocTest<MarchEducationalBloc, MarchEducationalState>(
      'завершення сесії викликає completeLesson при всіх правильних відповідях',
      build: () => buildBloc(lessonId: 101),
      act: (bloc) async {
        bloc.add(const MarchSessionStarted());
        
        for(int i=0; i<5; i++) {
          await Future<void>.delayed(const Duration(milliseconds: 10));
          bloc.add(const MarchStepCompleteRequested());
          await Future<void>.delayed(const Duration(milliseconds: 10));
          
          final correctIdx = (bloc.state as MarchEducationalState).activeQuiz!.correctIndex;
          bloc.add(MarchQuizAnswered(correctIdx)); 
        }
        
        // Очікуємо завершення асинхронного збереження
        for(int i=0; i<20; i++) {
          if (bloc.state.status == MarchEducationalStatus.saved) break;
          await Future<void>.delayed(const Duration(milliseconds: 10));
        }
      },
      verify: (bloc) {
        expect(learningRepo.completeCalls, 1, reason: 'completeLesson should be called once');
        expect(learningRepo.lastScore, 100);
        expect(bloc.state.status, MarchEducationalStatus.saved);
      },
    );
  });
}

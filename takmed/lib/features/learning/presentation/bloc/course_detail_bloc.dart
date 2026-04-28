import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/course_entity.dart';
import '../../domain/entities/lesson_entity.dart';
import '../../domain/usecases/get_lessons_by_course_usecase.dart';
import '../../domain/usecases/complete_lesson_usecase.dart';
import '../../domain/repositories/learning_repository.dart';

// — Events —

abstract class CourseDetailEvent extends Equatable {
  const CourseDetailEvent();
  @override
  List<Object?> get props => [];
}

class CourseDetailStarted extends CourseDetailEvent {
  const CourseDetailStarted(this.courseId);
  final int courseId;
  @override
  List<Object?> get props => [courseId];
}

class CourseDetailLessonCompleted extends CourseDetailEvent {
  const CourseDetailLessonCompleted(this.lessonId);
  final int lessonId;
  @override
  List<Object?> get props => [lessonId];
}

// — State —

enum CourseDetailStatus { initial, loading, loaded, error }

class CourseDetailState extends Equatable {
  const CourseDetailState({
    this.status = CourseDetailStatus.initial,
    this.course,
    this.lessons = const [],
    this.errorMessage,
  });

  final CourseDetailStatus status;
  final CourseEntity? course;
  final List<LessonEntity> lessons;
  final String? errorMessage;

  CourseDetailState copyWith({
    CourseDetailStatus? status,
    CourseEntity? course,
    List<LessonEntity>? lessons,
    String? errorMessage,
  }) {
    return CourseDetailState(
      status: status ?? this.status,
      course: course ?? this.course,
      lessons: lessons ?? this.lessons,
      errorMessage: errorMessage,
    );
  }

  /// Чи доступний урок (lock/unlock).
  bool isLessonUnlocked(int index) {
    if (index == 0) return true;
    return lessons[index - 1].isCompleted;
  }

  @override
  List<Object?> get props => [status, course, lessons, errorMessage];
}

// — BLoC —

class CourseDetailBloc extends Bloc<CourseDetailEvent, CourseDetailState> {
  CourseDetailBloc(
    this._getLessonsByCourseUseCase,
    this._completeLessonUseCase,
    this._repository,
  ) : super(const CourseDetailState()) {
    on<CourseDetailStarted>(_onStarted);
    on<CourseDetailLessonCompleted>(_onLessonCompleted);
  }

  final GetLessonsByCourseUseCase _getLessonsByCourseUseCase;
  final CompleteLessonUseCase _completeLessonUseCase;
  final LearningRepository _repository;

  Future<void> _onStarted(
    CourseDetailStarted event,
    Emitter<CourseDetailState> emit,
  ) async {
    emit(state.copyWith(status: CourseDetailStatus.loading));

    final courseResult = await _repository.getCourseById(event.courseId);
    courseResult.fold(
      (f) => emit(state.copyWith(
        status: CourseDetailStatus.error,
        errorMessage: f.message,
      )),
      (course) {
        if (course != null) {
          emit(state.copyWith(course: course));
        }
      },
    );

    await emit.forEach<List<LessonEntity>>(
      _getLessonsByCourseUseCase(event.courseId),
      onData: (lessons) => state.copyWith(
        status: CourseDetailStatus.loaded,
        lessons: lessons,
      ),
      onError: (e, _) => state.copyWith(
        status: CourseDetailStatus.error,
        errorMessage: e.toString(),
      ),
    );
  }

  Future<void> _onLessonCompleted(
    CourseDetailLessonCompleted event,
    Emitter<CourseDetailState> emit,
  ) async {
    await _completeLessonUseCase(event.lessonId);
  }
}

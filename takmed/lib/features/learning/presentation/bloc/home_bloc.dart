import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../gamification/data/services/gamification_service.dart';
import '../../../gamification/data/services/streak_service.dart';
import '../../../gamification/domain/models/user_level.dart';
import '../../../onboarding/domain/usecases/get_track_use_case.dart';
import '../../domain/entities/course_entity.dart';
import '../../domain/entities/lesson_entity.dart';
import '../../domain/repositories/learning_repository.dart';
import '../../domain/usecases/get_courses_by_track_usecase.dart';
import '../../domain/usecases/get_next_lesson_usecase.dart';
import '../../domain/usecases/download_course_offline_usecase.dart';

// — Events —

abstract class HomeEvent extends Equatable {
  const HomeEvent();
  @override
  List<Object?> get props => [];
}

class HomeStarted extends HomeEvent {
  const HomeStarted();
}

class HomeRefreshRequested extends HomeEvent {
  const HomeRefreshRequested();
}

class HomeDownloadCourseRequested extends HomeEvent {
  const HomeDownloadCourseRequested(this.courseId);
  final int courseId;
  @override
  List<Object?> get props => [courseId];
}

// — State —

enum HomeStatus { initial, loading, loaded, error }

class HomeState extends Equatable {
  const HomeState({
    this.status = HomeStatus.initial,
    this.courses = const [],
    this.nextLesson,
    this.track = 'military',
    this.streak = 0,
    this.bestStreak = 0,
    this.totalXp = 0,
    this.currentLevel = UserLevel.recruit,
    this.errorMessage,
  });

  final HomeStatus status;
  final List<CourseEntity> courses;
  final LessonEntity? nextLesson;
  final String track;
  final int streak;
  final int bestStreak;
  final int totalXp;
  final UserLevel currentLevel;
  final String? errorMessage;

  HomeState copyWith({
    HomeStatus? status,
    List<CourseEntity>? courses,
    LessonEntity? nextLesson,
    String? track,
    int? streak,
    int? bestStreak,
    int? totalXp,
    UserLevel? currentLevel,
    String? errorMessage,
    bool clearNextLesson = false,
  }) {
    return HomeState(
      status: status ?? this.status,
      courses: courses ?? this.courses,
      nextLesson: clearNextLesson ? null : (nextLesson ?? this.nextLesson),
      track: track ?? this.track,
      streak: streak ?? this.streak,
      bestStreak: bestStreak ?? this.bestStreak,
      totalXp: totalXp ?? this.totalXp,
      currentLevel: currentLevel ?? this.currentLevel,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props =>
      [status, courses, nextLesson, track, streak, bestStreak, totalXp, currentLevel, errorMessage];
}

// — BLoC —

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc(
    this._getCoursesByTrackUseCase,
    this._getNextLessonUseCase,
    this._getTrackUseCase,
    this._downloadCourseOfflineUseCase,
    this._gamificationService,
    this._streakService,
    this._learningRepository,
  ) : super(const HomeState()) {
    on<HomeStarted>(_onStarted);
    on<HomeRefreshRequested>(_onRefresh);
    on<HomeDownloadCourseRequested>(_onDownload);
  }

  final GetCoursesByTrackUseCase _getCoursesByTrackUseCase;
  final GetNextLessonUseCase _getNextLessonUseCase;
  final GetTrackUseCase _getTrackUseCase;
  final DownloadCourseOfflineUseCase _downloadCourseOfflineUseCase;
  final GamificationService _gamificationService;
  final StreakService _streakService;
  final LearningRepository _learningRepository;

  StreamSubscription<List<CourseEntity>>? _coursesSubscription;

  Future<void> _onStarted(HomeStarted event, Emitter<HomeState> emit) async {
    emit(state.copyWith(status: HomeStatus.loading));

    // Запускаємо фонову синхронізацію при старті
    unawaited(_learningRepository.syncWithServer());

    String track = 'military';
    final trackResult = await _getTrackUseCase();
    trackResult.fold((_) {}, (t) {
      if (t != null) track = t.name;
    });

    final nextResult = await _getNextLessonUseCase();
    LessonEntity? nextLesson;
    nextResult.fold((_) {}, (l) => nextLesson = l);

    await _streakService.checkStreak();

    emit(state.copyWith(
      track: track,
      nextLesson: nextLesson,
      clearNextLesson: nextLesson == null,
      streak: _streakService.getCurrentStreak(),
      bestStreak: _streakService.getBestStreak(),
      totalXp: _gamificationService.getTotalXp(),
      currentLevel: _gamificationService.getCurrentLevel(),
    ));

    await _coursesSubscription?.cancel();
    _coursesSubscription = _getCoursesByTrackUseCase(track).listen((courses) {
      add(const HomeRefreshRequested());
    });

    await emit.forEach<List<CourseEntity>>(
      _getCoursesByTrackUseCase(track),
      onData: (courses) => state.copyWith(
        status: HomeStatus.loaded,
        courses: courses,
      ),
      onError: (e, _) => state.copyWith(
        status: HomeStatus.error,
        errorMessage: e.toString(),
      ),
    );
  }

  Future<void> _onRefresh(HomeRefreshRequested event, Emitter<HomeState> emit) async {
    final nextResult = await _getNextLessonUseCase();
    nextResult.fold(
      (_) {},
      (l) => emit(state.copyWith(
        nextLesson: l,
        clearNextLesson: l == null,
        streak: _streakService.getCurrentStreak(),
        bestStreak: _streakService.getBestStreak(),
        totalXp: _gamificationService.getTotalXp(),
        currentLevel: _gamificationService.getCurrentLevel(),
      )),
    );
  }

  Future<void> _onDownload(HomeDownloadCourseRequested event, Emitter<HomeState> emit) async {
    await _downloadCourseOfflineUseCase(event.courseId);
  }

  @override
  Future<void> close() {
    _coursesSubscription?.cancel();
    return super.close();
  }
}

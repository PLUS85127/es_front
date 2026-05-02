import 'package:es_control/features/lesson_study/domain/use_cases/mark_day_as_read_usecase.dart';
import 'package:get_it/get_it.dart';
import '../../features/lesson_study/data/repositories/lesson_repository_impl.dart';
import '../../features/lesson_study/domain/repositories/lesson_repository.dart';
import '../../features/lesson_study/domain/use_cases/get_quarterlies_usecase.dart';
import '../../features/lesson_study/domain/use_cases/get_lessons_usecase.dart';
import '../../features/lesson_study/domain/use_cases/get_day_read_usecase.dart';
import '../../features/lesson_study/presentation/providers/lesson_provider.dart';

void initLesson(GetIt sl) {
  //repositorios
  sl.registerLazySingleton<LessonRepository>(() => LessonRepositoryImpl());

  //casos de uso
  sl.registerLazySingleton(() => GetQuarterliesUseCase(sl()));
  sl.registerLazySingleton(() => GetLessonsUseCase(sl()));
  sl.registerLazySingleton(() => GetDayReadUseCase(sl()));
  sl.registerLazySingleton(() => MarkDayAsReadUseCase(sl()));

  //providers
  sl.registerFactory(
    () => LessonProvider(
      getQuarterliesUseCase: sl(),
      getLessonsUseCase: sl(),
      getDayReadUseCase: sl(),
      markDayAsReadUseCase: sl(),
    ),
  );
}

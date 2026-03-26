import 'package:get_it/get_it.dart';
import 'package:es_control/features/lesson_study/domain/repositories/lesson_repository_impl.dart';
import 'package:es_control/features/lesson_study/domain/repositories/lesson_repository.dart';
import 'package:es_control/features/lesson_study/presentation/providers/lesson_provider.dart';

final sl = GetIt.instance; // sl = Service Locator

Future<void> init() async {
  // 1. Features - Lesson Study
  sl.registerFactory(() => LessonProvider(repository: sl()));

  sl.registerLazySingleton<LessonRepository>(() => LessonRepositoryImpl());
}

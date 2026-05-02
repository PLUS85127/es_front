import 'package:get_it/get_it.dart';
import 'lesson_injector.dart';
import 'auth_injector.dart';
import 'reporting_injector.dart';
import 'group_injector.dart';

final sl = GetIt.instance;

Future<void> init() async {
  await initAuthInjector(sl);
  await initLessonInjector(sl);
  await initReportingInjector(sl);
  await initGroupInjector(sl);
}

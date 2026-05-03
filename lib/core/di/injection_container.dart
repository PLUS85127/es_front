import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'lesson_injector.dart';
import 'auth_injector.dart';
import 'reporting_injector.dart';
import 'group_injector.dart';
import 'admin_injector.dart';
import 'church_injector.dart';

final sl = GetIt.instance;

Future<void> init() async {
  sl.registerLazySingleton(() => http.Client());

  initAuth(sl);
  initLesson(sl);
  initReporting(sl);
  initGroup(sl);
  initAdmin(sl);
  initChurch(sl);
}

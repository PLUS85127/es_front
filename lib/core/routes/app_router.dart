import 'package:flutter/material.dart';
import 'package:es_control/features/authentication/presentation/page/welcome_page.dart';
import 'package:es_control/features/authentication/presentation/page/login_page.dart';
import 'package:es_control/features/authentication/presentation/page/register_page.dart';
import 'package:es_control/features/home/presentation/page/home_page.dart';
import 'package:es_control/features/navigation/presentation/page/main_page.dart';
import 'package:es_control/features/lesson_study/presentation/page/lesson_list_page.dart';
import 'package:es_control/features/lesson_study/presentation/page/lesson_detail_page.dart';
import 'package:es_control/features/lesson_study/presentation/page/lessons_study_page.dart';

class AppRoutes {
  static const String welcome = '/';
  static const String login = '/login';
  static const String register = '/register';
  static const String main = '/main';
  static const String home = '/home';

  // Rutas de las lecciones
  static const String lessonList = '/lessons';
  static const String lessonDetail = '/lesson_detail';
  static const String lessonStudy = '/lesson_study';
}

class AppRouter {
  static Map<String, WidgetBuilder> getRoutes() {
    return {
      AppRoutes.welcome: (context) => const WelcomePage(),
      AppRoutes.login: (context) => const LoginPage(),
      AppRoutes.register: (context) => const RegisterPage(),
      AppRoutes.main: (context) => const MainPage(),
      AppRoutes.home: (context) => const HomePage(),
      AppRoutes.lessonStudy: (context) => const LessonsStudyPage(),

      AppRoutes.lessonList: (context) {
        final args =
            ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;
        return LessonListPage(
          quarterlyId: args['qId'],
          title: args['title'] ?? "Lecciones",
        );
      },
      AppRoutes.lessonDetail: (context) {
        final args =
            ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;
        return LessonDetailPage(
          quarterlyId: args['qId'] ?? '',
          lessonId: args['lId'] ?? '',
          dayId: args['dId'] ?? '01',
          title: args['title'] ?? '',
        );
      },
    };
  }
}

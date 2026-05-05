import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:es_control/core/di/injection_container.dart' as di;

import 'package:es_control/features/authentication/presentation/provider/auth_provider.dart';
import 'package:es_control/features/reporting/presentation/provider/stats_provider.dart';
import 'package:es_control/features/lesson_study/presentation/providers/lesson_provider.dart';
import 'package:es_control/features/admin/presentation/provider/admin_provider.dart';
import 'package:es_control/features/groups/presentation/provider/group_provider.dart';
import 'package:es_control/features/churches/presentation/provider/church_provider.dart';

import 'package:es_control/core/providers/theme_provider.dart';
import 'package:es_control/core/routes/app_router.dart';
import 'package:es_control/core/theme/app_theme.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  await di.init();
  runApp(const ESControlApp());
}

class ESControlApp extends StatelessWidget {
  const ESControlApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => di.sl<LessonProvider>()),
        ChangeNotifierProvider(create: (_) => di.sl<AuthProvider>()),
        ChangeNotifierProvider(create: (_) => di.sl<StatsProvider>()),
        ChangeNotifierProvider(create: (_) => di.sl<GroupProvider>()),
        ChangeNotifierProvider(create: (_) => di.sl<AdminProvider>()),
        ChangeNotifierProvider(create: (_) => di.sl<ChurchProvider>()),
      ],

      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            title: 'ES Control',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: themeProvider.themeMode,
            initialRoute: AppRoutes.welcome,
            routes: AppRouter.getRoutes(), //
          );
        },
      ),
    );
  }
}

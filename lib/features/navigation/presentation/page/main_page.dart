import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:es_control/features/authentication/domain/entities/user_entity.dart';
import 'package:es_control/features/authentication/presentation/provider/auth_provider.dart';

import 'package:es_control/features/home/presentation/page/home_page.dart';
import 'package:es_control/features/reporting/presentation/page/history_page.dart';
import 'package:es_control/features/authentication/presentation/page/profile_page.dart';
import 'package:es_control/features/lesson_study/presentation/page/lessons_study_page.dart';
import 'package:es_control/features/groups/presentation/page/groups_page.dart';

import '../widgets/top_mode_toggle.dart';
import '../widgets/custom_bottom_nav_bar.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _currentIndex = 0;
  bool _isAdminMode = false;

  final List<IconData> _personalIcons = [
    Icons.home,
    Icons.menu_book_rounded,
    Icons.bar_chart_rounded,
    Icons.person_rounded,
  ];
  final List<IconData> _adminIcons = [
    Icons.group_rounded,
    Icons.person_rounded,
  ];

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final role = auth.user?.role ?? UserRole.member;
    //final bool canSeeAdmin = role != UserRole.member;

    //pantallas
    final List<Widget> currentPages = _isAdminMode
        ? [
            GroupsPage(
              isAdminMode: _isAdminMode,
              onModeChanged: (val) => setState(() {
                _isAdminMode = val;
                _currentIndex = 0;
              }),
            ),
            const Scaffold(body: Center(child: Text("Panel de Grupos"))),
          ]
        : [
            HomePage(
              isAdminMode: _isAdminMode,
              onModeChanged: (val) {
                setState(() {
                  _isAdminMode = val;
                  _currentIndex = 0;
                });
              },
            ),
            const LessonsStudyPage(),
            const HistoryPage(),
            const ProfilePage(),
          ];

    return Scaffold(
      extendBody: true,
      body: IndexedStack(index: _currentIndex, children: currentPages),
      bottomNavigationBar: CustomBottomNavBar(
        isAdminMode: _isAdminMode,
        currentIndex: _currentIndex,
        personalIcons: _personalIcons,
        adminIcons: _adminIcons,
        onTap: (index) => setState(() => _currentIndex = index),
      ),
    );
  }
}

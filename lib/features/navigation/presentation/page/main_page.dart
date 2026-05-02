import 'package:flutter/material.dart';
import 'package:es_control/core/theme/app_theme.dart';
import 'package:es_control/features/home/presentation/page/home_page.dart';
import 'package:es_control/features/reporting/presentation/page/history_page.dart';
import 'package:es_control/features/authentication/presentation/page/profile_page.dart';
import 'package:es_control/features/lesson_study/presentation/page/lessons_study_page.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const HomePage(), // Feature: home
    const LessonsStudyPage(), // Feature: lessons
    const HistoryPage(), // Feature: history
    const ProfilePage(), // Feature: profile
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: Colors.white,
      body: IndexedStack(index: _currentIndex, children: _pages),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildBottomNav() {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.only(bottom: 15, left: 20, right: 15),
      height: 60,
      decoration: BoxDecoration(
        color: Theme.of(context).canvasColor,

        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.2 : 0.05),
            blurRadius: 10,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavItem(Icons.home, 0),
            _buildNavItem(Icons.menu_book_rounded, 1),
            _buildNavItem(Icons.bar_chart_rounded, 2),
            _buildNavItem(Icons.person_rounded, 3),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, int index) {
    final bool isActive = _currentIndex == index;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: () => setState(() => _currentIndex = index),
      child: Container(
        padding: const EdgeInsets.all(8),
        color: Colors.transparent,
        child: Icon(
          icon,
          size: 26,
          color: isActive
              ? (isDark ? AppTheme.yellowDecorative : AppTheme.navyBlue)
              : (isDark ? Colors.white38 : Colors.black45),
        ),
      ),
    );
  }
}

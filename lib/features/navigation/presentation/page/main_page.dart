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
      backgroundColor: Colors.white,
      body: IndexedStack(index: _currentIndex, children: _pages),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildBottomNav() {
    return Container(
      margin: const EdgeInsets.only(bottom: 20, left: 20, right: 20),
      height: 80,
      decoration: BoxDecoration(
        color: const Color(0xFFE0E0E0).withOpacity(0.8),
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 15,
            offset: const Offset(0, 5),
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
    return GestureDetector(
      onTap: () => setState(() => _currentIndex = index),
      child: Container(
        padding: const EdgeInsets.all(12),
        color: Colors.transparent,
        child: Icon(
          icon,
          size: 30,
          color: isActive ? AppTheme.navyBlue : Colors.black45,
        ),
      ),
    );
  }
}

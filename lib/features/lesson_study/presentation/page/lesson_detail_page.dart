import 'package:es_control/core/theme/theme_extension.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:es_control/core/theme/app_theme.dart';
import '../widgets/study_content.dart';

class LessonDetailPage extends StatefulWidget {
  final String quarterlyId;
  final String lessonId;
  final String dayId;
  final String title;

  const LessonDetailPage({
    super.key,
    required this.quarterlyId,
    required this.lessonId,
    required this.dayId,
    required this.title,
  });

  @override
  State<LessonDetailPage> createState() => _LessonDetailPageState();
}

class _LessonDetailPageState extends State<LessonDetailPage> {
  late PageController _pageController;
  int _currentPageIndex = 0;

  @override
  void initState() {
    super.initState();
    _currentPageIndex = int.parse(widget.dayId) - 1;
    _pageController = PageController(initialPage: _currentPageIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: context.iconColor, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          widget.title,
          style: GoogleFonts.poppins(
            color: context.textColor,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ),
      body: PageView.builder(
        controller: _pageController,
        itemCount: 7,
        onPageChanged: (index) => setState(() => _currentPageIndex = index),
        itemBuilder: (context, index) {
          final String dayId = (index + 1).toString().padLeft(2, '0');

          return StudyContent(
            key: ValueKey("${widget.lessonId}-$dayId"),
            quarterlyId: widget.quarterlyId,
            lessonId: widget.lessonId,
            dayId: dayId,
          );
        },
      ),
      bottomNavigationBar: _buildDaySelector(),
    );
  }

  Widget _buildDaySelector() {
    final List<String> shortDays = ['S', 'D', 'L', 'M', 'M', 'J', 'V'];
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 30),
      color: context.cardColor,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(7, (index) {
          bool isSelected = _currentPageIndex == index;
          return GestureDetector(
            onTap: () => _pageController.animateToPage(
              index,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
            ),
            child: CircleAvatar(
              radius: 18,
              backgroundColor: isSelected
                  ? context.iconColor
                  : Colors.transparent,
              child: Text(
                shortDays[index],
                style: TextStyle(
                  color: isSelected
                      ? (context.isDark
                            ? AppTheme.darkBackground
                            : Colors.white)
                      : context.textColor,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}

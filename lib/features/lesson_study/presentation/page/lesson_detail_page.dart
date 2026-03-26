import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:es_control/core/theme/app_theme.dart';
import '../providers/lesson_provider.dart';

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
  bool isStudied = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<LessonProvider>().fetchDayRead(
        widget.quarterlyId,
        widget.lessonId,
        widget.dayId,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppTheme.navyBlue),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          widget.title,
          style: GoogleFonts.poppins(
            color: AppTheme.navyBlue,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ),
      body: Consumer<LessonProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(
              child: CircularProgressIndicator(color: AppTheme.navyBlue),
            );
          }

          final readData = provider.currentRead;
          if (readData == null) {
            return const Center(child: Text("No se pudo cargar la lección."));
          }

          final bibleVerses = readData['bible'] ?? [];
          final String content = readData['content'] ?? ""; //contenido con HTML

          return Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 20),
                      Text(
                        readData['title'] ?? "Estudio del día ${widget.dayId}",
                        style: GoogleFonts.poppins(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          height: 1.2,
                        ),
                      ),
                      const SizedBox(height: 15),
                      Text(
                        bibleVerses
                            .map((v) => "${v['name']} ${v['verse']}")
                            .join("; "),
                        style: const TextStyle(
                          color: AppTheme.navyBlue,
                          decoration: TextDecoration.underline,
                          fontSize: 16,
                          height: 1.4,
                        ),
                      ),
                      const SizedBox(height: 30),

                      Html(
                        data: content,
                        style: {
                          "body": Style(
                            fontSize: FontSize(18.0),
                            fontFamily: 'Poppins',
                            color: Colors.black87,
                            lineHeight: LineHeight(1.6),
                            margin: Margins.zero,
                            padding: HtmlPaddings.zero,
                          ),
                          "strong": Style(
                            fontWeight: FontWeight.bold,
                            color: AppTheme.navyBlue,
                          ),
                          "p": Style(margin: Margins.only(bottom: 10)),
                        },
                      ),
                      //const SizedBox(height: 30),
                    ],
                  ),
                ),
              ),
              _buildStudiedButton(),
            ],
          );
        },
      ),
    );
  }

  Widget _buildStudiedButton() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(25, 10, 25, 30),
      child: InkWell(
        onTap: () => setState(() => isStudied = !isStudied),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          width: double.infinity,
          height: 65,
          decoration: BoxDecoration(
            color: isStudied ? Colors.green : const Color(0xFF212121),
            borderRadius: BorderRadius.circular(25),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                isStudied ? "Completado" : "Marcar como estudiado",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 12),
              const Icon(
                Icons.check_circle_outline,
                color: Colors.white,
                size: 28,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

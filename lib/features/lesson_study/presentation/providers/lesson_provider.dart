import 'package:es_control/core/utils/date_formatter.dart';
import 'package:es_control/features/lesson_study/domain/use_cases/mark_day_as_read_usecase.dart';
import 'package:flutter/material.dart';
import '../../domain/entities/quarterly.dart';
import '../../domain/entities/lesson.dart';
import '../../domain/use_cases/get_day_read_usecase.dart';
import '../../domain/use_cases/get_quarterlies_usecase.dart';
import '../../domain/use_cases/get_lessons_usecase.dart';

class LessonProvider extends ChangeNotifier {
  final GetQuarterliesUseCase getQuarterliesUseCase;
  final GetLessonsUseCase getLessonsUseCase;
  final GetDayReadUseCase getDayReadUseCase;
  final MarkDayAsReadUseCase markDayAsReadUseCase;

  double _currentFontSize = 18.0;
  double get currentFontSize => _currentFontSize;

  void setFontSize(double size) {
    _currentFontSize = size;
    notifyListeners();
  }

  LessonProvider({
    required this.markDayAsReadUseCase,
    required this.getQuarterliesUseCase,
    required this.getLessonsUseCase,
    required this.getDayReadUseCase,
  });

  List<Quarterly> _quarterlies = [];
  List<Lesson> _lessons = [];
  final Map<String, Map<String, dynamic>> _dayReads = {};
  bool _isLoading = false;

  Quarterly? get currentQuarterly {
    if (_quarterlies.isEmpty) return null;
    try {
      return _quarterlies.firstWhere(
        (q) =>
            q.startDate != null &&
            q.endDate != null &&
            StudyDateHelper.isTodayInRecord(q.startDate!, q.endDate!),
      );
    } catch (e) {
      return null;
    }
  }

  Lesson? get currentLesson {
    if (_lessons.isEmpty) return null;
    try {
      return _lessons.firstWhere(
        (l) =>
            l.startDate != null &&
            l.endDate != null &&
            StudyDateHelper.isTodayInRecord(l.startDate!, l.endDate!),
      );
    } catch (e) {
      return null;
    }
  }

  List<Quarterly> get quarterlies => _quarterlies;
  List<Lesson> get lessons => _lessons;
  Map<String, Map<String, dynamic>> get dayReads => _dayReads;
  bool get isLoading => _isLoading;

  Future<void> fetchQuarterlies({String lang = "es"}) async {
    _isLoading = true;
    notifyListeners();
    try {
      _quarterlies = await getQuarterliesUseCase.execute(lang);
    } catch (e) {
      debugPrint("Error: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchLessons(String quarterlyId, {String lang = "es"}) async {
    _isLoading = true;
    _lessons = [];
    notifyListeners();
    try {
      _lessons = await getLessonsUseCase.execute(quarterlyId, lang);
    } catch (e) {
      debugPrint("Error: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchDayRead(
    String qId,
    String lId,
    String dId, {
    String lang = "es",
  }) async {
    if (_dayReads.containsKey(dId)) return;

    Future.microtask(() {
      _isLoading = true;
      notifyListeners();
    });

    try {
      final data = await getDayReadUseCase.execute(qId, lId, dId, lang);
      _dayReads[dId] = data;
    } catch (e) {
      debugPrint("Error: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> markDayAsRead(
    String token,
    String qId,
    String lId,
    String dId,
  ) async {
    try {
      await markDayAsReadUseCase.execute(token, qId, lId, dId);

      if (_dayReads.containsKey(dId)) {
        bool estadoActual = _dayReads[dId]!['isRead'] ?? false;
        _dayReads[dId]!['isRead'] = !estadoActual;
        notifyListeners();
      }
      return true;
    } catch (e) {
      debugPrint('Error: $e');
      return false;
    }
  }

  final Map<String, String> _answers = {};

  String getAnswer(String questionKey) {
    return _answers[questionKey] ?? "";
  }

  void saveAnswerTemporarily(String questionKey, String answer) {
    _answers[questionKey] = answer;
  }
}

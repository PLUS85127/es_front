import 'package:flutter/material.dart';
import '../../domain/entities/stats_entity.dart';
import '../../domain/use_cases/get_my_stats_usecase.dart';
import '../../../lesson_study/domain/entities/lesson.dart';
import '../../../lesson_study/domain/entities/quarterly.dart';

class StatsProvider extends ChangeNotifier {
  final GetMyStatsUseCase getMyStatsUseCase;

  StatsEntity? _currentStats;
  bool _isLoading = false;
  String? _errorMessage;

  StatsProvider({required this.getMyStatsUseCase});

  StatsEntity? get currentStats => _currentStats;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  //calcular progreso semanal
  double get weeklyProgressValue {
    if (_currentStats == null) return 0.0;
    return _currentStats!.weeklyCount / 7.0;
  }

  //transformar los datos
  double get quarterlyProgressValue {
    if (_currentStats == null) return 0.0;
    try {
      String cleanPercent = _currentStats!.quarterlyPercentage
          .replaceAll('%', '')
          .trim();
      return double.parse(cleanPercent) / 100.0;
    } catch (e) {
      return 0.0;
    }
  }

  Future<void> fetchMyStats(
    String token,
    String quarterlyId,
    String lessonId,
  ) async {
    if (isLoading) return;
    Future.microtask(() {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();
    });

    try {
      _currentStats = await getMyStatsUseCase.execute(
        token,
        quarterlyId,
        lessonId,
      );
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception', '');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  //el semalna especifica
  Future<void> loadCurrentWeekStats({
    required String? token,
    required Quarterly? currentQuarterly,
    required Lesson? currentLesson,
  }) async {
    if (token == null) {
      _errorMessage = "Usuario no encontrado";
      notifyListeners();
      return;
    }

    if (currentQuarterly == null || currentLesson == null) {
      _errorMessage = "No se pudo determinar la semana actual";
      notifyListeners();
      return;
    }

    await fetchMyStats(
      token,
      currentQuarterly.quarterlyId,
      currentLesson.lessonId,
    );
  }
}

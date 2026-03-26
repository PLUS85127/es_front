import 'package:flutter/material.dart';
import '../../domain/entities/quarterly.dart';
import '../../domain/entities/lesson.dart';
import '../../domain/repositories/lesson_repository.dart';

class LessonProvider extends ChangeNotifier {
  final LessonRepository repository;

  List<Quarterly> _quarterlies = [];
  List<Lesson> _lessons = [];
  Map<String, dynamic>? _currentRead;
  bool _isLoading = false;

  LessonProvider({required this.repository});

  List<Quarterly> get quarterlies => _quarterlies;
  List<Lesson> get lessons => _lessons;
  Map<String, dynamic>? get currentRead => _currentRead;
  bool get isLoading => _isLoading;

  // Cargar trimestres
  Future<void> fetchQuarterlies({String lang = "es"}) async {
    _isLoading = true;
    notifyListeners();
    try {
      _quarterlies = await repository.getQuarterlies(lang);
      //print("${_quarterlies.length}");
    } catch (e) {
      debugPrint("Error cargando trimestres: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Cargar lecciones de un trimestre
  Future<void> fetchLessons(String quarterlyId, {String lang = "es"}) async {
    _isLoading = true;
    _lessons = [];
    notifyListeners();
    try {
      _lessons = await repository.getLessons(quarterlyId, lang: lang);
      // print("Lecciones cargadas: ${_lessons.length}");
    } catch (e) {
      //print("$e");
      debugPrint("Error cargando lecciones: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  //cargar lectura de un día
  Future<void> fetchDayRead(
    String qId,
    String lId,
    String dId, {
    String lang = "es",
  }) async {
    _isLoading = true;
    _currentRead = null;
    notifyListeners();
    try {
      _currentRead = await repository.getDayRead(qId, lId, dId, lang: lang);
    } catch (e) {
      debugPrint("Error cargando lectura: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}

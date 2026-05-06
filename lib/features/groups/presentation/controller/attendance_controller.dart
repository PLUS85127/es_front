import 'package:flutter/material.dart';

class AttendanceController extends ChangeNotifier {
  final Map<String, bool> _attendanceChecks = {};
  final Map<String, int> _studyDays = {};
  int _visitsCounter = 0;

  Map<String, bool> get attendanceChecks => _attendanceChecks;
  Map<String, int> get studyDays => _studyDays;
  int get visitsCounter => _visitsCounter;

  //inicializar los datos de un usuario
  void initMember(String userId, {int initialDays = 0}) {
    _attendanceChecks.putIfAbsent(userId, () => false);
    _studyDays.putIfAbsent(userId, () => initialDays);
  }

  //modificar asistencia
  void toggleAttendance(String userId, bool value) {
    _attendanceChecks[userId] = value;
    notifyListeners();
  }

  //modificar días
  void incrementDays(String userId) {
    if ((_studyDays[userId] ?? 0) < 7) {
      _studyDays[userId] = (_studyDays[userId] ?? 0) + 1;
      notifyListeners();
    }
  }

  //modificar días
  void decrementDays(String userId) {
    if ((_studyDays[userId] ?? 0) > 0) {
      _studyDays[userId] = (_studyDays[userId] ?? 0) - 1;
      notifyListeners();
    }
  }

  //modificar visitas
  void updateVisits(int value) {
    _visitsCounter = value;
    notifyListeners();
  }
}

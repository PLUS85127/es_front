import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:es_control/core/theme/theme_extension.dart';
import 'package:es_control/features/groups/presentation/provider/group_provider.dart';
import 'package:es_control/features/authentication/presentation/provider/auth_provider.dart';
import 'package:es_control/features/lesson_study/presentation/providers/lesson_provider.dart';
import 'package:es_control/features/authentication/domain/entities/user_entity.dart';
import 'package:es_control/features/navigation/presentation/widgets/top_mode_toggle.dart';

import '../controller/attendance_controller.dart';
import '../widgets/director_groups_view.dart';
import '../widgets/leader_groups_view.dart';

class GroupsPage extends StatefulWidget {
  final bool isAdminMode;
  final ValueChanged<bool> onModeChanged;

  const GroupsPage({
    super.key,
    required this.isAdminMode,
    required this.onModeChanged,
  });

  @override
  State<GroupsPage> createState() => _GroupsPageState();
}

class _GroupsPageState extends State<GroupsPage> {
  final AttendanceController attendanceController = AttendanceController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final token = context.read<AuthProvider>().user?.token;
      if (token != null) {
        context.read<GroupProvider>().loadMyGroups(token);
      }
    });
  }

  @override
  void dispose() {
    attendanceController.dispose();
    super.dispose();
  }

  void _saveAttendance() async {
    final authProvider = context.read<AuthProvider>();
    final groupProvider = context.read<GroupProvider>();
    final lessonProvider = context.read<LessonProvider>();

    final token = authProvider.user?.token;
    final myGroups = groupProvider.myGroups;

    final currentQId = lessonProvider.currentQuarterly?.quarterlyId;
    final currentLId = lessonProvider.currentLesson?.lessonId;

    if (token == null || myGroups.isEmpty) {
      return;
    }

    if (currentQId == null || currentLId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No hay una lección activa en este momento.'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    final groupId = myGroups.first.id.toString();

    List<int> presentUserIds = [];
    attendanceController.attendanceChecks.forEach((userIdString, isPresent) {
      if (isPresent) {
        presentUserIds.add(int.parse(userIdString));
      }
    });

    List<Map<String, dynamic>> progressData = [];
    attendanceController.studyDays.forEach((userIdString, days) {
      progressData.add({
        'userId': int.parse(userIdString),
        'daysStudied': days,
      });
    });

    final success = await groupProvider.saveAttendance(
      token,
      groupId,
      currentQId,
      currentLId,
      presentUserIds,
      attendanceController.visitsCounter,
      progressData,
    );

    //mostrar los resultados
    //solo mensaje exitoso
    if (mounted) {
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('¡Progreso guardado con éxito!'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              groupProvider.errorMessage ?? 'Hubo un error al guardar',
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final groupProvider = context.watch<GroupProvider>();

    final role = authProvider.user?.role;
    final isDirector = role != UserRole.leader;
    final textColor = context.textColor;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Toggle
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: SizedBox(
                  width: 230,
                  child: TopModeToggle(
                    isAdminMode: widget.isAdminMode,
                    onModeChanged: widget.onModeChanged,
                  ),
                ),
              ),
            ),

            //vista separada
            Expanded(
              child: groupProvider.isLoading && groupProvider.myGroups.isEmpty
                  ? const Center(child: CircularProgressIndicator())
                  : groupProvider.myGroups.isEmpty
                  ? const Center(child: Text('No tienes grupos asignados'))
                  : isDirector
                  ? DirectorGroupsView(
                      provider: groupProvider,
                      textColor: textColor,
                    )
                  : LeaderGroupsView(
                      provider: groupProvider,
                      token: authProvider.user?.token ?? '',
                      textColor: textColor,
                      attendanceController: attendanceController,
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

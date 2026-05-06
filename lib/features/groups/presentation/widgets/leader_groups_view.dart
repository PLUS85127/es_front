import 'package:es_control/features/lesson_study/presentation/providers/lesson_provider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:es_control/core/theme/theme_extension.dart';
import 'package:provider/provider.dart';

import '../provider/group_provider.dart';
import '../controller/attendance_controller.dart';
import 'member_dashboard_card.dart';

class LeaderGroupsView extends StatefulWidget {
  final GroupProvider provider;
  final String token;
  final Color textColor;
  final AttendanceController attendanceController;

  const LeaderGroupsView({
    super.key,
    required this.provider,
    required this.token,
    required this.textColor,
    required this.attendanceController,
  });

  @override
  State<LeaderGroupsView> createState() => _LeaderGroupsViewState();
}

class _LeaderGroupsViewState extends State<LeaderGroupsView> {
  bool _membersLoaded = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (widget.provider.myGroups.isNotEmpty && !_membersLoaded) {
        final lessonProvider = Provider.of<LessonProvider>(
          context,
          listen: false,
        );
        final currentQuarterlyId =
            lessonProvider.currentQuarterly?.quarterlyId ?? "";
        final currentLessonId = lessonProvider.currentLesson?.lessonId ?? "";

        await widget.provider.loadGroupMembers(
          widget.token,
          widget.provider.myGroups.first.id.toString(),
          currentQuarterlyId,
          currentLessonId,
        );

        if (mounted) {
          final members = widget.provider.currentGroupMembers;
          for (var member in members) {
            widget.attendanceController.initMember(
              member.id,
              initialDays: member.studyDays,
            );
          }
          setState(() {
            _membersLoaded = true;
          });
        }
      }
    });
  }

  void _mostrarPanelAsistencia() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Todavia n realizado'),
        backgroundColor: Colors.red,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.provider.myGroups.isEmpty) return const SizedBox();

    final myGroup = widget.provider.myGroups.first;
    final members = widget.provider.currentGroupMembers;
    final primaryColor = Theme.of(context).primaryColor;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Eres administrador del grupo:",
                style: TextStyle(color: context.subTextColor, fontSize: 14),
              ),
              Text(
                myGroup.name,
                style: GoogleFonts.poppins(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: widget.textColor,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 15),

        //lista de miembros solo lectura
        Expanded(
          child: widget.provider.isLoading || !_membersLoaded
              ? const Center(child: CircularProgressIndicator())
              : members.isEmpty
              ? const Center(child: Text("Aún no hay hermanos en este grupo"))
              : ListenableBuilder(
                  listenable: widget.attendanceController,
                  builder: (context, _) {
                    return ListView.builder(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 10,
                      ),
                      itemCount: members.length,
                      itemBuilder: (context, index) {
                        final member = members[index];
                        final String memberId = member.id;

                        return MemberDashboardCard(
                          memberName: '${member.firstName} ${member.lastName}',
                          //los días del controlador (solo lectura)
                          studyDays:
                              widget.attendanceController.studyDays[memberId] ??
                              0,
                        );
                      },
                    );
                  },
                ),
        ),

        //boton registrar asistencia
        Container(
          width: double.infinity,
          height: 60,
          margin: const EdgeInsets.only(
            top: 10,
            bottom: 20,
            left: 20,
            right: 20,
          ),
          child: ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: context.isDark
                  ? context.cardColor
                  : Theme.of(context).primaryColor,
              foregroundColor: context.isDark
                  ? context.textColor
                  : Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
              elevation: 5,
            ),
            onPressed: _mostrarPanelAsistencia,
            icon: const Icon(Icons.checklist, size: 28),
            label: Text(
              "REGISTRAR ASISTENCIA",
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                letterSpacing: 1.2,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

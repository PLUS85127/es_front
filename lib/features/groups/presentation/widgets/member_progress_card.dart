import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/theme_extension.dart';

class MemberProgressCard extends StatelessWidget {
  final String memberName;
  final bool isPresent;
  final int studyDays;
  final ValueChanged<bool> onAttendanceChanged;
  final VoidCallback onIncrementDays;
  final VoidCallback onDecrementDays;

  const MemberProgressCard({
    super.key,
    required this.memberName,
    required this.isPresent,
    required this.studyDays,
    required this.onAttendanceChanged,
    required this.onIncrementDays,
    required this.onDecrementDays,
  });

  @override
  Widget build(BuildContext context) {
    final subTextColor = context.subTextColor;
    final primaryColor = Theme.of(context).primaryColor;

    //nombre y asistencia
    return Card(
      margin: const EdgeInsets.only(bottom: 5),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    memberName,
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Row(
                  children: [
                    Text(
                      'Asistio',
                      style: TextStyle(color: subTextColor, fontSize: 13),
                    ),
                    Checkbox(
                      value: isPresent,
                      activeColor: primaryColor,
                      onChanged: (val) {
                        if (val != null) {
                          onAttendanceChanged(val);
                        }
                      },
                    ),
                  ],
                ),
              ],
            ),

            const Divider(),

            //controles y dias
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Días estudiados',
                  style: TextStyle(
                    color: subTextColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(
                        Icons.remove_circle_outlined,
                        color: Colors.redAccent,
                      ),
                      onPressed: onDecrementDays,
                      constraints: const BoxConstraints(),
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                    ),

                    //Texto de dias
                    Text(
                      "$studyDays/7",
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: primaryColor,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.add_circle_outlined,
                        color: Colors.greenAccent,
                      ),
                      onPressed: onIncrementDays,
                      constraints: const BoxConstraints(),
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 10),

            //rayitas de progreso (las rayitas)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(7, (index) {
                bool isStudiend = index < studyDays;
                return Expanded(
                  child: Container(
                    height: 8,
                    margin: const EdgeInsets.symmetric(horizontal: 2),
                    decoration: BoxDecoration(
                      color: isStudiend
                          ? primaryColor
                          : primaryColor.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}

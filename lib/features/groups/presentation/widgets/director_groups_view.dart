import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../provider/group_provider.dart';
import 'group_card.dart';

class DirectorGroupsView extends StatelessWidget {
  final GroupProvider provider;
  final Color textColor;

  const DirectorGroupsView({
    super.key,
    required this.provider,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            "Grupos Activos",
            style: GoogleFonts.poppins(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
        ),
        const SizedBox(height: 10),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            itemCount: provider.myGroups.length,
            itemBuilder: (context, index) {
              return GroupCard(group: provider.myGroups[index], onTap: () {});
            },
          ),
        ),
      ],
    );
  }
}

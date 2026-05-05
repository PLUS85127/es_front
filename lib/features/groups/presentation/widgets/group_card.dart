import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:es_control/core/theme/theme_extension.dart';
import '../../domain/entities/group_entity.dart';

class GroupCard extends StatelessWidget {
  final GroupEntity group;
  final VoidCallback onTap;

  const GroupCard({super.key, required this.group, required this.onTap});

  void _copyClipboard(BuildContext context) {
    Clipboard.setData(ClipboardData(text: group.code));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Código "${group.code}" copiado'),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(15),
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    group.name,
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  const Icon(Icons.arrow_forward_ios, size: 16),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Código: ${group.code}",
                    style: TextStyle(
                      color: context.subTextColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.copy, size: 20),
                    onPressed: () => _copyClipboard(context),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

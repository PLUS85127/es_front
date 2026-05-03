import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
// IMPORTANTE: Tus recursos
import 'package:es_control/core/theme/theme_extension.dart';

class TopModeToggle extends StatelessWidget {
  final bool isAdminMode;
  final ValueChanged<bool> onModeChanged;

  const TopModeToggle({
    super.key,
    required this.isAdminMode,
    required this.onModeChanged,
  });

  @override
  Widget build(BuildContext context) {
    // Usando tu recurso context.isDark
    final isDark = context.isDark;

    return Container(
      height: 45,
      decoration: BoxDecoration(
        color: Theme.of(context).canvasColor,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.3 : 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: _ToggleItem(
              label: "Mi Espacio",
              isActive: !isAdminMode,
              onTap: () => onModeChanged(false),
            ),
          ),
          Expanded(
            child: _ToggleItem(
              label: "Administración",
              isActive: isAdminMode,
              onTap: () => onModeChanged(true),
            ),
          ),
        ],
      ),
    );
  }
}

class _ToggleItem extends StatelessWidget {
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _ToggleItem({
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: isActive ? context.iconColor : Colors.transparent,
          borderRadius: BorderRadius.circular(25),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            fontSize: 14,
            color: isActive
                ? (context.isDark ? Colors.black : Colors.white)
                : Theme.of(context).hintColor,
          ),
        ),
      ),
    );
  }
}

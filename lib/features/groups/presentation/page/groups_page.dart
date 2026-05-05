import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:es_control/core/theme/theme_extension.dart';
import 'package:es_control/features/groups/presentation/provider/group_provider.dart';
import 'package:es_control/features/authentication/presentation/provider/auth_provider.dart';
import 'package:es_control/features/navigation/presentation/widgets/top_mode_toggle.dart';
import '../widgets/group_card.dart'; // Importa tu pieza de tarjeta

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
  Widget build(BuildContext context) {
    final groupProvider = context.watch<GroupProvider>();
    final textColor = context.textColor;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
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

            Expanded(
              child: groupProvider.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ListView.builder(
                      padding: const EdgeInsets.all(20),
                      itemCount: groupProvider.myGroups.length,
                      itemBuilder: (context, index) {
                        return GroupCard(
                          group: groupProvider.myGroups[index],
                          onTap: () {},
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

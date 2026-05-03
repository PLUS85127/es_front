import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:es_control/core/theme/theme_extension.dart';
import 'package:es_control/features/authentication/presentation/provider/auth_provider.dart';
import '../provider/group_provider.dart';

class CreateGroupModal extends StatefulWidget {
  const CreateGroupModal({super.key});

  @override
  State<CreateGroupModal> createState() => _CreateGroupModalState();
}

class _CreateGroupModalState extends State<CreateGroupModal> {
  final _nameController = TextEditingController();
  String? _createdGroupCode; //código

  void _handleCreate() async {
    if (_nameController.text.trim().isEmpty) return;

    final auth = context.read<AuthProvider>();
    final groupProv = context.read<GroupProvider>();

    if (auth.user != null) {
      final code = await groupProv.createNewGroup(
        auth.user!.token,
        _nameController.text.trim(),
        int.parse(auth.user!.id),
      );

      if (code != null) {
        setState(() => _createdGroupCode = code);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      //el modal suba cuando sale el teclado en el celular
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        padding: const EdgeInsets.all(25),
        decoration: BoxDecoration(
          color: Theme.of(context).canvasColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
        ),
        child: _createdGroupCode == null ? _buildForm() : _buildSuccess(),
      ),
    );
  }

  //formulario
  Widget _buildForm() {
    final groupProv = context.watch<GroupProvider>();

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 50,
          height: 5,
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        const SizedBox(height: 20),
        Text(
          "Crear Nuevo Grupo",
          style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        Text(
          "Dale un nombre a tu clase de Escuela Sabática",
          textAlign: TextAlign.center,
          style: TextStyle(color: context.subTextColor),
        ),
        const SizedBox(height: 25),
        TextField(
          controller: _nameController,
          decoration: InputDecoration(
            hintText: "Ej. Clase de Jóvenes 'Maranatha'",
            filled: true,
            fillColor: context.isDark ? Colors.white10 : Colors.grey[100],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide.none,
            ),
          ),
        ),
        const SizedBox(height: 25),
        SizedBox(
          width: double.infinity,
          height: 55,
          child: ElevatedButton(
            onPressed: groupProv.isLoading ? null : _handleCreate,
            style: ElevatedButton.styleFrom(
              backgroundColor: context.iconColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
            ),
            child: groupProv.isLoading
                ? const CircularProgressIndicator(color: Colors.white)
                : const Text(
                    "Generar Grupo y Código",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
          ),
        ),
      ],
    );
  }

  Widget _buildSuccess() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(Icons.check_circle, color: Colors.green, size: 80),
        const SizedBox(height: 15),
        Text(
          "¡Grupo Creado!",
          style: GoogleFonts.poppins(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        Text(
          "Comparte este código con tus alumnos para que se unan:",
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 25),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
          decoration: BoxDecoration(
            color: context.iconColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: context.iconColor, width: 2),
          ),
          child: Text(
            _createdGroupCode!,
            style: GoogleFonts.poppins(
              fontSize: 35,
              fontWeight: FontWeight.bold,
              letterSpacing: 5,
              color: context.iconColor,
            ),
          ),
        ),
        const SizedBox(height: 30),
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Cerrar"),
        ),
      ],
    );
  }
}

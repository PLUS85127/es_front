import 'package:flutter/material.dart';
import '../../domain/use_cases/create_church_usecase.dart';

class ChurchProvider extends ChangeNotifier {
  final CreateChurchUseCase createChurchUseCase;

  ChurchProvider({required this.createChurchUseCase});

  Future<bool> createNewChurch(
    String token,
    String name,
    String address,
  ) async {
    notifyListeners();
    final success = await createChurchUseCase.execute(token, name, address);
    notifyListeners();
    return success;
  }
}

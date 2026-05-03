import 'package:flutter/material.dart';
import '../../domain/use_cases/create_church_usecase.dart';

class ChurchProvider extends ChangeNotifier {
  final CreateChurchUseCase createChurchUseCase;

  ChurchProvider({required this.createChurchUseCase});

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<bool> createNewChurch(
    String token,
    String name,
    String address,
  ) async {
    _isLoading = true;
    notifyListeners();
    final success = await createChurchUseCase.execute(token, name, address);
    _isLoading = false;
    notifyListeners();
    return success;
  }
}

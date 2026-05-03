import '../repositories/church_repository.dart';

class CreateChurchUseCase {
  final ChurchRepository repository;

  CreateChurchUseCase(this.repository);

  Future<bool> call(String token, String name, String address) async {
    return await repository.createChurch(token, name, address);
  }
}

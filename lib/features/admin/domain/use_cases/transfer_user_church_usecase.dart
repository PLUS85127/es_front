import '../repositories/admin_repository.dart';

class TransferUserChurchUseCase {
  final AdminRepository adminRepository;

  TransferUserChurchUseCase(this.adminRepository);

  Future<bool> execute(String token, int targetUserId, int newChurchId) async {
    return await adminRepository.transferUserChurch(
      token,
      targetUserId,
      newChurchId,
    );
  }
}

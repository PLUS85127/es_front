import '../../domain/repositories/church_repository.dart';
import '../datasources/church_remote_data_source.dart';

class ChurchRepositoryImpl implements ChurchRepository {
  final ChurchRemoteDataSource remoteDataSource;

  ChurchRepositoryImpl({required this.remoteDataSource});

  @override
  Future<bool> createChurch(String token, String name, String address) async {
    return await remoteDataSource.createChurch(token, name, address);
  }
}

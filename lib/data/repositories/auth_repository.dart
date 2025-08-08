// lib/data/repositories/auth_repository_impl.dart
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_datasource.dart';

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl(this.remoteDataSource);
  final AuthRemoteDataSource remoteDataSource;

  @override
  Future<UserEntity> login(String email, String password) async {
    return remoteDataSource.login(email, password);
  }

  @override
  Future<UserEntity> signUp(String email, String password) async {
    return remoteDataSource.signUp(email, password);
  }

  @override
  Future<void> logout() async {
    await remoteDataSource.logout();
  }

  @override
  Future<void> resetPassword(String email) async {
    await remoteDataSource.resetPassword(email);
  }

  @override
  Future<void> deleteAccount(String password) async {
    await remoteDataSource.deleteAccount(password);
  }

  @override
  Future<void> changePassword(
    String currentPassword,
    String newPassword,
  ) async {
    await remoteDataSource.changePassword(currentPassword, newPassword);
  }

  @override
  UserEntity? getCurrentUser() {
    return remoteDataSource.getCurrentUser();
  }
}

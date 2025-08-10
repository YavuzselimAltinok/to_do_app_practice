// lib/data/repositories/auth_repository_impl.dart
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_datasource.dart';

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl(this.remoteDataSource);
  final AuthRemoteDataSource remoteDataSource;

  @override
  Future<UserEntity> login(String email, String password) async {
    try {
      return await remoteDataSource.login(email, password);
    } catch (e) {
      // Handle error
      rethrow;
    }
  }

  @override
  Future<UserEntity> signUp(String email, String password) async {
    try {
      return await remoteDataSource.signUp(email, password);
    } catch (e) {
      // Handle error
      rethrow;
    }
  }

  @override
  Future<void> logout() async {
    try {
      await remoteDataSource.logout();
    } catch (e) {
      // Handle error
      rethrow;
    }
  }

  @override
  Future<void> resetPassword(String email) async {
    try {
      await remoteDataSource.resetPassword(email);
    } catch (e) {
      // Handle error
      rethrow;
    }
  }

  @override
  Future<void> deleteAccount(String password) async {
    try {
      await remoteDataSource.deleteAccount(password);
    } catch (e) {
      // Handle error
      rethrow;
    }
  }

  @override
  Future<void> changePassword(
    String currentPassword,
    String newPassword,
  ) async {
    try {
      await remoteDataSource.changePassword(currentPassword, newPassword);
    } catch (e) {
      // Handle error
      rethrow;
    }
  }

  @override
  UserEntity? getCurrentUser() {
    return remoteDataSource.getCurrentUser();
  }
}

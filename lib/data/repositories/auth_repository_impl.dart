// lib/data/repositories/auth_repository_impl.dart
import 'package:state_management_practice/data/models/user_model.dart';
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
      final UserModel user = await remoteDataSource.signUp(email, password);
      await remoteDataSource.saveUser(UserModel.fromEntity(user));
      print("User signed up: ${user.email}");
      return user;
    } catch (e) {
      // Handle error
      rethrow;
    }
  }

  @override
  Future<void> saveUser(UserEntity user) async {
    try {
      await remoteDataSource.saveUser(UserModel.fromEntity(user));
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
      final UserModel? user = remoteDataSource.getCurrentUser();
      await deleteUser(user!.id);
      await remoteDataSource.deleteAccount(password);
    } catch (e) {
      // Handle error
      rethrow;
    }
  }

  @override
  Future<void> deleteUser(String userId) async {
    try {
      await remoteDataSource.deleteUser(userId);
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

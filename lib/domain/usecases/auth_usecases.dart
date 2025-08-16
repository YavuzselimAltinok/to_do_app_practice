import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';

class AuthUseCases {
  AuthUseCases(this.repository);
  final AuthRepository repository;

  Future<UserEntity> login(String email, String password) async {
    try {
      return await repository.login(email, password);
    } catch (e) {
      // Handle error
      rethrow;
    }
  }

  Future<UserEntity> signUp(String email, String password) async {
    try {
      return await repository.signUp(email, password);
    } catch (e) {
      // Handle error
      rethrow;
    }
  }

  Future<void> saveUser(UserEntity user) async {
    await repository.saveUser(user);
  }

  Future<void> logout() async {
    await repository.logout();
  }

  Future<void> resetPassword(String email) async {
    try {
      await repository.resetPassword(email);
    } catch (e) {
      // Handle error
      rethrow;
    }
  }

  Future<void> deleteAccount(String password) async {
    try {
      await repository.deleteAccount(password);
    } catch (e) {
      // Handle error
      rethrow;
    }
  }

  Future<void> deleteUser(String userId) async {
    await repository.deleteUser(userId);
  }

  Future<void> changePassword(
    String currentPassword,
    String newPassword,
  ) async {
    try {
      await repository.changePassword(currentPassword, newPassword);
      if (currentPassword == newPassword) {
        throw Exception('New password cannot be the same as current password');
      }
    } catch (e) {
      // Handle error
      rethrow;
    }
  }

  UserEntity? getCurrentUser() {
    return repository.getCurrentUser();
  }
}

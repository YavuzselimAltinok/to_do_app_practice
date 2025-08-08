import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';

class AuthUseCases {
  AuthUseCases(this.repository);
  final AuthRepository repository;

  Future<UserEntity> login(String email, String password) async {
    if (email.isEmpty) {
      throw Exception('Email is required');
    }
    if (password.isEmpty) {
      throw Exception('Password is required');
    }
    return repository.login(email, password);
  }

  Future<UserEntity> signUp(String email, String password) async {
    if (email.isEmpty) {
      throw Exception('Email is required');
    }
    if (password.isEmpty) {
      throw Exception('Password is required');
    }
    if (password.length < 6) {
      throw Exception('Password must be at least 6 characters');
    }
    return repository.signUp(email, password);
  }

  Future<void> logout() async {
    await repository.logout();
  }

  Future<void> resetPassword(String email) async {
    if (email.isEmpty) {
      throw Exception('Email is required');
    }
    await repository.resetPassword(email);
  }

  Future<void> deleteAccount(String password) async {
    if (password.isEmpty) {
      throw Exception('Password is required');
    }
    await repository.deleteAccount(password);
  }

  Future<void> changePassword(
    String currentPassword,
    String newPassword,
  ) async {
    if (currentPassword.isEmpty) {
      throw Exception('Current password is required');
    }
    if (newPassword.isEmpty) {
      throw Exception('New password is required');
    }
    if (newPassword.length < 6) {
      throw Exception('New password must be at least 6 characters');
    }
    await repository.changePassword(currentPassword, newPassword);
  }
}

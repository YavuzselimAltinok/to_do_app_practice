import '../entities/user_entity.dart';

abstract class AuthRepository {
  // Basic auth operations
  Future<UserEntity> login(String email, String password);
  Future<UserEntity> signUp(String email, String password);
  Future<void> logout();
  Future<void> resetPassword(String email);
  Future<void> deleteAccount(String password);
  Future<void> changePassword(String currentPassword, String newPassword);

  // User state
  UserEntity? getCurrentUser();
}

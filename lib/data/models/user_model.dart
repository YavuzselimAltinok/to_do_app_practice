import 'package:firebase_auth/firebase_auth.dart';
import '../../domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  const UserModel({
    required super.id,
    required super.email,
    required super.isEmailVerified,
  });

  // Convert from JSON
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      email: json['email'],
      isEmailVerified: json['isEmailVerified'],
    );
  }

  // Convert from Firebase User to our UserModel
  factory UserModel.fromFirebaseUser(User user) {
    return UserModel(
      id: user.uid,
      email: user.email!,
      isEmailVerified: user.emailVerified,
    );
  }

  // Convert to JSON (if needed for local storage)
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'email': email,
      'isEmailVerified': isEmailVerified,
    };
  }
}

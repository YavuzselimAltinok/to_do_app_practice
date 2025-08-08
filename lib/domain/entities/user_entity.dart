class UserEntity {
  const UserEntity({
    required this.id,
    required this.email,
    required this.isEmailVerified,
  });
  final String id;
  final String email;
  final bool isEmailVerified;
}

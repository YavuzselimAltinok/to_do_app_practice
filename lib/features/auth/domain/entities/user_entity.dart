class UserEntity {
  //TODO: add ID list of tasks and create task ID's via firebase
  const UserEntity({required this.id, required this.email});
  final String id;
  final String email;

  set value(UserEntity? value) {}
}

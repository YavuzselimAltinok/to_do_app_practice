import 'package:state_management_practice/core/usecase/usecase.dart';
import 'package:state_management_practice/features/auth/domain/repositories/auth_repository.dart';

class DeleteUserParams {
  DeleteUserParams({required this.userId});

  final String userId;
}

class DeleteUserUseCase extends UseCase<void, DeleteUserParams> {
  DeleteUserUseCase(this.authRepository);

  final AuthRepository authRepository;

  @override
  Future<void> call(DeleteUserParams params) {
    return authRepository.deleteUser(params.userId);
  }
}

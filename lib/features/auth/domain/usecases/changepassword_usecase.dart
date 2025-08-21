import 'package:state_management_practice/core/usecase/usecase.dart';
import 'package:state_management_practice/features/auth/domain/repositories/auth_repository.dart';

class ChangePasswordParams {
  ChangePasswordParams({required this.oldPassword, required this.newPassword});

  final String oldPassword;
  final String newPassword;
}

class ChangePasswordUseCase extends UseCase<void, ChangePasswordParams> {
  ChangePasswordUseCase(this.authRepository);

  final AuthRepository authRepository;

  @override
  Future<void> call(ChangePasswordParams params) {
    return authRepository.changePassword(
      params.oldPassword,
      params.newPassword,
    );
  }
}

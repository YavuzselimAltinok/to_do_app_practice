import 'package:state_management_practice/core/usecase/usecase.dart';
import 'package:state_management_practice/features/auth/domain/repositories/auth_repository.dart';

class ResetPasswordParams {
  ResetPasswordParams({required this.email});

  final String email;
}

class ResetPasswordUseCase extends UseCase<void, ResetPasswordParams> {
  ResetPasswordUseCase(this.authRepository);

  final AuthRepository authRepository;

  @override
  Future<void> call(ResetPasswordParams params) {
    return authRepository.resetPassword(params.email);
  }
}

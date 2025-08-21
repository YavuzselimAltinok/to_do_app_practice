import 'package:state_management_practice/core/usecase/usecase.dart';
import 'package:state_management_practice/features/auth/domain/entities/user_entity.dart';
import 'package:state_management_practice/features/auth/domain/repositories/auth_repository.dart';

class SignUpParams {
  SignUpParams({required this.email, required this.password});

  final String email;
  final String password;
}

class SignUpUseCase extends UseCase<UserEntity, SignUpParams> {
  SignUpUseCase(this.authRepository);

  final AuthRepository authRepository;

  @override
  Future<UserEntity> call(SignUpParams params) {
    return authRepository.signUp(params.email, params.password);
  }
}

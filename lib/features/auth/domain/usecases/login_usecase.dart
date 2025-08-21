import 'package:state_management_practice/core/usecase/usecase.dart';
import 'package:state_management_practice/features/auth/domain/entities/user_entity.dart';
import 'package:state_management_practice/features/auth/domain/repositories/auth_repository.dart';

class LoginParams {
  LoginParams({required this.email, required this.password});
  final String email;
  final String password;
}

class LoginUseCase extends UseCase<UserEntity, LoginParams> {
  LoginUseCase(this.authRepository);

  final AuthRepository authRepository;

  @override
  Future<UserEntity> call(LoginParams params) {
    return authRepository.login(params.email, params.password);
  }
}

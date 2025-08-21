import 'package:state_management_practice/core/usecase/usecase.dart';
import 'package:state_management_practice/features/auth/domain/repositories/auth_repository.dart';

class LogoutUseCase extends UseCase<void, NoParams> {
  LogoutUseCase(this.authRepository);

  final AuthRepository authRepository;

  @override
  Future<void> call(NoParams params) {
    return authRepository.logout();
  }
}

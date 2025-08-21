import 'package:state_management_practice/core/usecase/usecase.dart';
import 'package:state_management_practice/features/auth/domain/entities/user_entity.dart';
import 'package:state_management_practice/features/auth/domain/repositories/auth_repository.dart';

class GetCurrentUserUseCase extends UseCase<UserEntity?, NoParams> {
  GetCurrentUserUseCase(this.authRepository);

  final AuthRepository authRepository;

  @override
  Future<UserEntity?> call(NoParams params) {
    return Future.value(authRepository.getCurrentUser());
  }
}

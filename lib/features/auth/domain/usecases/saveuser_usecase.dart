import 'package:state_management_practice/core/usecase/usecase.dart';
import 'package:state_management_practice/features/auth/domain/entities/user_entity.dart';
import 'package:state_management_practice/features/auth/domain/repositories/auth_repository.dart';

class SaveUserParams {
  SaveUserParams({required this.userEntity});

  final UserEntity userEntity;
}

class SaveUserUseCase extends UseCase<void, SaveUserParams> {
  SaveUserUseCase(this.authRepository);

  final AuthRepository authRepository;

  @override
  Future<void> call(SaveUserParams params) {
    return authRepository.saveUser(params.userEntity);
  }
}

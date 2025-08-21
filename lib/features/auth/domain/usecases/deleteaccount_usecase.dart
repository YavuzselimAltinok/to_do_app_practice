import 'package:state_management_practice/core/usecase/usecase.dart';
import 'package:state_management_practice/features/auth/domain/repositories/auth_repository.dart';

class DeleteAccountParams {
  DeleteAccountParams({required this.userId});

  final String userId;
}

class DeleteAccountUseCase extends UseCase<void, DeleteAccountParams> {
  DeleteAccountUseCase(this.authRepository);

  final AuthRepository authRepository;

  @override
  Future<void> call(DeleteAccountParams params) {
    return authRepository.deleteAccount(params.userId);
  }
}

import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';

class LoginUseCase {
  final AuthRepository repository;

  LoginUseCase(this.repository);

  Future<UserEntity> call(String emailOrEmployeeId, String password) {
    return repository.login(emailOrEmployeeId, password);
  }
}

import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';

class SetPasswordUseCase {
  final AuthRepository repository;

  SetPasswordUseCase(this.repository);

  Future<UserEntity> call(String email, String password, String? token) {
    return repository.setPassword(email, password, token);
  }
}

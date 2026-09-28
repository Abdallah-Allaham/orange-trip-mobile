import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';

class CheckEligibilityUseCase {
  final AuthRepository repository;

  CheckEligibilityUseCase(this.repository);

  Future<EligibilityEntity> call(String email) {
    return repository.checkEligibility(email);
  }
}

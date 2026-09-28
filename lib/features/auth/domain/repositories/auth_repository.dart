import '../entities/user_entity.dart';

abstract class AuthRepository {
  Future<UserEntity> login(String emailOrEmployeeId, String password);
  Future<EligibilityEntity> checkEligibility(String email);
  Future<UserEntity> setPassword(String email, String password, String? token);
  Future<UserEntity?> getCachedUser();
  Future<void> logout();
  Future<bool> isBiometricsEnabled();
  Future<void> setBiometricsEnabled(bool enabled);
}

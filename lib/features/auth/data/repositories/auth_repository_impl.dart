import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_local_data_source.dart';
import '../datasources/auth_remote_data_source.dart';
import '../models/user_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;

  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<UserEntity> login(String emailOrEmployeeId, String password) async {
    final user = await remoteDataSource.login(emailOrEmployeeId, password);
    await localDataSource.cacheUser(user);
    return user;
  }

  @override
  Future<EligibilityEntity> checkEligibility(String email) async {
    return await remoteDataSource.checkEligibility(email);
  }

  @override
  Future<UserEntity> setPassword(String email, String password, String? token) async {
    final user = await remoteDataSource.setPassword(email, password, token);
    await localDataSource.cacheUser(user);
    return user;
  }

  @override
  Future<UserEntity?> getCachedUser() async {
    return await localDataSource.getCachedUser();
  }

  @override
  Future<void> logout() async {
    await localDataSource.clearUser();
  }

  @override
  Future<bool> isBiometricsEnabled() async {
    return await localDataSource.isBiometricsEnabled();
  }

  @override
  Future<void> setBiometricsEnabled(bool enabled) async {
    await localDataSource.setBiometricsEnabled(enabled);
    if (enabled) {
      final current = await localDataSource.getCachedUser();
      if (current != null) {
        await localDataSource.cacheBiometricUser(current);
      }
    }
  }

  @override
  Future<UserEntity?> getBiometricUser() async {
    return await localDataSource.getBiometricUser();
  }

  @override
  Future<void> cacheUser(UserEntity user) async {
    final model = UserModel(
      userId: user.userId,
      fullName: user.fullName,
      email: user.email,
      employeeId: user.employeeId,
      phoneNumber: user.phoneNumber,
      role: user.role,
      assignedGroup: user.assignedGroup,
      assignedBus: user.assignedBus,
      completionScore: user.completionScore,
      token: user.token,
      dataNoticeAccepted: user.dataNoticeAccepted,
      mediaConsentGranted: user.mediaConsentGranted,
    );
    await localDataSource.cacheUser(model);
    final hasBiometrics = await localDataSource.isBiometricsEnabled();
    if (hasBiometrics) {
      await localDataSource.cacheBiometricUser(model);
    }
  }
}

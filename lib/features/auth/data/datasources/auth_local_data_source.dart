import '../../../../core/storage/secure_storage_service.dart';
import '../models/user_model.dart';

abstract class AuthLocalDataSource {
  Future<void> cacheUser(UserModel user);
  Future<UserModel?> getCachedUser();
  Future<void> clearUser();
  Future<bool> isBiometricsEnabled();
  Future<void> setBiometricsEnabled(bool enabled);
  Future<void> cacheBiometricUser(UserModel user);
  Future<UserModel?> getBiometricUser();
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final SecureStorageService storageService;

  AuthLocalDataSourceImpl({required this.storageService});

  @override
  Future<void> cacheUser(UserModel user) async {
    await storageService.saveToken(user.token);
    await storageService.saveUserData(user.toJson());
  }

  @override
  Future<UserModel?> getCachedUser() async {
    final token = await storageService.getToken();
    final data = await storageService.getUserData();
    if (token != null && token.isNotEmpty && data != null) {
      data['token'] = token;
      return UserModel.fromJson(data);
    }
    return null;
  }

  @override
  Future<void> clearUser() async {
    await storageService.clearSession();
  }

  @override
  Future<bool> isBiometricsEnabled() async {
    return await storageService.isBiometricsEnabled();
  }

  @override
  Future<void> setBiometricsEnabled(bool enabled) async {
    await storageService.setBiometricsEnabled(enabled);
  }

  @override
  Future<void> cacheBiometricUser(UserModel user) async {
    await storageService.saveBiometricSession(user.token, user.toJson());
  }

  @override
  Future<UserModel?> getBiometricUser() async {
    final data = await storageService.getBiometricSession();
    if (data != null) {
      return UserModel.fromJson(data);
    }
    return null;
  }
}

import 'package:dio/dio.dart';
import '../../../../core/constants/api_constants.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/network/api_client.dart';
import '../models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel> login(String emailOrEmployeeId, String password);
  Future<EligibilityModel> checkEligibility(String email);
  Future<UserModel> setPassword(String email, String password, String? token);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final ApiClient apiClient;

  AuthRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<UserModel> login(String emailOrEmployeeId, String password) async {
    try {
      final response = await apiClient.dio.post(
        ApiConstants.login,
        data: {
          'emailOrEmployeeId': emailOrEmployeeId.trim(),
          'password': password,
        },
      );

      if (response.statusCode == 200 && response.data != null) {
        return UserModel.fromJson(response.data as Map<String, dynamic>);
      } else {
        throw ServerException(
          message: response.data?['message'] ?? 'Login failed. Invalid credentials.',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      final msg = e.response?.data is Map && e.response?.data['message'] != null
          ? e.response!.data['message']
          : e.message ?? 'Server error during login.';
      throw ServerException(
        message: msg,
        statusCode: e.response?.statusCode,
      );
    }
  }

  @override
  Future<EligibilityModel> checkEligibility(String email) async {
    try {
      final response = await apiClient.dio.get(
        ApiConstants.checkEligibility,
        queryParameters: {'email': email.trim()},
      );

      if (response.statusCode == 200 && response.data != null) {
        return EligibilityModel.fromJson(response.data as Map<String, dynamic>);
      } else {
        throw ServerException(
          message: response.data?['message'] ?? 'This email is not registered for the trip.',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      final msg = e.response?.data is Map && e.response?.data['message'] != null
          ? e.response!.data['message']
          : 'Corporate email is not on the confirmed trip list.';
      throw ServerException(
        message: msg,
        statusCode: e.response?.statusCode,
      );
    }
  }

  @override
  Future<UserModel> setPassword(String email, String password, String? token) async {
    try {
      final response = await apiClient.dio.post(
        ApiConstants.setPassword,
        data: {
          'email': email.trim(),
          'password': password,
          if (token != null && token.isNotEmpty) 'token': token.trim(),
        },
      );

      if (response.statusCode == 200 && response.data != null) {
        return UserModel.fromJson(response.data as Map<String, dynamic>);
      } else {
        throw ServerException(
          message: response.data?['message'] ?? 'Failed to set password.',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      final msg = e.response?.data is Map && e.response?.data['message'] != null
          ? e.response!.data['message']
          : 'Failed to set password. Ensure link/token is valid.';
      throw ServerException(
        message: msg,
        statusCode: e.response?.statusCode,
      );
    }
  }
}

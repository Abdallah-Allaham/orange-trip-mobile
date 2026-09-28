import 'package:dio/dio.dart';
import '../constants/api_constants.dart';
import '../storage/secure_storage_service.dart';
import 'auth_interceptor.dart';

class ApiClient {
  late final Dio dio;
  final SecureStorageService storageService;

  ApiClient({required this.storageService}) {
    dio = Dio(
      BaseOptions(
        baseUrl: ApiConstants.activeBaseUrl,
        connectTimeout: ApiConstants.connectTimeout,
        receiveTimeout: ApiConstants.receiveTimeout,
      ),
    );

    dio.interceptors.add(AuthInterceptor(storageService));

    // Initialize with custom URL if saved in secure storage
    _loadCustomUrl();
  }

  Future<void> _loadCustomUrl() async {
    final customUrl = await storageService.getCustomBaseUrl();
    if (customUrl != null && customUrl.isNotEmpty) {
      dio.options.baseUrl = customUrl;
      ApiConstants.activeBaseUrl = customUrl;
    }
  }

  void updateBaseUrl(String newUrl) {
    dio.options.baseUrl = newUrl;
    ApiConstants.activeBaseUrl = newUrl;
    storageService.setCustomBaseUrl(newUrl);
  }
}

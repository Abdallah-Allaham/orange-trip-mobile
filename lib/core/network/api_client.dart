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

  bool _isSecureOrLocalUrl(String url) {
    final trimmed = url.trim().toLowerCase();
    if (trimmed.startsWith('https://')) return true;
    if (trimmed.startsWith('http://localhost') ||
        trimmed.startsWith('http://127.0.0.1') ||
        trimmed.startsWith('http://10.0.2.2')) {
      return true;
    }
    return false;
  }

  Future<void> _loadCustomUrl() async {
    final customUrl = await storageService.getCustomBaseUrl();
    if (customUrl != null && customUrl.isNotEmpty && _isSecureOrLocalUrl(customUrl)) {
      dio.options.baseUrl = customUrl;
      ApiConstants.activeBaseUrl = customUrl;
    }
  }

  void updateBaseUrl(String newUrl) {
    final normalized = newUrl.trim();
    if (!_isSecureOrLocalUrl(normalized)) {
      throw ArgumentError('Insecure HTTP URLs are not permitted for remote servers. Use HTTPS.');
    }
    dio.options.baseUrl = normalized;
    ApiConstants.activeBaseUrl = normalized;
    storageService.setCustomBaseUrl(normalized);
  }
}

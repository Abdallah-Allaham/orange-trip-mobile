import 'package:dio/dio.dart';
import '../storage/secure_storage_service.dart';

import 'session_event_notifier.dart';

class AuthInterceptor extends Interceptor {
  final SecureStorageService _storageService;

  AuthInterceptor(this._storageService);

  @override
  Future<void> onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    final token = await _storageService.getToken();
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    options.headers['Accept'] = 'application/json';
    options.headers['Content-Type'] = 'application/json';
    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (err.response?.statusCode == 401) {
      // 401 Unauthorized: token expired or revoked by trip admin
      _storageService.clearSession();
      final message = err.response?.data is Map && err.response?.data['message'] != null
          ? err.response!.data['message'].toString()
          : 'Session expired or reset by administrator.';
      SessionEventNotifier.instance.notifySessionRevoked(message);
    }
    handler.next(err);
  }
}

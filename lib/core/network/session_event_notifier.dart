import 'dart:async';

/// Global event notifier for server-initiated session revocations & 401s
class SessionEventNotifier {
  SessionEventNotifier._();
  static final SessionEventNotifier instance = SessionEventNotifier._();

  final StreamController<String> _controller = StreamController<String>.broadcast();
  Stream<String> get sessionRevokedStream => _controller.stream;

  void notifySessionRevoked(String message) {
    if (!_controller.isClosed) {
      _controller.add(message);
    }
  }

  void dispose() {
    _controller.close();
  }
}

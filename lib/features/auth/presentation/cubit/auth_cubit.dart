import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:local_auth/local_auth.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/network/session_event_notifier.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/usecases/check_eligibility_usecase.dart';
import '../../domain/usecases/login_usecase.dart';
import '../../domain/usecases/set_password_usecase.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final LoginUseCase loginUseCase;
  final CheckEligibilityUseCase checkEligibilityUseCase;
  final SetPasswordUseCase setPasswordUseCase;
  final AuthRepository authRepository;
  final LocalAuthentication localAuth;
  StreamSubscription<String>? _sessionSubscription;

  AuthCubit({
    required this.loginUseCase,
    required this.checkEligibilityUseCase,
    required this.setPasswordUseCase,
    required this.authRepository,
    LocalAuthentication? localAuth,
  })  : localAuth = localAuth ?? LocalAuthentication(),
        super(AuthInitial()) {
    _sessionSubscription = SessionEventNotifier.instance.sessionRevokedStream.listen((reason) {
      handleSessionRevoked(reason);
    });
  }

  Future<void> checkAuthStatus() async {
    emit(AuthLoading());
    try {
      final cachedUser = await authRepository.getCachedUser();
      final hasBiometrics = await authRepository.isBiometricsEnabled();

      if (cachedUser != null) {
        if (hasBiometrics) {
          try {
            final isSupported = await localAuth.isDeviceSupported();
            final canCheck = await localAuth.canCheckBiometrics;
            if (isSupported && canCheck) {
              final authenticated = await localAuth.authenticate(
                localizedReason: 'Authenticate to access Trip Portal',
                options: const AuthenticationOptions(
                  biometricOnly: false,
                  stickyAuth: true,
                ),
              );
              if (authenticated) {
                emit(Authenticated(cachedUser));
                return;
              } else {
                emit(Unauthenticated(
                  canUseBiometrics: true,
                  lastEmail: cachedUser.email,
                ));
                return;
              }
            }
          } catch (_) {}
        }
        emit(Authenticated(cachedUser));
      } else {
        emit(Unauthenticated(
          canUseBiometrics: hasBiometrics,
          lastEmail: null,
        ));
      }
    } catch (_) {
      emit(const Unauthenticated());
    }
  }

  String _cleanErrorMessage(dynamic e) {
    if (e is ServerException) return e.message;
    if (e is Failure) return e.message;
    return e
        .toString()
        .replaceAll(RegExp(r'^(ServerException|Exception|ServerFailure|Failure):\s*'), '')
        .replaceAll(RegExp(r'\s*\(code:\s*\d+\)$'), '');
  }

  Future<void> login(String emailOrEmployeeId, String password, {bool enableBiometrics = false}) async {
    emit(AuthLoading());
    try {
      final user = await loginUseCase(emailOrEmployeeId, password);
      if (enableBiometrics) {
        await authRepository.setBiometricsEnabled(true);
      }
      await authRepository.cacheUser(user);
      emit(Authenticated(user));
    } catch (e) {
      emit(AuthError(_cleanErrorMessage(e)));
    }
  }

  Future<void> checkEligibility(String email) async {
    emit(AuthLoading());
    try {
      final result = await checkEligibilityUseCase(email);
      emit(EligibilityCheckedState(result));
    } catch (e) {
      emit(AuthError(_cleanErrorMessage(e)));
    }
  }

  Future<void> setPassword(String email, String password, String? token) async {
    emit(AuthLoading());
    try {
      final user = await setPasswordUseCase(email, password, token);
      emit(PasswordSetSuccessState(user, 'تم تعيين كلمة المرور بنجاح!'));
    } catch (e) {
      emit(AuthError(_cleanErrorMessage(e)));
    }
  }

  Future<void> authenticateWithBiometrics() async {
    try {
      final canCheck = await localAuth.canCheckBiometrics;
      final isSupported = await localAuth.isDeviceSupported();
      if (!canCheck && !isSupported) {
        emit(const AuthError('Biometric authentication is not supported on this device.'));
        return;
      }

      final authenticated = await localAuth.authenticate(
        localizedReason: 'Authenticate to access O Trip',
        options: const AuthenticationOptions(
          biometricOnly: false,
          stickyAuth: true,
        ),
      );

      if (authenticated) {
        final biometricUser = await authRepository.getBiometricUser();
        final cachedUser = biometricUser ?? await authRepository.getCachedUser();
        if (cachedUser != null) {
          await authRepository.cacheUser(cachedUser);
          emit(Authenticated(cachedUser));
        } else {
          emit(const AuthError('No cached credentials found. Please sign in with your password first to enable biometric unlock.'));
        }
      }
    } catch (e) {
      emit(AuthError('Biometric authentication failed: $e'));
    }
  }

  Future<void> logout() async {
    await authRepository.logout();
    final hasBiometrics = await authRepository.isBiometricsEnabled();
    emit(Unauthenticated(canUseBiometrics: hasBiometrics));
  }

  Future<void> handleSessionRevoked(String reason) async {
    await authRepository.logout();
    emit(SessionRevokedState(reason));
  }

  @override
  Future<void> close() {
    _sessionSubscription?.cancel();
    return super.close();
  }
}

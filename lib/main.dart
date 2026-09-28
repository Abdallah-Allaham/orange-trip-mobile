import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'core/constants/colors.dart';
import 'core/di/injection_container.dart';
import 'core/theme/orange_theme.dart';
import 'features/auth/presentation/cubit/auth_cubit.dart';
import 'features/auth/presentation/cubit/auth_state.dart';
import 'features/auth/presentation/screens/login_screen.dart';
import 'features/dashboard/presentation/screens/dashboard_shell_screen.dart';

import 'core/storage/secure_storage_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await initInjection();

  final storage = sl<SecureStorageService>();
  final savedLang = await storage.getLanguage(); // defaults to 'en'

  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('en'), Locale('ar')],
      path: 'assets/translations',
      fallbackLocale: const Locale('en'),
      startLocale: Locale(savedLang),
      child: const OrangeTripApp(),
    ),
  );
}

class OrangeTripApp extends StatelessWidget {
  const OrangeTripApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return BlocProvider<AuthCubit>(
          create: (_) => sl<AuthCubit>()..checkAuthStatus(),
          child: MaterialApp(
            title: 'Orange Trip — Cairo 2026',
            debugShowCheckedModeBanner: false,
            localizationsDelegates: context.localizationDelegates,
            supportedLocales: context.supportedLocales,
            locale: context.locale,
            theme: OrangeTheme.lightTheme,
            home: const AuthGate(),
          ),
        );
      },
    );
  }
}

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        if (state is Authenticated) {
          return DashboardShellScreen(user: state.user);
        }

        if (state is AuthLoading && state is! Unauthenticated) {
          return Scaffold(
            backgroundColor: OrangeColors.coreBlack,
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/images/orange_logo.png',
                    width: 56.w,
                    height: 56.w,
                  ),
                  SizedBox(height: 24.h),
                  const CircularProgressIndicator(
                    color: OrangeColors.brandOrange,
                    strokeWidth: 2.5,
                  ),
                ],
              ),
            ),
          );
        }

        return LoginScreen(
          onLoginSuccess: () {
            // Handled reactively by BlocBuilder when state turns to Authenticated
          },
        );
      },
    );
  }
}

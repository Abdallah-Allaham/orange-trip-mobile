import 'package:get_it/get_it.dart';
import '../../features/auth/data/datasources/auth_local_data_source.dart';
import '../../features/auth/data/datasources/auth_remote_data_source.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/auth/domain/usecases/check_eligibility_usecase.dart';
import '../../features/auth/domain/usecases/login_usecase.dart';
import '../../features/auth/domain/usecases/set_password_usecase.dart';
import '../../features/auth/presentation/cubit/auth_cubit.dart';
import '../../features/dashboard/data/datasources/dashboard_remote_data_source.dart';
import '../../features/dashboard/data/repositories/dashboard_repository_impl.dart';
import '../../features/dashboard/domain/repositories/dashboard_repository.dart';
import '../../features/dashboard/domain/usecases/get_dashboard_data_usecase.dart';
import '../../features/dashboard/presentation/cubit/dashboard_cubit.dart';
import '../network/api_client.dart';
import '../storage/secure_storage_service.dart';

final sl = GetIt.instance;

Future<void> initInjection() async {
  // 1. Core Services & Storage
  sl.registerLazySingleton<SecureStorageService>(() => SecureStorageService());
  sl.registerLazySingleton<ApiClient>(() => ApiClient(storageService: sl()));

  // 2. Auth Feature
  // Data Sources
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(apiClient: sl()),
  );
  sl.registerLazySingleton<AuthLocalDataSource>(
    () => AuthLocalDataSourceImpl(storageService: sl()),
  );

  // Repository
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      remoteDataSource: sl(),
      localDataSource: sl(),
    ),
  );

  // Use Cases
  sl.registerLazySingleton(() => LoginUseCase(sl()));
  sl.registerLazySingleton(() => CheckEligibilityUseCase(sl()));
  sl.registerLazySingleton(() => SetPasswordUseCase(sl()));

  // Cubits
  sl.registerFactory(
    () => AuthCubit(
      loginUseCase: sl(),
      checkEligibilityUseCase: sl(),
      setPasswordUseCase: sl(),
      authRepository: sl(),
    ),
  );

  // 3. Dashboard & Logistics Feature
  // Data Source
  sl.registerLazySingleton<DashboardRemoteDataSource>(
    () => DashboardRemoteDataSourceImpl(apiClient: sl()),
  );

  // Repository
  sl.registerLazySingleton<DashboardRepository>(
    () => DashboardRepositoryImpl(
      remoteDataSource: sl(),
      storageService: sl(),
    ),
  );

  // Use Cases
  sl.registerLazySingleton(() => GetDashboardDataUseCase(sl()));

  // Cubit
  sl.registerFactory(
    () => DashboardCubit(
      getDashboardDataUseCase: sl(),
      repository: sl(),
    ),
  );
}


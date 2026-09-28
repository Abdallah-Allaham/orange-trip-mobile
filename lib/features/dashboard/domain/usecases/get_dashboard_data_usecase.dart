import '../entities/dashboard_data_entity.dart';
import '../repositories/dashboard_repository.dart';

class GetDashboardDataUseCase {
  final DashboardRepository repository;

  GetDashboardDataUseCase(this.repository);

  Future<DashboardDataEntity> call() async {
    return await repository.getDashboardData();
  }
}

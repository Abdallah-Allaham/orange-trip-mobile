import 'package:flutter_test/flutter_test.dart';
import 'package:orange_trip_mobile/features/auth/data/models/user_model.dart';
import 'package:orange_trip_mobile/features/auth/domain/entities/user_entity.dart';

void main() {
  const tUserModel = UserModel(
    userId: 1,
    fullName: 'Ahmad Al-Mansoor',
    email: 'ahmad.director@orange.jo',
    employeeId: 'EMP-001',
    role: 'Participant',
    assignedGroup: 'Group A',
    assignedBus: 'Bus 1',
    completionScore: 80,
    token: 'jwt_mock_token',
  );

  test('UserModel should be a subclass of UserEntity', () {
    expect(tUserModel, isA<UserEntity>());
  });

  test('fromJson should parse valid json correctly', () {
    final Map<String, dynamic> jsonMap = {
      'userId': 1,
      'fullName': 'Ahmad Al-Mansoor',
      'email': 'ahmad.director@orange.jo',
      'employeeId': 'EMP-001',
      'role': 'Participant',
      'assignedGroup': 'Group A',
      'assignedBus': 'Bus 1',
      'completionScore': 80,
      'token': 'jwt_mock_token',
    };

    final result = UserModel.fromJson(jsonMap);
    expect(result, equals(tUserModel));
  });

  test('toJson should return a JSON map containing proper data', () {
    final result = tUserModel.toJson();
    final expectedMap = {
      'userId': 1,
      'fullName': 'Ahmad Al-Mansoor',
      'email': 'ahmad.director@orange.jo',
      'employeeId': 'EMP-001',
      'role': 'Participant',
      'assignedGroup': 'Group A',
      'assignedBus': 'Bus 1',
      'completionScore': 80,
      'token': 'jwt_mock_token',
    };
    expect(result, expectedMap);
  });
}

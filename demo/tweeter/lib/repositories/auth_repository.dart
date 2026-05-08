import '../models/jwt_response.dart';

abstract class IAuthRepository {
  Future<void> init();

  Future<JwtResponse> login(String username, String password);

  Future<void> logout();

  bool isAuthenticated();

  String? getToken();
}
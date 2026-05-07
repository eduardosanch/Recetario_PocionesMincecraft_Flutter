import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../core/api_config.dart';
import '../models/jwt_response.dart';
import '../models/user.dart';
import '../repositories/auth_repository.dart';

class AuthService implements IAuthRepository {
  static final AuthService _instance = AuthService._internal();

  late http.Client _httpClient;
  SharedPreferences? _prefs;

  String? _token;
  User? _user;

  AuthService._internal() {
    _httpClient = http.Client();
  }

  factory AuthService() {
    return _instance;
  }

  static AuthService getInstance() {
    return _instance;
  }

  String get _baseUrl => ApiConfig.authUrl;

  @override
  Future<void> init() async {
    _prefs ??= await SharedPreferences.getInstance();

    _token = _prefs!.getString('token');

    final userJson = _prefs!.getString('user');
    if (userJson != null) {
      _user = User.fromJson(
        jsonDecode(userJson) as Map<String, dynamic>,
      );
    }
  }

  @override
  Future<JwtResponse> login(String username, String password) async {
    final response = await _httpClient.post(
      Uri.parse('$_baseUrl/signin'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'username': username,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body) as Map<String, dynamic>;

      final jwtResponse = JwtResponse.fromJson(jsonData);

      _token = jwtResponse.accessToken;
      _user = jwtResponse.user;

      _prefs ??= await SharedPreferences.getInstance();
      await _prefs!.setString('token', _token!);
      await _prefs!.setString('user', jsonEncode(_user!.toJson()));

      return jwtResponse;
    }

    throw Exception('No se pudo iniciar sesión (${response.statusCode})');
  }

  Future<void> register({
    required String username,
    required String email,
    required String password,
  }) async {
    final response = await _httpClient.post(
      Uri.parse('$_baseUrl/signup'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'username': username,
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode != 200 && response.statusCode != 201) {
      String message = 'No se pudo registrar el usuario';

      try {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        message = data['message']?.toString() ?? message;
      } catch (_) {}

      throw Exception('$message (${response.statusCode})');
    }
  }

  @override
  Future<void> logout() async {
    _prefs ??= await SharedPreferences.getInstance();

    await _prefs!.remove('token');
    await _prefs!.remove('user');

    _token = null;
    _user = null;
  }

  @override
  bool isAuthenticated() {
    return _token != null && _token!.isNotEmpty;
  }

  @override
  String? getToken() {
    return _token;
  }

  Future<String?> getTokenOrRestore() async {
    if (_token != null && _token!.isNotEmpty) {
      return _token;
    }

    await init();
    return _token;
  }

  User? getUser() {
    return _user;
  }
}
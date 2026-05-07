class ApiConfig {
  static const String baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://localhost:8080/api',
  );

  static String get authUrl => '$baseUrl/auth';
  static String get potionsUrl => '$baseUrl/potions';
}
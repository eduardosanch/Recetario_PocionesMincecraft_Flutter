class ApiConfig {
  static const String baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'https://recetario-pociones.onrender.com/api',
  );

  static String get authUrl => '$baseUrl/auth';
  static String get potionsUrl => '$baseUrl/potions';
}
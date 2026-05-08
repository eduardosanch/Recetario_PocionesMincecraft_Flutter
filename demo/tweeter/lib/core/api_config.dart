class ApiConfig {
  static const String baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue:
        'https://recetario-pocionesminecraft-flutter.onrender.com',
  );

  static String get authUrl => '$baseUrl/api/auth';

  static String get potionsUrl => '$baseUrl/api/potions';
}
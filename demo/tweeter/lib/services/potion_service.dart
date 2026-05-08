import 'dart:convert';

import 'package:http/http.dart' as http;

import '../core/adapters/potion_response_adapter.dart';
import '../core/api_config.dart';
import '../models/potion_comment.dart';
import '../models/potion_post.dart';
import '../repositories/potion_repository.dart';
import 'auth_service.dart';

class PotionService implements IPotionRepository {
  static final PotionService _instance = PotionService._internal();

  late http.Client _httpClient;
  late AuthService _authService;

  PotionService._internal() {
    _httpClient = http.Client();
    _authService = AuthService();
  }

  factory PotionService() {
    return _instance;
  }

  static PotionService getInstance() {
    return _instance;
  }

  String get _baseUrl => ApiConfig.potionsUrl;

  Future<Map<String, String>> _headers({bool requireAuth = true}) async {
    final headers = <String, String>{
      'Content-Type': 'application/json',
    };

    // Solo enviar token si se requiere autenticación
    if (requireAuth) {
      final token = await _authService.getTokenOrRestore();

      if (token != null && token.isNotEmpty) {
        headers['Authorization'] = 'Bearer $token';
      }
    }

    return headers;
  }

  @override
  Future<List<PotionPost>> fetchPotions() async {
    // Este endpoint es público, no requerimos token
    final headers = await _headers(requireAuth: false);

    final response = await _httpClient.get(
      Uri.parse(_baseUrl),
      headers: headers,
    );

    if (response.statusCode == 200) {
      final dynamic jsonData = jsonDecode(response.body);
      return PotionResponseAdapter.extractPotions(jsonData);
    }

    throw Exception(
      'No se pudieron cargar las pociones (${response.statusCode})',
    );
  }

  @override
  Future<PotionPost> createPotion({
    required String nombre,
    required String descripcion,
    required int duracionSegundos,
    required List<String> imagenes,
  }) async {
    // Este endpoint requiere autenticación
    final response = await _httpClient.post(
      Uri.parse('$_baseUrl/create'),
      headers: await _headers(requireAuth: true),
      body: jsonEncode({
        'nombre': nombre,
        'descripcion': descripcion,
        'duracionSegundos': duracionSegundos,
        'imagenes': imagenes,
      }),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final jsonData = jsonDecode(response.body) as Map<String, dynamic>;
      return PotionPost.fromJson(jsonData);
    }

    throw Exception(
      'No se pudo crear la poción (${response.statusCode})',
    );
  }

  @override
  Future<void> deletePotion(int id) async {
    final response = await _httpClient.delete(
      Uri.parse('$_baseUrl/$id'),
      headers: await _headers(requireAuth: true),
    );

    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception(
        'No se pudo eliminar la poción (${response.statusCode})',
      );
    }
  }

  Future<List<PotionComment>> fetchPotionComments(int potionPostId) async {
    final response = await _httpClient.get(
      Uri.parse('${ApiConfig.baseUrl}/potion-comments/potion/$potionPostId'),
      headers: await _headers(requireAuth: false),
    );

    if (response.statusCode != 200) {
      throw Exception(
        'No se pudieron cargar los comentarios (${response.statusCode})',
      );
    }

    final jsonData = jsonDecode(response.body);

    final List<dynamic> content = jsonData is Map<String, dynamic>
        ? (jsonData['content'] as List<dynamic>? ?? [])
        : (jsonData as List<dynamic>? ?? []);

    return content
        .map(
          (item) => PotionComment.fromJson(
            Map<String, dynamic>.from(item as Map),
          ),
        )
        .toList();
  }

  Future<PotionComment> createPotionComment({
    required int potionPostId,
    required String content,
  }) async {
    final response = await _httpClient.post(
      Uri.parse('${ApiConfig.baseUrl}/potion-comments'),
      headers: await _headers(requireAuth: true),
      body: jsonEncode({
        'potionPostId': potionPostId,
        'content': content,
      }),
    );

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception(
        'No se pudo crear el comentario (${response.statusCode})',
      );
    }

    return PotionComment.fromJson(
      Map<String, dynamic>.from(jsonDecode(response.body) as Map),
    );
  }

  Future<void> reactToPotion({
    required int potionPostId,
    required String type,
  }) async {
    final response = await _httpClient.post(
      Uri.parse('${ApiConfig.baseUrl}/potion-reactions'),
      headers: await _headers(requireAuth: true),
      body: jsonEncode({
        'potionPostId': potionPostId,
        'type': type,
      }),
    );

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception(
        'No se pudo reaccionar a la poción (${response.statusCode})',
      );
    }
  }

  @override
  void dispose() {
    _httpClient.close();
  }
}
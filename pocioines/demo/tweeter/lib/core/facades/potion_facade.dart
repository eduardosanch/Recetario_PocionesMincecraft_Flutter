import '../../models/jwt_response.dart';
import '../../models/potion_comment.dart';
import '../../models/potion_post.dart';
import '../../models/user.dart';
import '../../services/auth_service.dart';
import '../../services/potion_service.dart';

class PotionFacade {
  PotionFacade({
    required AuthService authService,
    required PotionService potionService,
  })  : _authService = authService,
        _potionService = potionService;

  final AuthService _authService;
  final PotionService _potionService;

  Future<void> init() => _authService.init();

  bool isAuthenticated() => _authService.isAuthenticated();

  User? getUser() => _authService.getUser();

  Future<JwtResponse> login(String username, String password) {
    return _authService.login(username, password);
  }

  Future<void> register({
    required String username,
    required String email,
    required String password,
  }) {
    return _authService.register(
      username: username,
      email: email,
      password: password,
    );
  }

  Future<void> logout() {
    return _authService.logout();
  }

  Future<List<PotionPost>> fetchPotions() {
    return _potionService.fetchPotions();
  }

  Future<PotionPost> createPotion({
    required String nombre,
    required String descripcion,
    required int duracionSegundos,
    required List<String> imagenes,
  }) {
    return _potionService.createPotion(
      nombre: nombre,
      descripcion: descripcion,
      duracionSegundos: duracionSegundos,
      imagenes: imagenes,
    );
  }

  Future<void> deletePotion(int id) {
    return _potionService.deletePotion(id);
  }

  Future<List<PotionComment>> fetchPotionComments(int potionPostId) {
    return _potionService.fetchPotionComments(potionPostId);
  }

  Future<PotionComment> createPotionComment({
    required int potionPostId,
    required String content,
  }) {
    return _potionService.createPotionComment(
      potionPostId: potionPostId,
      content: content,
    );
  }

  Future<void> reactToPotion({
    required int potionPostId,
    required String type,
  }) {
    return _potionService.reactToPotion(
      potionPostId: potionPostId,
      type: type,
    );
  }

  void dispose() {
    _potionService.dispose();
  }
}
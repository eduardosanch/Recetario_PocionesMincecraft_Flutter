import '../../services/auth_service.dart';
import '../../services/potion_service.dart';
import '../facades/potion_facade.dart';

class AppServiceFactory {
  const AppServiceFactory._();

  static AuthService authService() {
    return AuthService();
  }

  static PotionService potionService() {
    return PotionService();
  }

  static PotionFacade potionFacade() {
    return PotionFacade(
      authService: authService(),
      potionService: potionService(),
    );
  }
}
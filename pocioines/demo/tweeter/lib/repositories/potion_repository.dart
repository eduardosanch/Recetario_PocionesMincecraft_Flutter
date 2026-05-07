import '../models/potion_post.dart';

abstract class IPotionRepository {
  Future<List<PotionPost>> fetchPotions();

  Future<PotionPost> createPotion({
    required String nombre,
    required String descripcion,
    required int duracionSegundos,
    required List<String> imagenes,
  });

  Future<void> deletePotion(int id);

  void dispose();
}
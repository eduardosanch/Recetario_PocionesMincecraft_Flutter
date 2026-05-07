import '../../models/potion_post.dart';

class PotionResponseAdapter {
  const PotionResponseAdapter._();

  static List<PotionPost> extractPotions(dynamic jsonData) {
    final List<dynamic> potionsJson;

    if (jsonData is List) {
      potionsJson = jsonData;
    } else if (jsonData is Map<String, dynamic>) {
      potionsJson = jsonData['content'] as List<dynamic>? ?? [];
    } else {
      potionsJson = [];
    }

    return potionsJson
        .map(
          (item) => PotionPost.fromJson(
            Map<String, dynamic>.from(item as Map),
          ),
        )
        .toList();
  }
}
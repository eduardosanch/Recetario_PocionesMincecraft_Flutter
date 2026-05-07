class PotionPost {
  final int id;
  final String nombre;
  final String descripcion;
  final int duracionSegundos;
  final List<String> imagenes;
  final String? postedByUsername;
  final int? postedByUserId;
  final int commentsCount;
  final int reactionsCount;

  PotionPost({
    required this.id,
    required this.nombre,
    required this.descripcion,
    required this.duracionSegundos,
    required this.imagenes,
    this.postedByUsername,
    this.postedByUserId,
    required this.commentsCount,
    required this.reactionsCount,
  });

  factory PotionPost.fromJson(Map<String, dynamic> json) {
    int parseInt(dynamic value) {
      if (value is int) return value;
      return int.tryParse(value?.toString() ?? '0') ?? 0;
    }

    List<String> parseImages(dynamic value) {
      if (value is List) {
        return value.map((item) => item.toString()).toList();
      }

      if (value is String && value.trim().isNotEmpty) {
        return [value];
      }

      return [];
    }

    return PotionPost(
      id: parseInt(json['id']),
      nombre: json['nombre']?.toString() ?? '',
      descripcion: json['descripcion']?.toString() ?? '',
      duracionSegundos: parseInt(json['duracionSegundos']),
      imagenes: parseImages(json['imagenes']),
      postedByUsername: json['postedByUsername']?.toString(),
      postedByUserId: json['postedByUserId'] == null
          ? null
          : parseInt(json['postedByUserId']),
      commentsCount: parseInt(json['commentsCount']),
      reactionsCount: parseInt(json['reactionsCount']),
    );
  }

  String? get firstImage {
    if (imagenes.isEmpty) return null;
    return imagenes.first;
  }
}
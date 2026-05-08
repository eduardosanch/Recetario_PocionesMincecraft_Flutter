class PotionComment {
  final int id;
  final String content;
  final String commentedByUsername;
  final int commentedByUserId;
  final int potionPostId;

  PotionComment({
    required this.id,
    required this.content,
    required this.commentedByUsername,
    required this.commentedByUserId,
    required this.potionPostId,
  });

  factory PotionComment.fromJson(Map<String, dynamic> json) {
    int parseInt(dynamic value) {
      if (value is int) return value;
      return int.tryParse(value?.toString() ?? '0') ?? 0;
    }

    return PotionComment(
      id: parseInt(json['id']),
      content: json['content']?.toString() ?? '',
      commentedByUsername:
          json['commentedByUsername']?.toString() ?? 'Desconocido',
      commentedByUserId: parseInt(json['commentedByUserId']),
      potionPostId: parseInt(json['potionPostId']),
    );
  }
}
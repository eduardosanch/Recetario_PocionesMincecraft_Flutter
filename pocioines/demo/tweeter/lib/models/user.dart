class User {
  final int id;
  final String username;
  final String email;
  final List<String> roles;

  User({
    required this.id,
    required this.username,
    required this.email,
    required this.roles,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    int parseInt(dynamic value) {
      if (value is int) return value;
      return int.tryParse(value?.toString() ?? '0') ?? 0;
    }

    final rolesJson = json['roles'];

    return User(
      id: parseInt(json['id']),
      username: json['username']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      roles: rolesJson is List
          ? rolesJson.map((role) => role.toString()).toList()
          : <String>[],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'roles': roles,
    };
  }
}
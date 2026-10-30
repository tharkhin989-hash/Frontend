class User{
  final int userId;
  final String name;
  final String email;
  final String role;
  const User({
    required this.userId,
    required this.name,
    required this.email,
    required this.role,
  });

factory User.fromJson(Map<String, dynamic> json) {
    return User(
      userId: int.parse(json['user_id'].toString()),
      name: json['name']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      role: json['role']?.toString() ?? '',
    );
  }
}
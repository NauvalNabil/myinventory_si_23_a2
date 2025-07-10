// File: models/user_model.dart
class UserModel {
  final String id;
  final String email;
  final String? username;

  UserModel({
    required this.id,
    required this.email,
    this.username,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      email: json['email'] as String,
      username: json['user_metadata']?['username'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'email': email,
        'username': username,
      };
}
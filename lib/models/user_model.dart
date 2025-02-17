class User {
  final int id;
  final String name;
  final String email;
  final String role;
  final DateTime updatedAt;
  final DateTime createdAt;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    required this.updatedAt,
    required this.createdAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      name: json['name'],
      email: json['email'],
      role: json['role'],
      updatedAt: DateTime.parse(json['updated_at']),
      createdAt: DateTime.parse(json['created_at']),
      id: json['id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'role': role,
      'updated_at': updatedAt.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
      'id': id,
    };
  }
}

class UserData {
  final String? token;
  final User user;

  UserData({
    required this.token,
    required this.user,
  });

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      token: json['token'],
      user: User.fromJson(json['user']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'token': token,
      'user': user.toJson(),
    };
  }
}

class UserResponse {
  final bool success;
  final String? message;
  final UserData? data;

  UserResponse({
    required this.success,
    required this.message,
    this.data,
  });

  factory UserResponse.fromJson(Map<String, dynamic> responseData) {
    return UserResponse(
      success: responseData['success'],
      message: responseData['message'],
      data: responseData['data'] != null
          ? UserData.fromJson(responseData['data'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'data': data?.toJson(),
    };
  }
}

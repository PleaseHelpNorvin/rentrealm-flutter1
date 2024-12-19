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

  Map<String, dynamic>toJson() {
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
  final String token;
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
  final String message;
  final UserData? data;

  UserResponse({
    required this.success,
    required this.message,
    this.data,
  });

  factory UserResponse.fromJson(Map<String, dynamic> json) {
    return UserResponse(
      success: json['success'],
      message: json['message'],
      data: json['data'] != null ? UserData.fromJson(json['data']) : null,
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

// class userLoginResponse {
//   final bool success;
//   final String message;
//   final UserData? data;

//   userLoginResponse({
//     required this.success,
//     required this.message,
//     this.data,
//   });

//   factory userLoginResponse.fromJson(Map<String, dynamic> json) {
//     return userLoginResponse(
//       success: json['success'],
//       message: json['message'],
//       data: json['data'] != null ? UserData.fromJson(json['data']) : null,
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'success': success,
//       'message': message,
//       'data': data?.toJson(),
//     };
//   }
// }

// class userLogoutResponse {
//   final bool success;
//   final String? message;
//   final dynamic data;

//   userLogoutResponse({
//     required this.success,
//     this.message,
//     this.data,
//   });

//   factory userLogoutResponse.fromJson(Map<String, dynamic> json) {
//     return userLogoutResponse(
//       success: json['success'] ?? false,
//       message: json['message'],
//       data: json['data'],
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'success': success,
//       'message': message,
//       'data': data,
//     };
//   }
// }

// class UserUpdateResponse {
//   final bool success;
//   final String message;
//   final UserData? data;

//   UserUpdateResponse({
//     required this.success,
//     required this.message,
//     this.data,
//   });

//   factory UserUpdateResponse.fromJson(Map<String, dynamic> json) {
//     return UserUpdateResponse(
//       success: json['success'],
//       message: json['message'],
//       data: json['data']['user'] != null ? UserData.fromJson(json['data']['user']) : null,
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'success': success,
//       'message': message,
//       'data': data?.toJson(),
//     };
//   }
// }

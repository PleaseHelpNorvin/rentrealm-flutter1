import 'package:flutter/material.dart';

class NotificationResponse {
  final bool success;
  final String message;
  final NotificationData data;

  NotificationResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory NotificationResponse.fromJson(Map<String, dynamic> json) {
    return NotificationResponse(
      success: json['success'],
      message: json['message'],
      data: NotificationData.fromJson(json['data']),
    );
  }
}

class NotificationData {
  late final List<NotificationModel> notifications;

  NotificationData({required this.notifications});

  factory NotificationData.fromJson(Map<String, dynamic> json) {
    var notificationsJson = json['notifications'];
    
    // if (notificationsJson == null) {
    //   return NotificationData(notifications: []); // ✅ Return empty list if null
    // }

    if (notificationsJson is List) {
      return NotificationData(
        notifications: List<NotificationModel>.from(
          notificationsJson.map((x) => NotificationModel.fromJson(x)),
        ),
      );
    } else if (notificationsJson is Map<String, dynamic>) {
      return NotificationData(
        notifications: [NotificationModel.fromJson(notificationsJson)],
      );
    } else {
      throw Exception('Invalid notifications data format');
    }
  }
}



class NotificationModel {
  final int id;
  final int userId;
  final String title;
  final String message;
  late final int isRead;
  final String notifiableType;
  final int notifiableId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final Map<String, dynamic>? notifiable;

  NotificationModel({
    required this.id,
    required this.userId,
    required this.title,
    required this.message,
    required this.isRead,
    required this.notifiableType,
    required this.notifiableId,
    required this.createdAt,
    required this.updatedAt,
    this.notifiable,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'],
      userId: json['user_id'],
      title: json['title'],
      message: json['message'],
      isRead: json['is_read'],
      notifiableType: json['notifiable_type'],
      notifiableId: json['notifiable_id'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      notifiable: json['notifiable'],
    );
  }
}

// just in case gamiton

// class Notifiable {
//   final int id;
//   final int profileId;
//   final int roomId;
//   final String status;
//   final bool hasPets;
//   final bool wifiEnabled;
//   final bool hasLaundryAccess;
//   final bool hasPrivateFridge;
//   final bool hasTv;
//   final DateTime createdAt;
//   final DateTime updatedAt;

//   Notifiable({
//     required this.id,
//     required this.profileId,
//     required this.roomId,
//     required this.status,
//     required this.hasPets,
//     required this.wifiEnabled,
//     required this.hasLaundryAccess,
//     required this.hasPrivateFridge,
//     required this.hasTv,
//     required this.createdAt,
//     required this.updatedAt,
//   });

//   factory Notifiable.fromJson(Map<String, dynamic> json) {
//     return Notifiable(
//       id: json['id'],
//       profileId: json['profile_id'],
//       roomId: json['room_id'],
//       status: json['status'],
//       hasPets: json['has_pets'] == 1,
//       wifiEnabled: json['wifi_enabled'] == 1,
//       hasLaundryAccess: json['has_laundry_access'] == 1,
//       hasPrivateFridge: json['has_private_fridge'] == 1,
//       hasTv: json['has_tv'] == 1,
//       createdAt: DateTime.parse(json['created_at']),
//       updatedAt: DateTime.parse(json['updated_at']),
//     );
//   }
// }


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

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'data': data.toJson(),
    };
  }
}

class NotificationData {
  final List<Notification> notifications;

  NotificationData({required this.notifications});

  factory NotificationData.fromJson(Map<String, dynamic> json) {
    return NotificationData(
      notifications: (json['notifications'] as List)
          .map((item) => Notification.fromJson(item))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'notifications': notifications.map((e) => e.toJson()).toList(),
    };
  }

  map(Function(dynamic item) param0) {}
}

class Notification {
  final int id;
  final int userId;
  final String title;
  final String message;
  final int isRead;
  final String notifiableType;
  final int notifiableId;
  final String createdAt;
  final String updatedAt;
  final Notifiable? notifiable;

  Notification({
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

  factory Notification.fromJson(Map<String, dynamic> json) {
    return Notification(
      id: json['id'],
      userId: json['user_id'],
      title: json['title'],
      message: json['message'],
      isRead: json['is_read'],
      notifiableType: json['notifiable_type'],
      notifiableId: json['notifiable_id'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      notifiable: json['notifiable'] != null ? Notifiable.fromJson(json['notifiable']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'title': title,
      'message': message,
      'is_read': isRead,
      'notifiable_type': notifiableType,
      'notifiable_id': notifiableId,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'notifiable': notifiable?.toJson(),
    };
  }
}

class Notifiable {
  final int id;
  final int profileId;
  final int roomId;
  final String status;
  final int hasPets;
  final int wifiEnabled;
  final int hasLaundryAccess;
  final int hasPrivateFridge;
  final int hasTv;
  final String createdAt;
  final String updatedAt;

  Notifiable({
    required this.id,
    required this.profileId,
    required this.roomId,
    required this.status,
    required this.hasPets,
    required this.wifiEnabled,
    required this.hasLaundryAccess,
    required this.hasPrivateFridge,
    required this.hasTv,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Notifiable.fromJson(Map<String, dynamic> json) {
    return Notifiable(
      id: json['id'],
      profileId: json['profile_id'],
      roomId: json['room_id'],
      status: json['status'],
      hasPets: json['has_pets'],
      wifiEnabled: json['wifi_enabled'],
      hasLaundryAccess: json['has_laundry_access'],
      hasPrivateFridge: json['has_private_fridge'],
      hasTv: json['has_tv'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'profile_id': profileId,
      'room_id': roomId,
      'status': status,
      'has_pets': hasPets,
      'wifi_enabled': wifiEnabled,
      'has_laundry_access': hasLaundryAccess,
      'has_private_fridge': hasPrivateFridge,
      'has_tv': hasTv,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}

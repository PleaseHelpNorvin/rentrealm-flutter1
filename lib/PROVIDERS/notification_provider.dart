import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rentealm_flutter/models/notification_model.dart';
import 'package:rentealm_flutter/networks/apiservice.dart';

import 'auth_provider.dart';

class NotificationProvider extends ChangeNotifier {
  final ApiService apiService = ApiService();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  NotificationResponse? _notification;
  NotificationResponse? get notification => _notification;

  String _filterType = "all"; // ✅ "all", "unread", "read"
  String get filterType => _filterType;

  List<Map<String, dynamic>> get notificationDetails {
    List<Map<String, dynamic>> allNotifications = _notification?.data.notifications
            .map((notif) => {
                  "id": notif.id,
                  "title": notif.title,
                  "message": notif.message,
                  "is_read": notif.isRead,
                  "notifiable_id": notif.notifiableId
                })
            .toList() ??
        [];

    // ✅ Apply filtering based on selected filter type
    if (_filterType == "unread") {
      return allNotifications.where((notif) => notif["is_read"] == 0).toList();
    } else if (_filterType == "read") {
      return allNotifications.where((notif) => notif["is_read"] == 1).toList();
    }

    return allNotifications;
  }

  void setNotification(NotificationResponse? notification) {
    _notification = notification;
    notifyListeners();
  }

  void setFilterType(String type) {
    _filterType = type;
    notifyListeners(); // ✅ Notify UI to rebuild with new filter
  }

  Future<void> fetchNotification(BuildContext context) async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    String token = authProvider.token ?? '';
    int userId = authProvider.userId ?? 0;

    if (token.isEmpty || userId == 0) {
      print("Invalid token or userId, skipping API call.");
      return;
    }

    _isLoading = true;
    notifyListeners();

    print("Fetching notifications for User ID: $userId");

    try {
      final response = await apiService.getNotification(token: token, userId: userId);

      if (response != null && response.data.notifications.isNotEmpty) {
        setNotification(response);
        print('Fetched ${response.data.notifications.length} notifications.');
      } else {
        print('No notifications found.');
        setNotification(null);
      }
    } catch (e) {
      print("Error fetching notifications: $e");
      return;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateStatusToRead(BuildContext context, int notificationId) async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    String token = authProvider.token ?? '';
    int userId = authProvider.userId ?? 0;

    if (token.isEmpty || userId == 0 || notificationId == 0) {
      print("Invalid token, userId, or notificationId. Skipping API call.");
      return;
    }

    try {
      final response = await apiService.patchNotificationStatus(
        token: token, 
        userId: userId, 
        notifId: notificationId
      );

      if (response != null) {
        print("updateStatusToRead(): ${response.data.notifications}");
      }

      // ✅ Fix: Create a new NotificationData instance with updated notifications
      if (_notification != null) {
        List<NotificationModel> updatedNotifications = _notification!.data.notifications.map((notif) {
          if (notif.id == notificationId) {
            return NotificationModel(
              id: notif.id,
              userId: notif.userId,
              title: notif.title,
              message: notif.message,
              isRead: 1, // ✅ Mark as read
              notifiableType: notif.notifiableType,
              notifiableId: notif.notifiableId,
              createdAt: notif.createdAt,
              updatedAt: DateTime.now(),
              notifiable: notif.notifiable,
            );
          }
          return notif;
        }).toList();

        // ✅ Create a new NotificationData object
        _notification = NotificationResponse(
          success: true, 
          message: "Notification $notificationId marked as read.", 
          data: NotificationData(notifications: updatedNotifications),
        );
        notifyListeners();
      }
      
    } catch (e) {
      print("Error updating notification status: $e");
      return;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rentealm_flutter/MODELS/property_model.dart';
import 'package:rentealm_flutter/models/inquiry_model.dart';
import 'package:rentealm_flutter/models/notification_model.dart';
import 'package:rentealm_flutter/networks/apiservice.dart';

import 'auth_provider.dart';

class NotificationProvider extends ChangeNotifier{
  final ApiService apiService = ApiService();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  NotificationResponse? _notification;
  NotificationResponse? get notification => _notification;

  List<String> get notificationsList {
    return _notification?.data.map((notif) => notif.message).toList() ?? [];
  }


  setNotification(NotificationResponse? notification) {
    _notification = notification;
    notifyListeners();
  }

  Future<void> fetchNotification(BuildContext context) async {
    _isLoading = true;
    notifyListeners();

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    String token = authProvider.token ?? '';
    int userId = authProvider.userId ?? 0;

    print("fetchNotification(): $token");
    print("fetchNotification(): $userId");

    try {
      final response = await apiService.getNotification(token: token, userId: userId);

      if (response?.data != null) {
        _notification = response;
        notifyListeners();
        print('successresponse');
      }

    } catch (e) {
      print("Error fetching notifications: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
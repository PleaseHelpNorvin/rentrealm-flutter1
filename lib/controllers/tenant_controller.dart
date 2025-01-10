import 'dart:math';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:rentealm_flutter/controllers/auth_controller.dart';
import 'package:rentealm_flutter/controllers/profile_controller.dart';
import '../networks/apiservice.dart';
import '../models/tenant_model.dart';

class TenantController with ChangeNotifier {
  final ApiService apiService = ApiService();
  final AuthController authController = AuthController();
  final ProfileController profileController = ProfileController();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Tenant? _tenant;
  Tenant? get tenant => _tenant;

  void setTenant() {
    _tenant = tenant;
    notifyListeners();
  }

  Future<void> fetchTenant(BuildContext context) async {
    final token = authController.token ?? '';
    final userId = authController.user?.data?.user.id;
    print('fetchTenant(): $token');
    print('fetchTenant(); $userId');

    try {
      final profile = await profileController.loadUserProfile(context);
      if (profile) {
        final response =
            await apiService.getTenant(token: token, userId: userId);
      }
      _isLoading = true;
      notifyListeners();
    } catch (e) {
      print('Exception $e');
    }
  }
}

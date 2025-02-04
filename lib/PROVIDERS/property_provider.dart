import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rentealm_flutter/models/property_model.dart';
import 'package:rentealm_flutter/networks/apiservice.dart';

import '../CUSTOMS/alert_utils.dart';
import 'auth_provider.dart';

class PropertyProvider extends ChangeNotifier {
  final ApiService apiService = ApiService();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  PropertyResponse? _property;
  PropertyResponse? get property => _property;

  void setProperty(PropertyResponse? property) {
    _property = property;
    notifyListeners();
  }

  Future<void> fetchProperty(BuildContext context) async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    int? userId = authProvider.user?.data?.user.id;
    String? token = authProvider.token;

    if (token != null && userId != null) {
      print("fetchUser(): $userId");
      print("fetchUser(): $token");

      try {
        final response = await apiService.getProperty(token: token);
        if (response != null && response.success) {
          setProperty(property);
        } else {
          print("failed to fetch properties");
          setProperty(null);
        }
      } catch (e) {
        print("Error: $e");
        setProperty(null);

        AlertUtils.showErrorAlert(context,
            title: "Exception", message: "Something went wrong: $e");
      } finally {
        _isLoading = false;
        notifyListeners();
      }
    } else {
      print("Token is null");
      setProperty(null);
    }
  }
}

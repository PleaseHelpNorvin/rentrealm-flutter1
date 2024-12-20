import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rentealm_flutter/controllers/auth_controller.dart';
import '../models/user_model.dart'; // Your User model import
import '../networks/apiservice.dart'; // Assuming you have the API service here
import '../components/alert_utils.dart'; // For showing alerts

class UserController with ChangeNotifier {
  final ApiService apiService = ApiService();

  bool _isLoading = false;
  UserResponse? _user;

  bool get isLoading => _isLoading;
  UserResponse? get user => _user;

  void setUser(UserResponse? user) {
    _user = user;
    notifyListeners();
  }

  // Fetch user data from API - Now taking token and userId as parameters
  Future<void>fetchUser(BuildContext context, String token, int userId) async {
    try {
      _isLoading = true;
      notifyListeners();

      final response = await apiService.getUser(token: token, userId: userId);

      if (response != null && response.success) {
        setUser(response);
      } else {
        // Handle error (maybe show an alert or a message to the user)
        print("Failed to fetch user data");
        AlertUtils.showErrorAlert(context, message: "Failed to fetch user data");
      }
    } catch (e) {
      // Handle error, maybe show an alert
      print("error $e");
      AlertUtils.showErrorAlert(context, title: "Exception", message: "Something went wrong: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}

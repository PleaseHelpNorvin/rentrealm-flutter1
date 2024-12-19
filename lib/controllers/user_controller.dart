import 'package:flutter/material.dart';
import '../models/user_model.dart'; // Your User model import
import '../networks/apiservice.dart'; // Assuming you have the API service here
import '../components/alert_utils.dart'; // For showing alerts

class UserController with ChangeNotifier {
  final apiService = ApiService();

  UserResponse? _user;
  bool _isLoading = false;

  UserResponse? get user => _user;
  bool get isLoading => _isLoading;

  // Set user
  void setUser(UserResponse user) {
    _user = user;
    notifyListeners();
  }

  // Clear user
  void clearUser() {
    _user = null;
    notifyListeners();
  }

  // Handle login logic
  Future<void>loginUser({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      // Assuming you have an ApiService class to handle HTTP requests
      final response =
          await apiService.loginUser(email: email, password: password);

      _isLoading = false;
      notifyListeners();

      if (response != null && response.success) {
        // Access the 'user' and 'token' from the response data
        final userData = response.data;

        if (userData != null) {
          // Save the user data to your UserProvider
          setUser(UserResponse(
           success: response.success,
           message: response.message,
           data: response.data,
          ));

          // Optionally, handle the token here, e.g., save it to local storage
          // String token = userData.token;

          // Show success alert
          AlertUtils.showSuccessAlert(
            context,
            title: 'Login Successful',
            message: response.message ?? 'Welcome!',
          );

          // Delay navigation to let the alert display momentarily
          await Future.delayed(const Duration(seconds: 1));

          Navigator.pushReplacementNamed(context, '/home');
        }
      } else {
        // Show error message if login failed
        AlertUtils.showErrorAlert(
          context,
          title: 'Login Failed',
          message: response?.message ?? 'Invalid credentials or network issue.',
        );
      }
    } catch (e) {
      _isLoading = false;
      notifyListeners();

      // Display an error alert for unexpected exceptions
      AlertUtils.showErrorAlert(
        context,
        title: 'Error',
        message: 'An unexpected error occurred. Please try again.',
      );
    }
  }

  Future<void>registerUser({
    required String name,
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    _isLoading = true;
    notifyListeners();
    try {
      final response = await apiService.registerUser(name: name, email: email, password: password);
      _isLoading = false;
      notifyListeners();
      
      if (response != null && response.success) {
        final userData = response.data;

        if(userData != null) {
          setUser(UserResponse(
            success: response.success,
            message: response.message,
            data: response.data,
          ));

          AlertUtils.showSuccessAlert(
            context,
            title: 'Register Successful',
            message: response.message?? 'Welcome!',
          );
        }
      }

    } catch (e) {
      print('Exception: $e');
      return;
    }
  }
}

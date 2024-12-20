import 'package:flutter/material.dart';
import '../models/user_model.dart'; // Your User model import
import '../networks/apiservice.dart'; // Assuming you have the API service here
import '../components/alert_utils.dart'; // For showing alerts

class AuthController with ChangeNotifier {
  final ApiService apiService = ApiService(); // Instantiate your API service
  bool _isLoading = false; // Loading state to show progress indicators
  UserResponse? _user; // The user data after a successful login

  // Getter for loading state
  bool get isLoading => _isLoading;

  // Getter for user
  UserResponse? get user => _user;

  // Setter for user
  void setUser(UserResponse? user) {
    _user = user;
    print('Setting user: $_user');
    notifyListeners(); // Notify listeners of state changes
  }

  // Login user
  Future<void> loginUser({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    try {
      _isLoading = true;
      notifyListeners(); // Notify the UI about the loading state

      final response = await apiService.loginUser(email: email, password: password);

      if (response != null && response.success) {
        print("from loginUser() : ${response.data}");
        setUser(response); // Update the user data
        AlertUtils.showSuccessAlert(
          context,
          title: 'Login Successful',
          message: 'Welcome, ${response.data?.user.name}!',
          onConfirmBtnTap: () {
            Navigator.pushReplacementNamed(context, '/home',);
          }
        );
        
 
      } else {
        AlertUtils.showErrorAlert(
          context,
          title: 'Login Failed',
          message: response?.message ?? 'An error occurred while logging in.',
        );
      }
    } catch (e) {
      AlertUtils.showErrorAlert(
        context,
        title: 'Error',
        message: 'Something went wrong: $e',
      );
    } finally {
      _isLoading = false;
      notifyListeners(); // Notify the UI that loading is complete
    }
  }

  Future<void>registerUser({
    required String name,
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    try {
      final response = await apiService.registerUser(name: name, email: email, password: password);

      if(response != null && response.success) {
        // uncomment if neeed
        // setUser(response);
        AlertUtils.showSuccessAlert(
          context,
          title: 'Register Successful',
          onConfirmBtnTap: () {
            Navigator.pushReplacementNamed(context, '/login');
          }
        );
      }
    } catch (e) {
      
    }

  }
}

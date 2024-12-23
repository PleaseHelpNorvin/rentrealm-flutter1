import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rentealm_flutter/controllers/profile_controller.dart';
import '../models/user_model.dart'; // Your User model import
import '../networks/apiservice.dart'; // Assuming you have the API service here
import '../components/alert_utils.dart';
import 'user_controller.dart'; // For showing alerts

class AuthController with ChangeNotifier {
  final ApiService apiService = ApiService(); // Instantiate your API service
  bool _isLoading = false; // Loading state to show progress indicators
  UserResponse? _user; // The user data after a successful login
  String? _token;

  // Getter for loading state
  bool get isLoading => _isLoading;

  // Getter for user
  UserResponse? get user => _user;
  String? get token => _token;

  // Setter for user
  void setUser(UserResponse? user) {
    _user = user;
    _token = user?.data?.token;
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
        setUser(response); // Update the user data


        String token = response.data?.token?? '';
        int userId = response.data?.user.id ?? 0;

        final userController = Provider.of<UserController>(context, listen: false);
        await userController.fetchUser(context, token, userId);

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

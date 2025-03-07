import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rentealm_flutter/MODELS/user_model.dart';

// import 'package:rentrealm_flutter2/PROVIDERS/auth_provider.dart';
// import 'package:rentrealm_flutter2/SCREENS/PROFILE/profile.dart';
import '../PROVIDERS/auth_provider.dart';
// import '../SCREENS/PROFILE/profile.dart';

import '../CUSTOMS/alert_utils.dart';
// import '../MODELS/user_model.dart';

import '../NETWORKS/apiservice.dart';
// import '../SCREENS/homelogged.dart';

class UserProvider extends ChangeNotifier {
  final ApiService apiService = ApiService();
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  UserResponse? _user;
  UserResponse? get user => _user;

  String? get userName => _user?.data?.user.name;
  String? get userEmail => _user?.data?.user.email;
  String? get userToken => _user?.data?.token;

  void setUser(UserResponse? user) {
    _user = user;
    notifyListeners();
  }

  Future<void> fetchUser(BuildContext context) async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    int? userId = authProvider.user?.data?.user.id;
    String? token = authProvider.token;

    if (token != null && userId != null) {
      print("fetchUser(): $userId");
      print("fetchUser(): $token");

      try {
        final response = await apiService.getUser(token: token, userId: userId);

        if (response != null && response.success) {
          setUser(response);
          print("fetchUser(): ${response.message}");
        } else {
          print("Failed to fetch user data");
          AlertUtils.showErrorAlert(context,
              message: "Failed to fetch user data");
        }
      } catch (e) {
        print("Error: $e");
        AlertUtils.showErrorAlert(context,
          title: "Exception", message: "Something went wrong: $e"
        );
      }
    } else {}
  }

  Future<void> logoutUser(BuildContext context) async {
    final authController = Provider.of<AuthProvider>(context, listen: false);
    // int? userId = authController.user?.data?.user.id;
    String? token = authController.token;
    if (token != null) {
      print('from logoutUser() $token');
      try {
        _isLoading = true;
        notifyListeners();

        AlertUtils.showLogoutDialog(
          context,
          title: 'Babye :< ',
          message: 'Are you sure you want to log out?',
          onConfirmTap: () async {
            final response = await apiService.postLogout(token);
            if (response) {}
            Navigator.pushReplacementNamed(
                context, '/login'); // Example: navigate to login page
          },
          onCancelTap: () {
            Navigator.pop(context);
          },
        );
      } catch (e) {}
    }
  }

  Future<void> onUpdateUser(
      BuildContext context, String name, String email, String password) async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    final userId = user?.data?.user.id ?? 0;
    final token = authProvider.token ?? 'no token';

    print('onUpdateUser(): $token');
    print('onUpdateUser(): $userId');

    try {
      _isLoading = true;
      notifyListeners();

      final response = await apiService.updateUser(
        id: userId,
        token: token,
        name: name,
        email: email,
        password: password,
      );

      if (response?.success == true) {
        setUser(response);
        AlertUtils.showSuccessAlert(
          context,
          barrierDismissible: false,
          title: "Update Success",
          message: "Your user updated successfully",
          onConfirmBtnTap: () {
            // If you want to navigate to the profile screen after updating:
            // You can directly use Navigator.pop() to go back to the previous screen
            Navigator.pop(
                context); // Go back to ProfileScreen if it was opened via Navigator

            // Alternatively, you can directly update the index if using a bottom navigation bar
            WidgetsBinding.instance.addPostFrameCallback((_) {
              // Navigate back to Profile screen
              Navigator.pop(
                  context); // This will go back to the previous screen, which is Profile.
            });
          },
        );
        print('onUpdateUser: $response');
      } else {
        print('onUpdateUser: $response');
      }
    } catch (e) {}
  }
}

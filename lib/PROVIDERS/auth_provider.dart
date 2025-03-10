// import 'dart:core';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rentealm_flutter/PROVIDERS/pickedRoom_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../CUSTOMS/alert_utils.dart';
import '../MODELS/user_model.dart';
import '../NETWORKS/apiservice.dart';
import '../SCREENS/homelogged.dart';
import 'user_provider.dart';

class AuthProvider extends ChangeNotifier {
  final ApiService apiService = ApiService();
  final UserProvider userProvider = UserProvider();
  // setters
  bool _isLoading = false;
  UserResponse? _user;
  bool _isAuthenticated = false;
  String? _token;
  int? _userId;
  //getters
  bool get isLoading => _isLoading;
  UserResponse? get user => _user;
  String? get token => _token;
  int? get userId => _userId;
  bool isAuthenticated() => _isAuthenticated;

  void setUser(UserResponse? user) {
    _user = user;
    _token = user?.data?.token;
    _userId = user?.data?.user.id;
    notifyListeners();
  }

  void setAuthenticationStatus(bool status) {
    _isAuthenticated = status;
    notifyListeners();
  }

  Future<void> loginUser(
      {required String email,
      required String password,
      required BuildContext context}) async {
    try {
      _isLoading = true;
      notifyListeners();

      final response =
          await apiService.loginUser(email: email, password: password);

      if (response != null && response.success) {
        setUser(response);

        if (token != null && userId != null) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const HomeLoggedScreen()),
          );
        } else {
          AlertUtils.showErrorAlert(context,
              message: "Token or UserId is missing.");
        }
      } else {
        setAuthenticationStatus(false);
        AlertUtils.showErrorAlert(context, message: "Login failed.");
      }
    } catch (e) {
      setAuthenticationStatus(false);
      AlertUtils.showErrorAlert(context,
          title: "Exception", message: "Something went wrong: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
    Future<void> saveRoomId(int roomId) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('roomId', roomId);
  }

  Future<void> registerUser({
    required String name,
    required String email,
    required String password,
    required int roomId,
    required BuildContext context,
  }) async {
    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final pickedRoomProvider = Provider.of<PickedroomProvider>(context, listen: false);

      final response = await apiService.registerUser(
        name: name, email: email, password: password,
      );

      if (response != null && response.success) {
        // ✅ Store token & user ID AFTER successful registration
        authProvider.setUser(response);

        // ✅ Update PickedroomProvider with the new token & userId
        pickedRoomProvider.token = authProvider.token ?? 'no token';
        pickedRoomProvider.userId = authProvider.userId ?? 0;

        setAuthenticationStatus(true);

        // ✅ Call addRoomForUser AFTER setting token & userId
        await pickedRoomProvider.addRoomForUser(roomId);

        // ✅ Navigate to Home
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const HomeLoggedScreen()),
        );
        
      } else {
        setAuthenticationStatus(false);
        print("Registration failed.");
      }
    } catch (e) {
      setAuthenticationStatus(false);
      print("Error in registerUser: $e");
    }
  }
}

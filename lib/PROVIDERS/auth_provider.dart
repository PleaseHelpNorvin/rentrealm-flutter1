// import 'dart:core';

import 'package:flutter/material.dart';
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

  Future<void> registerUser(
      {required String name,
      required String email,
      required String password,
      required BuildContext context}) async {
    try {
      final response = await apiService.registerUser(
          name: name, email: email, password: password);

      if (response != null && response.success) {
        setAuthenticationStatus(true);
      } else {
        setAuthenticationStatus(false);
      }
    } catch (e) {
      setAuthenticationStatus(false);
    }
  }
}

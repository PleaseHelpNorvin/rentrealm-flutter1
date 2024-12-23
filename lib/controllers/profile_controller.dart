import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../components/alert_utils.dart';
import '../controllers/auth_controller.dart';
import '../models/profile_model.dart';
import '../networks/apiservice.dart';

class ProfileController with ChangeNotifier {
  final ApiService apiService = ApiService();

  bool _isLoading = false;
  UserProfileResponse? _userProfile;

  bool get isLoading => _isLoading;
  UserProfileResponse? get userProfile => _userProfile;

  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void setUserProfile(UserProfileResponse? profile) {
    _userProfile = profile;
    notifyListeners();
  }

  /// Convert an image to Base64 and include it in profile data
  Future<void> imageConversion(BuildContext context, File image) async {
    try {
      final bytes = await image.readAsBytes(); // Read image file as bytes
      final base64Image = base64Encode(bytes); // Convert to Base64 for API

      final profileData = {
        'profile_picture_url': base64Image,
      };

      final authController = Provider.of<AuthController>(context, listen: false);
      String? token = authController.token;
      int? userId = authController.user?.data?.user.id;

      if (token != null && userId != null) {
        await createUserProfile(context, token, userId, profileData);
      } else {
        AlertUtils.showErrorAlert(context, message: "User not authenticated.");
      }
    } catch (e) {
      print("Image conversion error: $e");
      AlertUtils.showErrorAlert(context, message: "Failed to process the image.");
    }
  }

  /// Create or update user profile
  Future<void> createUserProfile(
      BuildContext context, String token, int userId, Map<String, String> profileData) async {
    try {
      setLoading(true);

      final response = await apiService.postUserProfile(
        token: token,
        userId: userId,
        userProfile: profileData,
      );

      if (response != null && response.success) {
        setUserProfile(response);
        AlertUtils.showSuccessAlert(context, message: "Profile updated successfully!");
      } else {
        AlertUtils.showErrorAlert(context, message: "Failed to update profile.");
        print("Failed to update profile: ${response?.message}");
      }
    } catch (e) {
      print("Error creating/updating profile: $e");
      AlertUtils.showErrorAlert(context, message: "Something went wrong: $e");
    } finally {
      setLoading(false);
    }
  }

  /// Load user profile
  Future<void> loadUserProfile(BuildContext context) async {
    final authController = Provider.of<AuthController>(context, listen: false);
    int? userId = authController.user?.data?.user.id;
    String? token = authController.token;

    if (token != null && userId != null) {
      try {
        await fetchUserProfile(context, token: token, userId: userId);
      } catch (e) {
        print("Error loading user profile: $e");
        AlertUtils.showErrorAlert(context, message: "Failed to load user profile.");
      }
    } else {
      AlertUtils.showErrorAlert(context, message: "User not authenticated.");
    }
  }

  /// Fetch user profile data
  Future<void> fetchUserProfile(context, {required String token, required int userId}) async {
    try {
      setLoading(true);

      final response = await apiService.getUserProfile(token: token, userId: userId);

      if (response != null && response.success) {
        setUserProfile(response);
        print("User profile Id $userId  fetched successfully:");
      } else {
        setUserProfile(null);
        AlertUtils.showInfoAlert(
          context,
          title: "Profile Not Found",
          message: "Please create your profile first!",
          onConfirmBtnTap: () {
            Navigator.pushReplacementNamed(context, '/createprofile1');
          },
        );
      }
    } catch (e) {
      print("Error fetching user profile: $e");
      AlertUtils.showErrorAlert(context, title: "Error", message: "Something went wrong: $e");
    } finally {
      setLoading(false);
    }
  }
}

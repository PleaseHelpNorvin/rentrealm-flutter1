import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'package:rentealm_flutter/networks/apiservice.dart';
import '../components/alert_utils.dart';
import '../models/profile_model.dart';

class ProfileController with ChangeNotifier{
  final ApiService apiService = ApiService();

  bool _isLoading = false;
  UserProfileResponse? _userProfile;

  UserProfileResponse? get userProfile => _userProfile;

  void setUserProfile(UserProfileResponse? userProfile) {
    _userProfile = userProfile;
    notifyListeners();
  }

  Future<void>imageConversion(BuildContext context, String token, int userId, File image) async {
    try {
      final bytes = await image.readAsBytes(); // Read image file as bytes
      final base64Image = base64Encode(bytes); // Convert to Base64 if required by the API
      
       // Example of sending the image as part of profile data
      final profileData = {
        'profile_picture_url': base64Image, // Include the image in the data payload
      };

       await createUserProfile(context, token, userId, profileData);

    } catch (e) {
        print("Image conversion error: $e");
        AlertUtils.showErrorAlert(context, message: "Failed to process the image.");
    }
  }

  Future<void>createUserProfile(BuildContext context, String token, int userId, Map<String, String> profileData) async {
    try {
      _isLoading = true;
      notifyListeners();
      
      final  response = await apiService.postUserProfile( 
        token: token, userId: userId, userProfile: profileData);

      if(response != null && response.success) {
        setUserProfile(response);
      } else {
        print("Failed to fetch user data");
      }
    } catch (e) {
      print("error $e");
    }
  }

  Future<void>fetchUserProfile(BuildContext context, String token, int userId) async {
    try {
      _isLoading = true;
      notifyListeners();
      
      final response  = await apiService.getUserProfile(token: token, userId: userId);
      if (response != null && response.success) {
        setUserProfile(response);
      } else {
        // Handle error (maybe show an alert or a message to the user)
        print("Failed to fetch user data");
        AlertUtils.showErrorAlert(context, message: "Failed to fetch user data");
      }
    } catch (e) {
      print("error $e");
      AlertUtils.showErrorAlert(context, title: "Exception", message: "Something went wrong: $e");

    }
  }
}
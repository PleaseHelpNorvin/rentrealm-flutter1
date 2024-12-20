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
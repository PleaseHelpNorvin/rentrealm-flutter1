import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rentealm_flutter/networks/apiservice.dart';
import 'package:rentealm_flutter/models/inquiry_model.dart';
import 'package:rentealm_flutter/screens/homelogged.dart';

import 'auth_provider.dart';

class InquiryProvider extends ChangeNotifier{
  final ApiService apiService = ApiService();
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  InquiryResponse? _inquiry;
  InquiryResponse? get inquiry => _inquiry;

  setInquiry(InquiryResponse? inquiry) {
    _inquiry = inquiry;
    notifyListeners();  
  }
  
  Future<void> storeInquiry(
    BuildContext context,
    int roomId,
    int profileId,
    bool isPetEnabled,
    bool isWifiEnabled,
    bool isLaundryAccess,
    bool hasPrivateFridge,
    bool hasSmartTV,
  ) async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final token = authProvider.token;

    print("$token");
    print("roomId $roomId");
    print("profileID $profileId");
    print("isPetEnabled $isPetEnabled");
    print("wifiEnabled: $isWifiEnabled");
    print("isLaundryAccess: $isLaundryAccess");
    print("hasPrivateFridge: $hasPrivateFridge");
    print("hasSmartTv: $hasSmartTV");

    final response = await apiService.postInquiry(
      token: token ?? "",
      roomId: roomId,
      profileId: profileId,
      isPetEnabled: isPetEnabled,
      isWifiEnabled: isWifiEnabled,
      isLaundryAccess: isLaundryAccess,
      hasPrivateFridge: hasPrivateFridge,
      hasSmartTV: hasSmartTV,
    );



    if (response != null) {
      print("Inquiry stored successfully");
     
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => HomeLoggedScreen()),
        );
      });

      setInquiry(response); // Update the provider state
    } else {
      print("Failed to store inquiry.");
    }
  }
  
}
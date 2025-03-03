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


  Future<void> fetchInquiryById(BuildContext context, int inquiryId) async {
    print("fetchInquiryById() called"); // Debug log
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    String? token = authProvider.token;

    if (token == null) {
      print("Error: Token is null");
      return;
    }
    _isLoading = true;
    notifyListeners();

    print("inquiryId: $inquiryId");
    print("token: $token");

    try {
      final response = await apiService.getInquiryById(token: token, unquiryId: inquiryId);

      if(response != null) {
        setInquiry(response);
        print("fetched fetchInquiryById() from response");
      }else {
        print("No Inquiry found");
        setInquiry(null);
      }
    } catch (e) {
      print("Error fetching notifications: $e");
      return;
    }finally {
      _isLoading = false;
      notifyListeners();
    }
  }


  
}
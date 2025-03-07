import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rentealm_flutter/networks/apiservice.dart';
import 'package:rentealm_flutter/models/inquiry_model.dart';
import 'package:rentealm_flutter/screens/homelogged.dart';

import '../CUSTOMS/alert_utils.dart';
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
    String name,
    String contactNumber,
    String message,

  ) async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final token = authProvider.token;

    print("$token");
    print("roomId $roomId");
 

    final response = await apiService.postInquiry(
      roomId: roomId,
      name: name,
      contactNumber: contactNumber,
      message: message,

    );



    if (response != null) {
      print("Inquiry stored successfully");
          // Show success alert
      AlertUtils.showSuccessAlert(
        context,
        title: "Success",
        barrierDismissible: false,
        message: "Inquiry sent successfully!",
        onConfirmBtnTap: () {
          Navigator.pop(context); // Navigate back after success
        },
      );
      setInquiry(response); // Update the provider state
    } else {
      print("Failed to store inquiry.");
      AlertUtils.showErrorAlert(
        context,
        title: "Error",
        message: "Failed to send inquiry. Please try again.",
      );
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
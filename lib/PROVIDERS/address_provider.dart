import 'dart:io';
import 'package:flutter/material.dart';
import 'package:rentealm_flutter/networks/apiservice.dart';
import '../MODELS/address_model.dart';

class AddressProvider extends ChangeNotifier {
  final ApiService apiService = ApiService();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  // String? _token;
  // String? get token => _token;

  // Address? _address;
  // Address? get address _address; 

  // void setLoading(bool value) {
  //   _isLoading = value;
  //   notifyListeners();
  // }

  // void setUserProfileAddress(UserProfileResponse)

}
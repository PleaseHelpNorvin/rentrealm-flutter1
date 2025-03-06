import 'dart:ffi';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rentealm_flutter/PROVIDERS/auth_provider.dart';
import 'package:rentealm_flutter/PROVIDERS/profile_provider.dart';
import 'package:rentealm_flutter/networks/apiservice.dart';

class PaymentProvider extends ChangeNotifier {
  final ApiService apiService = ApiService();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  /// 🔹 Store authentication details as instance variables
  late String token;
  late int? profileId;

  /// ✅ Initialize token and profileId (Call this in the beginning)
  void initAuthDetails(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final profileProvider = Provider.of<ProfileProvider>(context, listen: false);

    token = authProvider.token ?? 'no token';
    profileId = profileProvider.userProfile?.data.id;
  }

  Future<void> processPayment(BuildContext context, int inquiryId, int roomId, String startDate, int persons, File signatureStringSvg, double totalPrice) async {
    initAuthDetails(context);

    print('Token: $token, Profile ID: $profileId');

    if (token == 'no token' || profileId == null) {
      print("Error: Missing authentication details");
      return;
    }
    
    
    
  }
}

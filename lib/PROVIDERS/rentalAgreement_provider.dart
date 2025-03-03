import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rentealm_flutter/PROVIDERS/auth_provider.dart';
import 'package:rentealm_flutter/models/inquiry_model.dart';
import '../networks/apiservice.dart';

class RentalagreementProvider extends ChangeNotifier {
  final ApiService apiService = ApiService();


  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<void>storeRentalAgreement({
    required int inquiryId,
    required double deposit,
    required String signatureSvgString,
  }) async {
    print("inquiryId: $inquiryId");
    print("deposit: $deposit");
    print("signatureSvgString: $signatureSvgString");


  }
}
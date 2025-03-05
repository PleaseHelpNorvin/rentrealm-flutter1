import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rentealm_flutter/PROVIDERS/auth_provider.dart';
import 'package:rentealm_flutter/PROVIDERS/payment_provider.dart';
import 'package:rentealm_flutter/models/inquiry_model.dart';
import '../networks/apiservice.dart';
import 'profile_provider.dart';

class RentalagreementProvider extends ChangeNotifier {
  final ApiService apiService = ApiService();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  late String token;
  late int? profileId;

  void initAuthDetails(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final profileProvider = Provider.of<ProfileProvider>(context, listen: false);

    token = authProvider.token ?? 'no token';
    profileId = profileProvider.userProfile?.data.id;
  }

  
  Future<void> storeRentalAgreement(
    BuildContext context, 
    int inquiryId, 
    int roomId, 
    String startDate, // String input
    int persons, 
    String signatureStringSvg, 
    double totalPrice,
    String? description,
  ) async {
    initAuthDetails(context);

    print('Token: $token, Profile ID: $profileId');

    if (token == 'no token' || profileId == null) {
      print("Error: Missing authentication details");
      return;
    }

    final response = await apiService.postRentalAgreement(
      token: token,
      inquiryId: inquiryId,
      rentStartDate: startDate, 
      personCount: persons,
      totalMonthlyDue: totalPrice,
      description: description,
      svgSignatureString: signatureStringSvg
    );

    if (response != null || response!.success) {
      PaymentProvider paymentProvider = PaymentProvider();
      await paymentProvider.processPayment(context, inquiryId, roomId, startDate, persons, signatureStringSvg, totalPrice);
    } else {
      print("payment field");
    }
  }



}
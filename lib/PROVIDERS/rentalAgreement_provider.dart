import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rentealm_flutter/PROVIDERS/auth_provider.dart';
// import 'package:rentealm_flutter/models/inquiry_model.dart';


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
  String startDate,
  int persons,
  File signaturePngString,
  double totalPrice,
  String? description,
) async {
  initAuthDetails(context);

  if (token == 'no token' || profileId == null) {
    print("Error: Missing authentication details");
    return;
  }

  // Now that you have the file, call your API with the file
  final response = await apiService.postRentalAgreement(
    token: token,
    inquiryId: inquiryId,
    rentStartDate: startDate,
    personCount: persons,
    totalMonthlyDue: totalPrice,
    description: description,
    svgSignatureString: signaturePngString, // Send the File object here
  );

  if (response != null && response.success) {
    print("Success response from storeRentalAgreement()");
  } else {
    print("Payment failed");
  }
}



}

import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rentealm_flutter/PROVIDERS/auth_provider.dart';
import 'package:rentealm_flutter/PROVIDERS/payment_provider.dart';
// import 'package:rentealm_flutter/models/inquiry_model.dart';
import '../models/property_model.dart';


import '../Models/rentalAgreement_model.dart';
import '../networks/apiservice.dart';
import 'profile_provider.dart';

class RentalagreementProvider extends ChangeNotifier {
  final ApiService apiService = ApiService();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  late String token;
  late int? profileId;

  // List<RentalAgreement> _rentalAgreementData = [];


  void initAuthDetails(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final profileProvider = Provider.of<ProfileProvider>(context, listen: false);

    token = authProvider.token ?? 'no token';
    profileId = profileProvider.userProfile?.data.id;
  }

Future<void> storeRentalAgreement(
  BuildContext context,
  int reservationId,
  int roomId,
  String startDate,
  int persons,
  File signaturePngString,
  double totalPrice,
  String? description,
) async {
  initAuthDetails(context);
  print("from storeRentalAgreement()");
  print('Token: $token, Profile ID: $profileId');

  print("reservationId: $reservationId");
  print("reservationId: $roomId");
  print("reservationId: $startDate");
  print("reservationId: $persons");
  print("reservationId: ${signaturePngString.path}");
  print("reservationId: $totalPrice");
  print("reservationId: $description");
  print("reservationId: $reservationId");

  if (token == 'no token' || profileId == null) {
    print("Error: Missing authentication details");
    return;
  }

  // Now that you have the file, call your API with the file
  final response = await apiService.postRentalAgreement(
    token: token,
    reservationId: reservationId,
    rentStartDate: startDate,
    personCount: persons,
    totalMonthlyDue: totalPrice,
    description: description,
    svgSignatureString: signaturePngString, // Send the File object here
  );

  if (response != null && response.success)  {

    int rentalagreementId = response.rentalAgreements.first.id; 

    print("Rental Agreement ID: $rentalagreementId");

    final paymentProvider = Provider.of<PaymentProvider>(context, listen:  false);    
    print("Success response from storeRentalAgreement()");
    await paymentProvider.processPayment(context, reservationId, roomId, rentalagreementId, startDate, persons, totalPrice);
  }
   else {
   print("Strong rental agreement failed");
  }
}



}

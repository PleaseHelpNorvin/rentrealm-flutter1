import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'package:rentealm_flutter/PROVIDERS/auth_provider.dart';
// import 'package:rentealm_flutter/PROVIDERS/dashboard_provider.dart';
import 'package:rentealm_flutter/PROVIDERS/payment_provider.dart';
// import 'package:rentealm_flutter/models/inquiry_model.dart';
// import '../models/property_model.dart';

// import '../Models/rentalAgreement_model.dart';
import '../models/rentalAgreement_model.dart';
import '../networks/apiservice.dart';
import 'profile_provider.dart';

class RentalagreementProvider extends ChangeNotifier {
  final ApiService apiService = ApiService();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  late String token;
  late int? profileId;

  // Private List to Store Rental Agreements
  List<RentalAgreement> _rentalAgreements = [];

  // Getter to access the rental agreements
  List<RentalAgreement> get rentalAgreements => _rentalAgreements;

  // Setter to update rental agreements and notify listeners
  void setRentalAgreements(List<RentalAgreement> agreements) {
    _rentalAgreements = agreements;
    notifyListeners(); // Notify UI to rebuild
  }

  String? _pdfUrl;

  String? get pdfUrl => _pdfUrl;

  void _setPdfUrl(String url) {
    _pdfUrl = url;
    notifyListeners();
  }

  void initAuthDetails(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final profileProvider =
        Provider.of<ProfileProvider>(context, listen: false);

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
    String paymentDescription,
    bool isAdvancePaymentChecked,
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
    print("reservationId: $isAdvancePaymentChecked");

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
      isAdvancePaymentChecked: isAdvancePaymentChecked,
      svgSignatureString: signaturePngString, // Send the File object here
    );

    if (response != null && response.success) {
      int rentalagreementId = response.rentalAgreements.first.id;
      print("Rental Agreement ID: $rentalagreementId");

      final paymentProvider =
          Provider.of<PaymentProvider>(context, listen: false);
      print("Success response from storeRentalAgreement()");
      await paymentProvider.processPayment(
          context,
          reservationId,
          roomId,
          rentalagreementId,
          startDate,
          persons,
          totalPrice,
          paymentDescription);
    } else {
      print("Store rental agreement failed");
    }
  }

  Future<void> fetchIndexRentalAgreement(BuildContext context) async {
    initAuthDetails(context);

    print("from fetchIndexRentalAgreement(): $token");
    print("from from fetchIndexRentalAgreement(): $profileId");

    final response = await apiService.getIndexRentalAgreementByProfileId(
        token: token, profileId: profileId);
    if (response != null && response.success) {
      print("Fetched ${response.rentalAgreements.length} rental agreements.");

      _rentalAgreements = response.rentalAgreements;
      notifyListeners();
    }
  }

  Future<void> fetchRentalAgreementUrl(
      BuildContext context, String agreementCode) async {
    initAuthDetails(context);
    print("from fetchIndexRentalAgreement(): $token");
    print("from from fetchIndexRentalAgreement(): $agreementCode");

    final response = await apiService.getRentalAgreementUrl(
        token: token, agreementCode: agreementCode);

    if (response != null && response.success) {
      _setPdfUrl(response.data.pdfUrl); // Update private field using setter
      print("PDF URL fetched: $_pdfUrl");
    } else {
      print("Failed to fetch PDF URL");
    }
  }

  Future<void> fetchActiveRentalAgreementByProfileId(
      BuildContext context) async {
    initAuthDetails(context);
    _isLoading = true;
    notifyListeners();

    print("from fetchActiveRentalAgreementByProfileId(): $token");

    if (token == 'no token' || profileId == null) {
      print("Error: Missing authentication details");
      return;
    }

    final response = await apiService.getActiveRentalAgreementByProfileId(
        profileId: profileId, token: token);

    if (response != null && response.success) {
      setRentalAgreements(response.rentalAgreements);
      print(
          "response from fetchActiveRentalAgreementByProfileId(): ${response.rentalAgreements.length}");
    } else {
      print("Failed to fetch active students");
    }

    _isLoading = false;
    notifyListeners();
  }
}

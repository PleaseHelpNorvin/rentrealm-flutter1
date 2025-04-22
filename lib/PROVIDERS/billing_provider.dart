import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rentealm_flutter/PROVIDERS/rentalAgreement_provider.dart';
// import 'package:rentealm_flutter/NETWORKS/apiservice.dart';
//
import 'package:rentealm_flutter/PROVIDERS/tenant_provider.dart';

import '../models/billing_model.dart';
import '../networks/apiservice.dart';
import 'auth_provider.dart';
import 'profile_provider.dart';

class BillingProvider extends ChangeNotifier {
  final ApiService apiService = ApiService();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  late String token;
  late int? profileId;
  late int userId;

  Billing? _billing;

  // Getter: Get the billing object
  Billing? get billing => _billing;

  // Setter: Update the billing object
  set billing(Billing? newBilling) {
    _billing = newBilling;
    notifyListeners();
  }

  // Private Billing List
  List<Billing> _billings = [];

  // Getter: Get billing list
  List<Billing> get billings => _billings;

  // Setter: Update billing list
  set billings(List<Billing> newBillings) {
    _billings = newBillings;
    notifyListeners();
  }

  void initAuthDetails(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final profileProvider =
        Provider.of<ProfileProvider>(context, listen: false);

    token = authProvider.token ?? 'no token';
    profileId = profileProvider.userProfile?.data.id;
    if (authProvider.userId == null) {
      throw Exception('User ID is null. Cannot proceed.');
    }

    userId = authProvider.userId!;
  }

  Future<void> fetchBillingForRentalAgreement(BuildContext context) async {
    initAuthDetails(context);
    print("from fetchBillingForRentalAgreement() $token");
    print("from fetchBillingForRentalAgreement() $profileId");

    print("from fetchBillingForRentalAgreement() ");

    // await response = await apiService.getBillingForRentalAgreement(token: token, rentalAgreementId: );
  }

  Future<void> fetchLatestMonthlyRentBilling(BuildContext context) async {
    initAuthDetails(context);
    print("from fetchLatestMonthlyRentBilling() token: $token ");
    print("from fetchLatestMonthlyRentBilling() profileId: $profileId ");
    print("from fetchLatestMonthlyRentBilling() userId: $userId ");

    final response = await apiService.getLatestMonthlyRentBilling(
      token: token,
      userId: userId, // now guaranteed non-null
    );

    if (response != null && response.success) {
      _billing = response.data.latestRentBilling;

      print(
          'from fetchLatestMonthlyRentBilling single Billing getter : ${billing?.billingMonth}');
      // } else {
      // print("❌ billing is null!");
      // Optionally handle error state or show dialog
    }
  }
}

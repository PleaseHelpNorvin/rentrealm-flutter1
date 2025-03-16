import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rentealm_flutter/PROVIDERS/rentalAgreement_provider.dart';
// import 'package:rentealm_flutter/NETWORKS/apiservice.dart';
//
import 'package:rentealm_flutter/PROVIDERS/tenant_provider.dart';

import '../networks/apiservice.dart';
import 'auth_provider.dart';
import 'profile_provider.dart';

class BillingProvider extends ChangeNotifier {
  final ApiService apiService = ApiService();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  late String token;
  late int? profileId;

  void initAuthDetails(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final profileProvider =
        Provider.of<ProfileProvider>(context, listen: false);

    token = authProvider.token ?? 'no token';
    profileId = profileProvider.userProfile?.data.id;
  }

  Future<void> fetchBillingForRentalAgreement(BuildContext context) async {
    initAuthDetails(context);
    print("from fetchBillingForRentalAgreement() $token");
    print("from fetchBillingForRentalAgreement() $profileId");

    // final rentalAgreementProvder = Provider.of<RentalagreementProvider>(context, listen: false);
    // int? rentalAgreementId = rentalAgreementProvder.

    // if (profileId) {

    // }

    print("from fetchBillingForRentalAgreement() ");

    // await response = await apiService.getBillingForRentalAgreement(token: token, rentalAgreementId: );
  }
}

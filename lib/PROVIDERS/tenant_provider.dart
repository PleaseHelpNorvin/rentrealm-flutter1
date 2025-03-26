import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../MODELS/tenant_model.dart';
// import '../CUSTOMS/alert_utils.dart';
import '../networks/apiservice.dart';
import 'auth_provider.dart';
import 'profile_provider.dart';

class TenantProvider extends ChangeNotifier {
  final ApiService apiService = ApiService();
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  TenantResponse? _tenant; // Nullable type here
  TenantResponse? get tenant => _tenant;

  void setTenant(TenantResponse? tenant) {
    // Nullable type here
    _tenant = tenant;
    notifyListeners();
  }

  Future<void> fetchTenant(BuildContext context) async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final profileProvider =
        Provider.of<ProfileProvider>(context, listen: false);
    int? profileId = profileProvider.userProfile?.data.id;
    String? token = authProvider.token;

    if (token != null && profileId != null) {
      print("fetchTenant(): profileId: $profileId");
      print("fetchTenant(): token: $token");

      try {
      // _isLoading = true;
      // notifyListeners(); 
      final response = await apiService.getTenantByProfileId(profileId: profileId, token: token);
      if (response != null && response.success) {
        print("responseData from getTenant Call: ${response.data.latestBilling.}");
        print("responseData from getTenant Call: ${response.data.maintenanceRequests}");
        print("responseData from getTenant Call: ${response.data.nextBillingMonth}");
        print("responseData from getTenant Call: ${response.data.tenant}");
      }

      } catch (e) {
        print("EXCEPTION: $e");
      }

      



      
    }
  }

}
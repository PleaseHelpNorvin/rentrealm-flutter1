import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// import '../MODELS/tenant_model.dart';
import '../models/tenant_model.dart';
import '../networks/apiservice.dart';
import 'auth_provider.dart';
import 'profile_provider.dart';

class TenantProvider extends ChangeNotifier {
  final ApiService apiService = ApiService();
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  TenantResponse? _tenant;
  TenantBilling? _latestBilling; // Updated to match the actual model name
  List<TenantMaintenanceRequest> _maintenanceRequests = []; // Updated type
  String? _nextBillingMonth;
  RentalAgreement? _rentalAgreement;

  // Getters
  TenantResponse? get tenant => _tenant;
  TenantBilling? get latestBilling => _latestBilling;
  List<TenantMaintenanceRequest> get maintenanceRequests =>
      _maintenanceRequests;
  String? get nextBillingMonth => _nextBillingMonth;
  RentalAgreement? get rentalAgreement => _rentalAgreement;

  // Setters
  void setTenant(TenantResponse? tenant) {
    _tenant = tenant;
    if (tenant != null) {
      _latestBilling = tenant.data.latestBilling;
      // _maintenanceRequests = tenant.data.tenantMaintenanceRequest; // Fixed
      _nextBillingMonth = tenant.data.nextBillingMonth;
      _rentalAgreement = tenant.data.tenant.rentalAgreement;
      print("setTenant() reached!");
    }
    notifyListeners();
  }

  Future<void> fetchTenant(BuildContext context) async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final profileProvider =
        Provider.of<ProfileProvider>(context, listen: false);

    int? profileId = profileProvider.userProfile?.data.id;
    String? token = authProvider.token;

    // ✅ Avoid fetching again if tenant data already exists
    if (_tenant != null) {
      print("Tenant data already exists, skipping fetch.");
      return;
    }

    if (token != null && profileId != null) {
      print("fetchTenant(): profileId: $profileId");
      print("fetchTenant(): token: $token");

      _isLoading = true;
      notifyListeners();

      try {
        final response = await apiService.getTenantByProfileId(
          profileId: profileId,
          token: token,
        );
        if (response != null && response.success) {
          print(
              "responseData from fetchTenant Call: ${response.data.latestBilling?.billingMonth}");
          // print(
              // "responseData from fetchTenant Call: ${response.data.tenantMaintenanceRequest.first.description}");
          print(
              "responseData from fetchTenant Call: ${response.data.nextBillingMonth}");
          print(
              "responseData from fetchTenant Call: ${response.data.tenant.rentalAgreement.agreementCode}");
          setTenant(response);

          _rentalAgreement = response.data.tenant.rentalAgreement;
          notifyListeners();
        }
      } catch (e) {
        print("EXCEPTION: $e");
      } finally {
        _isLoading = false;
        notifyListeners();
      }
    }
  }
}

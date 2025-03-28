import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rentealm_flutter/PROVIDERS/auth_provider.dart';
import 'package:rentealm_flutter/PROVIDERS/profile_provider.dart';
import 'package:rentealm_flutter/networks/apiservice.dart';
// import 'rentalAgreement_provider.dart'; // Ensure correct import

class DashboardProvider extends ChangeNotifier {
  final ApiService apiService = ApiService();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  // Stores dashboard data
  Map<String, dynamic> _dashboardData = {};
  
  // Getter for dashboard data
  Map<String, dynamic> get dashboardData => _dashboardData;

  late String token;
  late int? profileId;

  // Update dashboard data when a new agreement is selected
  void updateDashboardData(Map<String, dynamic> newData) {
    _dashboardData = newData;
    notifyListeners(); // Notify UI to rebuild with new data
  }

  // Clear dashboard data (optional, useful for logout)
  void clearDashboardData() {
    _dashboardData = {};
    notifyListeners();
  }

  void initAuthDetails(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final profileProvider =
        Provider.of<ProfileProvider>(context, listen: false);

    token = authProvider.token ?? 'no token';
    profileId = profileProvider.userProfile?.data.id;
  }

  Future<void> changeTheDashboardToUseThePickedApprovedAgreement(
      BuildContext context, int agreementId) async {
    try {
      // Step 1: Initialize authentication details and retrieve token
      initAuthDetails(context);

      // Step 2: Fetch dashboard data for the selected agreement
      var newDashboardData = await apiService.getDashboardData(
        rentalAgreementId: agreementId,
        token: token,
      );

      // Step 3: Update the dashboard if data retrieval was successful
      if (newDashboardData != null && newDashboardData.success) {
        updateDashboardData(newDashboardData.toJson()); // Ensure this function is correctly defined
      }

      // Step 4: Notify UI
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Dashboard updated for selected agreement!")),
      );
    } catch (e) {
      // Handle errors and notify user
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to update dashboard: $e")),
      );
    }
  }
}

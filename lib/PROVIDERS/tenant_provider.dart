import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// import 'package:rentealm_flutter/MODELS/tenant_model.dart';
// import 'package:rentealm_flutter/models/tenant_model.dart';
import '../MODELS/tenant_model.dart';
import '../CUSTOMS/alert_utils.dart';
import '../NETWORKS/apiservice.dart';
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

      // try {
      // _isLoading = true;
      // notifyListeners();

      // Make API call
      final response =
          await apiService.getTenant(profileId: profileId, token: token);

      if (response != null && response.success) {
        setTenant(response as TenantResponse?);
        // setTenant(response); // Here, response is of type TenantResponse, which is nullable
        print("fetchTenant(): ${response.message}");
      } else {
        print("Failed to fetch tenant data");
        // setTenant(null); // Handle failure by setting tenant to null
        Future.microtask(() {
          Navigator.pushNamed(context, '/createtenant1');
        });
      }
      // } catch (e) {
      //   print("Error: $e");
      //   // setTenant(null); // Handle errors by setting tenant to null
      //   AlertUtils.showErrorAlert(context, title: "Exception", message: "Something went wrong: $e");
      // } finally {
      //   _isLoading = false; // Reset loading state after the operation
      //   notifyListeners();
      // }
    } else {
      print("Token or Profile ID is null.");
      // setTenant(null); // Ensure tenant is set to null if token or profile ID is missing
    }
  }
}

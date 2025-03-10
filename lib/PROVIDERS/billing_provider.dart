import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rentealm_flutter/NETWORKS/apiservice.dart';
import 'package:rentealm_flutter/PROVIDERS/tenant_provider.dart';

import 'auth_provider.dart';

class BillingProvider extends ChangeNotifier {
  final ApiService apiService = ApiService();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<void> fetchBilling(BuildContext context) async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    String? token = authProvider.token;
    final tenantProvider = Provider.of<TenantProvider>(context, listen: false);
    int? tenantId = tenantProvider.tenant?.data.id;
  }
}

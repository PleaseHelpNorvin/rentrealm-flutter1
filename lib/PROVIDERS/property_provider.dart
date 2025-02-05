import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rentealm_flutter/models/property_model.dart';
import 'package:rentealm_flutter/networks/apiservice.dart';

import '../CUSTOMS/alert_utils.dart';
import 'auth_provider.dart';

class PropertyProvider extends ChangeNotifier {
  final ApiService apiService = ApiService();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  List<Property> _properties = [];
  List<Property> get properties => _properties;

  // Fetch property data from API
  Future<void> fetchProperties(BuildContext context) async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);    
    String? token = authProvider.token;

    if (token == null) {
      print('Token is null, cannot fetch properties');
      return;
    }

    _isLoading = true;
    notifyListeners();

    try {
      // Use the token from authProvider here
      final response = await apiService.getProperty(token: token);

      if (response != null) {
        if (response is PropertyResponse) {
          _properties = response.data as List<Property>; 
        } else {
          print('Unexpected response type: ${response.runtimeType}');
          _properties = []; // Fallback to empty list
        }
      } else {
        print('Response is null');
        _properties = [];
      }
    } catch (error) {
      print('Error fetching properties: $error');
      _properties = [];
    }

    _isLoading = false;
    notifyListeners();
  }

}

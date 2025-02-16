import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rentealm_flutter/API/rest.dart';
import 'package:rentealm_flutter/models/property_model.dart';
import 'package:rentealm_flutter/networks/apiservice.dart';

import '../CUSTOMS/alert_utils.dart';
import 'auth_provider.dart';

class PropertyProvider extends ChangeNotifier {
  final ApiService apiService = ApiService();
  // final Rest restUrl = Rest();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  List<Property> _properties = [];
  List<Property> get properties => _filteredProperties.isNotEmpty ? _filteredProperties : _properties;

  List<Property> _filteredProperties = [];


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
      final response = await apiService
          .getProperty(token: token)
          .timeout(Duration(seconds: 15));

      if (response != null) {
        _properties = response.data.map((property) {
          // Clean URL
          // print(property.propertyPictureUrl);
          String imageUrl = property.propertyPictureUrl.isNotEmpty
              ? property.propertyPictureUrl 
              : ''; 
          //for cleaning the image url
          imageUrl = imageUrl
              .replaceAll(RegExp(r'\/\/+'),'/') 
              .replaceAll(RegExp(r'[\[\]""]'),'') 
              .replaceAll(RegExp(r'\\+'), '')
              .replaceAll(RegExp(r'\\\/'), '/')
              .replaceAll('http://127.0.0.1:8000', Rest.baseUrl)
              .replaceAll('/api', '');

          property.propertyPictureUrl =
              imageUrl; // Assign cleaned URL back to the property
          print("Cleaned URL: $imageUrl");
          return property;
        }).toList();
        print("Fetched properties: $_properties");
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

  Future<Image> _loadImage(String url) async {
    try {
      // Try loading the image
      final image = Image.network(url);
      return image;
    } catch (e) {
      print('Error loading image: $e');
      return Image.asset(
          'assets/placeholder.png'); 
    }
  }

  ImageProvider getPropertyImage(String url) {
    return NetworkImage(url); // Return a NetworkImage directly
  }


  void searchProperties(String query)
  {
    if (query.isEmpty) {
      _filteredProperties = _properties;
    } else {
      _filteredProperties = _properties
          .where((property) =>
              property.name.toLowerCase().contains(query.toLowerCase()) ||
              property.genderAllowed.toLowerCase().contains(query.toLowerCase()) ||
              // property.petsAllowed.lo

              property.address.line1.toLowerCase().contains(query.toLowerCase()) || // Use `address.line1`
              property.address.line2.toLowerCase().contains(query.toLowerCase()) ||
              property.address.province.toLowerCase().contains(query.toLowerCase()) ||
              property.address.country.toLowerCase().contains(query.toLowerCase()) ||
              property.address.postalCode.toLowerCase().contains(query.toLowerCase())
          ) // You can also use `province`
          .toList();
    }
    notifyListeners();
  }


}



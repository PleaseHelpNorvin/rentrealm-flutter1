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

  Property? _property;
  Property? get property => _property;

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
        String imageUrl = property.propertyPictureUrl is List<String>
            ? property.propertyPictureUrl[0]  // Access first element of list
            : property.propertyPictureUrl as String; // Fallback if it's a string

        // Clean the image URL
        imageUrl = imageUrl
            .replaceAll(RegExp(r'http://127.0.0.1:8000/'), Rest.baseUrl)  // Correct the pattern here
            .replaceAll(RegExp(r'api'), '');
            // .replaceAll(RegExp(r'\/\/+'), '/')
            // .replaceAll(RegExp(r'[\[\]""]'), '')
            // .replaceAll(RegExp(r'\\+'), '')
            // .replaceAll(RegExp(r'\\\/'), '/')
            // .replaceAll('http://127.0.0.1:8000', Rest.baseUrl)
            // .replaceAll('/api', '');

        // Reassign cleaned URL as a List<String>
        property.propertyPictureUrl = [imageUrl]; // Store cleaned URL in a list

        print("Cleaned URL: $imageUrl");
        return property;
      }).toList();
      print("Fetched properties: ${_properties.first.propertyPictureUrl}");
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


Future<Property?> fetchPropertyById(BuildContext context, int id) async {
  final authProvider = Provider.of<AuthProvider>(context, listen: false);
  String? token = authProvider.token;

  if (token == null) {
    print('Token is null, cannot fetch property');
    return null;
  }

  _isLoading = true;
  notifyListeners();

  try {
    final response = await apiService.getPropertyById(token: token, propertyId: id);

    if (response != null && response.data != null) {
      Property property = response.data.first;

        if (property != null) {
          print("Fetched Property: ${property.name}");
          print("Property ID: ${property.id}");
          print("Image URL: ${property.propertyPictureUrl}");
        } else {
          print("No property found.");
        }
        
      // Clean URL logic
      property.propertyPictureUrl = property.propertyPictureUrl;

      _isLoading = false;
      notifyListeners();
      return property; // ✅ Return the fetched property
    } else {
      print('Response is null');
      _isLoading = false;
      notifyListeners();
      return null;
    }
  } catch (error) {
    print('Error fetching property: $error');
    _isLoading = false;
    notifyListeners();
    return null;
  }
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

extension on List<String> {
  replaceAll(RegExp regExp, String s) {}
}



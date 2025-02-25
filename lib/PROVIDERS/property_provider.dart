import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rentealm_flutter/API/rest.dart';
import 'package:rentealm_flutter/models/property_model.dart';
import 'package:rentealm_flutter/networks/apiservice.dart';

import '../CUSTOMS/alert_utils.dart';
import 'auth_provider.dart';

class PropertyProvider extends ChangeNotifier {
  final ApiService apiService = ApiService();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  List<Property> _properties = [];
  List<Property> _searchProperties = [];

  // Getter for properties list
  List<Property> get properties =>
      _searchProperties.isNotEmpty ? _searchProperties : _properties;

  // Getter for search properties (for UI)
  List<Property> get searchProperties => _searchProperties;

  Property? _property;
  Property? get property => _property;

  Future<void> fetchProperties(BuildContext context) async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await apiService.getProperty().timeout(Duration(seconds: 15));

      if (response?.data != null) {
        _properties = response!.data.map<Property>((property) {
          property.propertyPictureUrl = _cleanImageUrls(property.propertyPictureUrl);
          return property;
        }).toList();
      } else {
        _properties = [];
      }
    } catch (error) {
      print('Error fetching properties: $error');
      _properties = [];
    }

    _isLoading = false;
    notifyListeners();
  }

  // Extracted method to clean image URLs
  List<String> _cleanImageUrls(dynamic propertyPictureUrl) {
    if (propertyPictureUrl is List<String>) {
      return propertyPictureUrl
          .map((url) => url
              .replaceAll(RegExp(r'http://127.0.0.1:8000/'), Rest.baseUrl)
              .replaceAll(RegExp(r'api'), ''))
          .toList();
    } else if (propertyPictureUrl is String) {
      return [
        propertyPictureUrl
            .replaceAll(RegExp(r'http://127.0.0.1:8000/'), Rest.baseUrl)
            .replaceAll(RegExp(r'api'), '')
      ];
    }
    return [];
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
      return Image.network(url);
    } catch (e) {
      print('Error loading image: $e');
      return Image.asset('assets/placeholder.png');
    }
  }

  ImageProvider getPropertyImage(String url) {
    return NetworkImage(url);
  }

  void filterProperties(String selectedGender, String selectedType, bool? isPet) {
    print("Filtering with:");
    print("Selected Gender: $selectedGender");
    print("Selected Type: $selectedType");
    print("IsPet?: $isPet");

    _searchProperties = _properties.where((property) {
      bool matchesGender = selectedGender.isEmpty || property.genderAllowed == selectedGender;
      bool matchesType = selectedType.isEmpty ||
          property.type.trim().toLowerCase() == selectedType.trim().toLowerCase();
      bool matchesPets = isPet == null || property.petsAllowed == isPet;

      return matchesGender && matchesType && matchesPets;
    }).toList();

    print("Filtered Properties Count: ${_searchProperties.length}");

    notifyListeners();
  }

  void searchForProperties(String query) {
    if (query.isEmpty) {
      _searchProperties = _properties;
    } else {
      final lowerQuery = query.toLowerCase();

      _searchProperties = _properties.where((property) {
        return (property.address.line1)
                .toLowerCase()
                .contains(lowerQuery) ||
            (property.address.line2).toLowerCase().contains(lowerQuery) ||
            (property.address.province)
                .toLowerCase()
                .contains(lowerQuery) ||
            (property.address.country)
                .toLowerCase()
                .contains(lowerQuery) ||
            (property.address.postalCode)
                .toLowerCase()
                .contains(lowerQuery);
      }).toList();
    }

    notifyListeners();
  }
}

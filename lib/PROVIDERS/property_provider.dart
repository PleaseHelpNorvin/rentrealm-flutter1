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
  List<Property> get properties =>
      _searchProperties.isNotEmpty ? _searchProperties : _properties;

  List<Property> _searchProperties = [];
  List<Property> get searchProperties =>
      _searchProperties.isNotEmpty ? _searchProperties : _properties;

  // List<Property> get searchProperties => _searchProperties; // Getter remains

  // List<Property>
  // List<Property> _filteredProperties = [];

  Property? _property;
  Property? get property => _property;
  // List<>
  Future<void> fetchProperties(BuildContext context) async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    String? token = authProvider.token;

    // if (token == null) {
    //   print('Token is null, cannot fetch properties');
    //   return;
    // }

    _isLoading = true;
    notifyListeners();

    try {
      final response =
          await apiService.getProperty().timeout(Duration(seconds: 15));

      if (response != null) {
        _properties = response.data.map((property) {
          // Clean URL
          String imageUrl = property.propertyPictureUrl is List<String>
              ? property.propertyPictureUrl[0] // Access first element of list
              : property.propertyPictureUrl
                  as String; // Fallback if it's a string

          // Clean the image URL
          imageUrl = imageUrl
              .replaceAll(RegExp(r'http://127.0.0.1:8000/'),
                  Rest.baseUrl) // Correct the pattern here
              .replaceAll(RegExp(r'api'), '');
          // .replaceAll(RegExp(r'\/\/+'), '/')
          // .replaceAll(RegExp(r'[\[\]""]'), '')
          // .replaceAll(RegExp(r'\\+'), '')
          // .replaceAll(RegExp(r'\\\/'), '/')
          // .replaceAll('http://127.0.0.1:8000', Rest.baseUrl)
          // .replaceAll('/api', '');

          // Reassign cleaned URL as a List<String>
          property.propertyPictureUrl = [
            imageUrl
          ]; // Store cleaned URL in a list

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
      final response =
          await apiService.getPropertyById(token: token, propertyId: id);

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
      return Image.asset('assets/placeholder.png');
    }
  }

  ImageProvider getPropertyImage(String url) {
    return NetworkImage(url); // Return a NetworkImage directly
  }

  void filterProperties(
      String selectedGender, String selectedType, bool? isPet) {
    print("Filtering with:");
    print("Selected Gender: $selectedGender");
    print("Selected Type: $selectedType");
    print("IsPet?: $isPet");

    List<Property> filteredProperties = properties.where((property) {
      bool matchesGender =
          selectedGender.isEmpty || property.genderAllowed == selectedGender;
      bool matchesType = selectedType.isEmpty ||
          property.type.trim().toLowerCase() ==
              selectedType.trim().toLowerCase();
      bool matchesPets = isPet == null || property.petsAllowed == isPet;

      print("Checking property:");
      print(
          "Gender: ${property.genderAllowed}, Type: ${property.type}, Pets: ${property.petsAllowed}");
      print(
          "Matches Gender: $matchesGender, Matches Type: $matchesType, Matches Pets: $matchesPets");
      print("Property Types Available:");
      _properties.forEach((property) => print(property.type));

      return matchesGender && matchesType && matchesPets;
    }).toList();

    print("Filtered Properties Count: ${filteredProperties.length}");

    // Updating the list of search results
    _searchProperties = filteredProperties;
    notifyListeners();
  }

  void searchForProperties(String query) {
    if (query.isEmpty) {
      _searchProperties = _properties;
    } else {
      final lowerQuery = query.toLowerCase();

      _searchProperties = _properties.where((property) {
        return (property.address.line1 ?? "")
                .toLowerCase()
                .contains(lowerQuery) ||
            (property.address.line2 ?? "").toLowerCase().contains(lowerQuery) ||
            (property.address.province ?? "")
                .toLowerCase()
                .contains(lowerQuery) ||
            (property.address.country ?? "")
                .toLowerCase()
                .contains(lowerQuery) ||
            (property.address.postalCode ?? "")
                .toLowerCase()
                .contains(lowerQuery);
      }).toList();
    }
    notifyListeners();
  }
}

extension on List<String> {
  replaceAll(RegExp regExp, String s) {}
}

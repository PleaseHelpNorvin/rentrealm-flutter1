import 'package:flutter/material.dart';
import 'package:rentealm_flutter/API/rest.dart';

import './address_model.dart';

class PropertyResponse {
  final bool success;
  final String message;
  final List<Property> data;

  PropertyResponse(
      {required this.success, required this.message, required this.data}
  );

  factory PropertyResponse.fromJson(Map<String, dynamic> json) {
    var rawData = json['data'];

    List<Property> parsedData = [];

    if (rawData == null) {
      print("Response `data` is null");
    } else if (rawData is Map<String, dynamic> && rawData.containsKey('properties')) {
      // ✅ Extract properties list from data
      parsedData = (rawData['properties'] as List)
          .map((item) => Property.fromJson(item))
          .toList();
    } else {
      print("Unexpected response format: ${rawData.runtimeType}");
    }

    return PropertyResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: parsedData,
    );
  }


}

class Property {
  final int id;
  final String name;
  List<String> propertyPictureUrl;
  final String genderAllowed;
  final bool petsAllowed;
  final String type;
  final String status;
  final String createdAt;
  final String updatedAt;
  final Address address;

  Property({
    required this.id,
    required this.name,
    required this.propertyPictureUrl,
    required this.genderAllowed,
    required this.petsAllowed,
    required this.type,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.address,
  });

  factory Property.fromJson(Map<String, dynamic> json) {
    // Handle property_picture_url properly
    var propertyPicture = json['property_picture_url'];
    List<String> propertyPictureUrl;

    // If it's a single string, make it a list
    if (propertyPicture is String) {
        propertyPictureUrl = [propertyPicture.replaceAll('http:/127.0.0.1:8000', Rest.baseUrl).replaceAll('api', '')];

    } else if (propertyPicture is List) {
      propertyPictureUrl = List<String>.from(
         propertyPicture.map((url) => url.replaceAll('http:/127.0.0.1:8000', Rest.baseUrl).replaceAll('api', ''))
      );
    } else {
      propertyPictureUrl = [];
    }

    return Property(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      propertyPictureUrl: propertyPictureUrl,  // Corrected here
      genderAllowed: json['gender_allowed'] ?? '',
      petsAllowed: json['pets_allowed'] == 1,
      type: json['type'] ?? '',
      status: json['status'] ?? '',
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
      address: json['address'] != null
          ? Address.fromJson(json['address'])
          : Address(
              line1: '',
              line2: '',
              province: '',
              country: '',
              postalCode: '',
              lat: 0.0,
              long: 0.0,
            ),
    );
  }

}

//gender
final Map<String, Color> genderColors = {
  "boys-only": Color.fromARGB(255, 30, 0, 253),
  "girls-only": Color(0xFFFF005D)
};

final Map<String, String> genderLabels = {
  "boys-only": "Boys",
  "girls-only": "Girls"
};

//status
final Map<String, Color> statusColors = {
  "available": Color(0xFF00FF26), // Green
  "rented": Color(0xFFFFA500), // Orange
  "full": Color(0xFFFF005D), // Red
};

final Map<String, String> statusLabels = {
  "available": "Available",
  "rented": "Rented",
  "full": "Full",
};


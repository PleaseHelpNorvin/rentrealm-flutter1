import 'package:flutter/material.dart';

import './address_model.dart';

class PropertyResponse {
  final bool success;
  final String message;
  final List<Property> data;

  PropertyResponse(
      {required this.success, required this.message, required this.data});

  factory PropertyResponse.fromJson(Map<String, dynamic> json) {
    return PropertyResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: (json['data']?['properties'] as List<dynamic>?)
              ?.map((property) => Property.fromJson(property))
              .toList() ??
          [], // Make sure you're accessing 'data' and then 'properties'
    );
  }
}

class Property {
  final int id;
  final String name;
  String propertyPictureUrl;
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
    return Property(
      id: json['id'],
      name: json['name'] ?? '',
      propertyPictureUrl: json['property_picture_url'] ?? '',
      genderAllowed: json['gender_allowed'] ?? '',
      petsAllowed: json['pets_allowed'] == 1,
      type: json['type'] ?? '',
      status: json['status'] ?? '',
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'],
      address: json['address'] != null
          ? Address.fromJson(json['address'])
          : Address(
              line1: '',
              line2: '',
              province: '',
              country: '',
              postalCode: '',
            ), // Default Address if null
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

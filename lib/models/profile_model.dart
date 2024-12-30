import '../models/user_model.dart';

class UserProfile {
  final int userId;
  final String profilePictureUrl; // Changed from File to String
  final String phoneNumber;
  final String socialMediaLinks;
  final String occupation;
  //address part
  final String address;
  final String line_1;
  final String line_2;
  final String province;
  final String country;
  final String postalCode;
  //id part
  final String driverLicenseNumber;
  final String nationalId;
  final String passportNumber;
  final String socialSecurityNumber;
  //
  final DateTime? updatedAt;
  final DateTime? createdAt;
  final int id;

  UserProfile({
    required this.userId,
    required this.profilePictureUrl, // Now a String
    required this.phoneNumber,
    required this.socialMediaLinks,
    required this.occupation,
    // address part
    required this.address,
    required this.line_1,
    required this.line_2,
    required this.province,
    required this.country,
    required this.postalCode,
    //id part
    required this.driverLicenseNumber,
    required this.nationalId,
    required this.passportNumber,
    required this.socialSecurityNumber,
    //
    required this.updatedAt,
    required this.createdAt,
    required this.id,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      userId: int.tryParse(json['user_id'].toString()) ?? 0,
      profilePictureUrl: json['profile_picture_url'] ?? null,
      phoneNumber: json['phone_number'],
      socialMediaLinks: json['social_media_links'] ?? '',
      occupation: json['occupation'] ?? '',
      //address part
      address: json['address'] ?? '',
      line_1: json['line_1'] ?? '',
      line_2: json['line_2'] ?? '',
      province: json['province'] ?? '',
      country: json['country'] ?? '',
      postalCode: json['postal_code'] ?? '',
      //id part
      driverLicenseNumber: json['driver_license_number'] ?? '',
      nationalId: json['national_id'] ?? '',
      passportNumber: json['passport_number'] ?? '',
      socialSecurityNumber: json['social_security_number'] ?? '',
      //
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'])
          : null,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
      id: json['id'],
    );
  }
}

class UserProfileResponse {
  final bool success;
  final String message;
  final UserProfile data;

  UserProfileResponse(
      {required this.success, required this.message, required this.data});

  factory UserProfileResponse.fromJson(Map<String, dynamic> json) {
    return UserProfileResponse(
      success: json['success'],
      message: json['message'],
      data: UserProfile.fromJson(json['data']['profile']),
    );
  }
}

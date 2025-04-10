import './address_model.dart';


class UserProfile {
  final int userId;
  final int id;
  String profilePictureUrl; // Changed from File to String
  final String phoneNumber;
  final String socialMediaLinks;
  final String occupation;

  final String driverLicenseNumber;
  final String nationalId;
  final String passportNumber;
  final String socialSecurityNumber;
  final DateTime? updatedAt;
  final DateTime? createdAt;
  final Address address;

  UserProfile({
    required this.userId,
    required this.id,
    required this.profilePictureUrl, // Now a String
    required this.phoneNumber,
    required this.socialMediaLinks,
    required this.occupation,

    required this.driverLicenseNumber,
    required this.nationalId,
    required this.passportNumber,
    required this.socialSecurityNumber,
    required this.updatedAt,
    required this.createdAt,
    
    required this.address, // Updated to Address type
  });

    factory UserProfile.fromJson(Map<String, dynamic> json) {
      return UserProfile(
        userId: int.tryParse(json['user_id'].toString()) ?? 0,
        profilePictureUrl: json['profile_picture_url'] ?? '',
        phoneNumber: json['phone_number'],
        socialMediaLinks: json['social_media_links'] ?? '',
        occupation: json['occupation'] ?? '',

        // Safe check for 'address' JSON key
        address: json['address'] != null ? Address.fromJson(json['address']) : Address(
          line1: '',
          line2: '',
          province: '',
          country: '',
          postalCode: '',
          lat: 0.0,
          long: 0.0,
        ), // Default Address if null


        driverLicenseNumber: json['driver_license_number'] ?? '',
        nationalId: json['national_id'] ?? '',
        passportNumber: json['passport_number'] ?? '',
        socialSecurityNumber: json['social_security_number'] ?? '',
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

  UserProfileResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory UserProfileResponse.fromJson(Map<String, dynamic> json) {
    return UserProfileResponse(
      success: json['success'],
      message: json['message'],
      data: json['data'] != null && json['data']['profile'] != null
          ? UserProfile.fromJson(json['data']['profile'])
          : UserProfile(
              userId: 0, // Default values if profile data is missing
              profilePictureUrl: '',
              phoneNumber: '',
              socialMediaLinks: '',
              occupation: '',
              address: Address(
                line1: '',
                line2: '',
                province: '',
                country: '',
                postalCode: '',
                lat: 0.0,
                long: 0.0,
              ),
              driverLicenseNumber: '',
              nationalId: '',
              passportNumber: '',
              socialSecurityNumber: '',
              updatedAt: null,
              createdAt: null,
              id: 0,
              
            ),
    );
  }

  // factory UserProfileResponse.fromJson(Map<String, dynamic> json) {
  //   return UserProfileResponse(
  //     success: json['success'],
  //     message: json['message'],
  //     data: UserProfile.fromJson(json['data']['profile']),
  //   );
  // }
}

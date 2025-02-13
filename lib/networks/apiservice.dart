import 'dart:convert';
import 'dart:io';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:rentealm_flutter/MODELS/room_model.dart';
import 'package:rentealm_flutter/models/property_model.dart';
import 'package:rentealm_flutter/models/tenant_model.dart';

import '../API/rest.dart';

import '../MODELS/profile_model.dart';
import '../MODELS/user_model.dart';

class ApiService {
  final String rest = Rest.baseUrl;

  Future<UserResponse?> loginUser({
    required String email,
    required String password,
  }) async {
    final uri = Uri.parse('$rest/login');
    print("loginUser() $uri");
    try {
      // Prepare request body
      final body = {
        "email": email,
        "password": password,
      };

      // Make POST request
      final response = await http.post(
        uri,
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
        },
        body: jsonEncode(body),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        print('loginUser() response.body: ${response.body}');
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        print('loginUser() responseData: $responseData');
        return UserResponse.fromJson(responseData);
      } else {
        print('Error: ${response.statusCode} - ${response.body}');
        return null;
      }
    } catch (e) {
      print('Exeption: $e');
      return null;
    }
  }

  Future<UserResponse?> registerUser({
    required String name,
    required String email,
    required String password,
  }) async {
    final url =
        Uri.parse('$rest/create/tenant'); // Replace with your API endpoint

    try {
      // Prepare request body
      final body = {
        "name": name,
        "email": email,
        "password": password,
      };

      // Make POST request
      final response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
        },
        body: jsonEncode(body),
      );

      // Check for successful response
      if (response.statusCode == 200 || response.statusCode == 201) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        return UserResponse.fromJson(responseData); // Parse response into model
      } else {
        // Handle errors
        print('Error: ${response.statusCode} - ${response.body}');
        return null;
      }
    } catch (e) {
      // Handle exception
      print('Exception: $e');
      return null;
    }
  }

  Future<UserResponse?> getUser({
    required int userId,
    required String token,
  }) async {
    final uri = Uri.parse('$rest/tenant/user/show/$userId');

    print("getUser() token: $token");
    try {
      final response = await http.get(
        uri,
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        print("responseData from getUser Call: $responseData");
        return UserResponse.fromJson(responseData);
      } else {
        print('Error: ${response.statusCode} - ${response.body}');
        return null;
      }
    } catch (e) {
      print('Exeption: $e');
      return null;
    }
  }

  Future<bool> postLogout(String token) async {
    final uri = Uri.parse('$rest/logout');
    print("logoutUser() $uri");

    try {
      final response = await http.get(
        uri,
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
          "Authorization":
              "Bearer $token", // Pass the token to authenticate the request
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        print('Logout successful: ${response.body}');
        return true; // Return true if logout is successful
      } else {
        print('Error: ${response.statusCode} - ${response.body}');
        return false; // Return false if logout fails
      }
    } catch (e) {
      print('Exception: $e');
      return false; // Return false if there is an exception
    }
  }

  Future<UserProfileResponse?> getUserProfile({
    required int userId,
    required String token,
    // required context,
  }) async {
    final uri = Uri.parse('$rest/tenant/profile/show/$userId');
    print(uri);
    try {
      final response = await http.get(
        uri,
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        print('response body ${response.body}');
        return UserProfileResponse.fromJson(responseData);
      } else {
        print('Error: ${response.statusCode} - ${response.body}');
        return null;
      }
    } catch (e) {
      print('Exeption: $e');
      return null;
    }
  }

  Future<UserProfileResponse?> postProfilePicture({
    required int userId,
    required String token,
    required File compressedFile,
  }) async {
    print("userId: $userId");
    print("token: $token");
    print("compressedFilePath: ${compressedFile.path}");

    final uri = Uri.parse('$rest/tenant/profile/storepicture/$userId');
    final request = http.MultipartRequest('POST', uri)
      ..headers['Authorization'] = 'Bearer $token'
      ..files.add(await http.MultipartFile.fromPath(
          'profile_picture_url', compressedFile.path));

    final response = await request.send();

    if (response.statusCode == 200) {
      print('Profile picture uploaded successfully');
      // Convert the StreamedResponse to String and decode it as JSON
      final responseBody = await response.stream.bytesToString();
      final Map<String, dynamic> jsonResponse = jsonDecode(responseBody);
      print(responseBody);
      // Parse the JSON into a UserProfileResponse object
      return UserProfileResponse.fromJson(jsonResponse);
    } else {
      print('Failed to upload profile picture');
      // Handle error
      return null;
    }
  }

  Future<UserProfileResponse?> postProfileData({
    required int? userId,
    required String? token,
    required String phoneNumberController,
    required String socialMediaLinkController,
    required String occupationController,
    required String line1Controller,
    required String line2Controller,
    required String provinceController,
    required String countryController,
    required String postalCodeController,
    required String? driverLicenseNumber,
    required String? nationalIdNumber,
    required String? passportNumber,
    required String? socialSecurityNumber,
  }) async {
    print('From Api call User_id: $userId');
    print('From Api call token: $token');
    print('From Api call Phone Number: $phoneNumberController');
    print('From Api call Social Media Link: $socialMediaLinkController');
    print('From Api call Occupation: $occupationController');
    print('From Api call Line 1 Address: $line1Controller');
    print('From Api call Line 2 Address: $line2Controller');
    print('From Api call Province: $provinceController');
    print('From Api call Country: $countryController');
    print('From Api call Postal Code Controller: $postalCodeController');
    print('From Api call Driver License Number: $driverLicenseNumber');
    print('From Api call National ID Number: $nationalIdNumber');
    print('From Api call Passport Number: $passportNumber');
    print('From Api call Social Security Number: $socialSecurityNumber');

    final uri = Uri.parse('$rest/tenant/profile/store/$userId');
    try {
      final requestBody = {
        "phone_number": phoneNumberController,
        "social_media_links": socialMediaLinkController,
        "occupation": occupationController,
        "line_1": line1Controller,
        "line_2": line2Controller,
        "province": provinceController,
        "country": countryController,
        "postal_code": postalCodeController,
        "driver_license_number": driverLicenseNumber,
        "national_id": nationalIdNumber,
        "passport_number": passportNumber,
        "social_security_number": socialSecurityNumber,
      };

      final response = await http.post(uri,
          headers: {
            "Content-Type": "application/json",
            "Accept": "application/json",
            "Authorization": "Bearer $token",
          },
          body: jsonEncode(requestBody));

      if (response.statusCode == 200 || response.statusCode == 201) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        print('from ApiService.postProfileData:  $responseData');
        return UserProfileResponse.fromJson(responseData);
      } else {
        print('Error: ${response.statusCode} - ${response.body}');
        return null;
      }
    } catch (e) {
      print('Exception: $e');
      return null;
    }
  }

  Future<UserResponse?> updateUser({
    required int id,
    required String token,
    required String name,
    required String email,
    required String password,
  }) async {
    final uri = Uri.parse('$rest/tenant/user/update/$id');
    try {
      final requestBody = {
        "name": name,
        "email": email,
        "password": password,
      };

      final response = await http.post(uri,
          headers: {
            "Content-Type": "application/json",
            "Accept": "application/json",
            "Authorization": "Bearer $token",
          },
          body: jsonEncode(requestBody));

      if (response.statusCode == 200 || response.statusCode == 201) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        print('from ApiService.updateUser:  $responseData');
        return UserResponse.fromJson(responseData);
      } else {
        print('Error: ${response.statusCode} - ${response.body}');
        return null;
      }
    } catch (e) {
      print('Exception: $e');
      return null;
    }
  }

  Future<UserProfileResponse?> updateUserProfile({
    required int userId,
    required String token,
    required String phoneNumberController,
    required String socialMediaLinkController,
    required String occupationController,
  }) async {
    print('From updateUserProfile() User_id: $userId');
    print('From updateUserProfile() token: $token');
    print('From updateUserProfile() Phone Number: $phoneNumberController');
    print(
        'From updateUserProfile() Social Media Link: $socialMediaLinkController');
    print('From updateUserProfile() Occupation: $occupationController');

    final uri = Uri.parse('$rest/tenant/profile/update/$userId');
    try {
      final requestBody = {
        "phone_number": phoneNumberController,
        "social_media_links": socialMediaLinkController,
        "occupation": occupationController,
      };

      print("requestBody: $requestBody");

      final request = await http.post(
        uri,
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
          "Authorization": "Bearer $token",
        },
        body: jsonEncode(requestBody),
      );

      if (request.statusCode == 200 || request.statusCode == 201) {
        final Map<String, dynamic> responseData = jsonDecode(request.body);
        print('from ApiService.updateUserProfile:  $responseData');
        return UserProfileResponse.fromJson(responseData);
      } else {
        print('Error: ${request.statusCode} - ${request.body}');
        return null;
      }
    } catch (e) {
      print('Exception: $e');
      return null;
    }
  }

  Future<UserProfileResponse?> updateUserAddress({
    required int userId,
    required String token,
    required String line1Controller,
    required String line2Controller,
    required String provinceController,
    required String countryController,
    required String postalCodeController,
  }) async {
    print('From updateUserProfile() User_id: $userId');
    print('From updateUserProfile() token: $token');
    print('From updateUserProfile() Line 1 Address: $line1Controller');
    print('From updateUserProfile() Line 2 Address: $line2Controller');
    print('From updateUserProfile() Province: $provinceController');
    print('From updateUserProfile() Country: $countryController');
    print(
        'From updateUserProfile() Postal Code Controller: $postalCodeController');
    final uri = Uri.parse('$rest/tenant/profile/update/$userId');

    try {
      final requestBody = {
        "line_1": line1Controller,
        "line_2": line2Controller,
        "province": provinceController,
        "country": countryController,
        "postal_code": postalCodeController,
      };

      final request = await http.post(
        uri,
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
          "Authorization": "Bearer $token",
        },
        body: jsonEncode(requestBody),
      );

      if (request.statusCode == 200 || request.statusCode == 201) {
        final Map<String, dynamic> responseData = jsonDecode(request.body);
        print('from ApiService.updateUserProfile:  $responseData');
        return UserProfileResponse.fromJson(responseData);
      } else {
        print('Error: ${request.statusCode} - ${request.body}');
        return null;
      }
    } catch (e) {
      print('Exception: $e');
      return null;
    }
  }

  Future<UserProfileResponse?> updateUserIdentifications({
    required int userId,
    required String token,
    required String driverLicenseNumber,
    required String nationalIdNumber,
    required String passportNumber,
    required String socialSecurityNumber,
  }) async {
    print("updateUserIdentifications(): $userId");
    print("updateUserIdentifications(): $token");
    print("updateUserIdentifications(): $driverLicenseNumber");
    print("updateUserIdentifications(): $nationalIdNumber");
    print("updateUserIdentifications(): $passportNumber");
    print("updateUserIdentifications(): $socialSecurityNumber");

    final uri = Uri.parse('$rest/tenant/profile/update/$userId');

    try {
      final requestBody = {
        "driver_license_number": driverLicenseNumber,
        "national_id": nationalIdNumber,
        "passport_number": passportNumber,
        "social_security_number": socialSecurityNumber,
      };

      final request = await http.post(
        uri,
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
          "Authorization": "Bearer $token",
        },
        body: jsonEncode(requestBody),
      );

      if (request.statusCode == 200 || request.statusCode == 201) {
        final Map<String, dynamic> responseData = jsonDecode(request.body);
        print('from ApiService.updateUserProfile:  $responseData');
        return UserProfileResponse.fromJson(responseData);
      } else {
        print('Error: ${request.statusCode} - ${request.body}');
        return null;
      }
    } catch (e) {
      print('Exception: $e');
      return null;
    }
  }

  Future<TenantResponse?> getTenant({
    required int profileId,
    required String token,
  }) async {
    print("getTenant(): token $token");
    print("getTenant(): profile id $profileId");

    final uri = Uri.parse('$rest/tenant/tenant/showbyprofile_id/$profileId');

    try {
      final response = await http.get(
        uri,
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        print("responseData from getTenant Call: $responseData");
        return TenantResponse.fromJson(responseData); // Corrected this line
      } else if (response.statusCode == 404) {
        print('Error: ${response.statusCode} - ${response.body}');
        print('navigating to create tenant screen');
        return null;
      }
    } catch (e) {
      print('Exception: $e');
      return null;
    }
  }

  Future<PropertyResponse?> getProperty({
    required String token,
  }) async {
    print("getProperty(): token $token");

    final uri = Uri.parse('$rest/tenant/property/index');

    try {
      final response = await http.get(
        uri,
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        print("responseData from getProperty Call: $responseData");
        return PropertyResponse.fromJson(responseData);
      } else {
        print('Error: ${response.statusCode} - ${response.body}');
        return null;
      }
    } catch (e) {
      print('Exception: $e');
      return null;
    }
  }

  Future<RoomResponse?>getRoomsByPropertyId({
    required int propertyId, 
    required String token 
  }) async {
    print("getRoomsByPropertyId(): $propertyId");
    print("getRoomsByPropertyId(): $token");

    final uri = Uri.parse('$rest/tenant/room/property/$propertyId');

    try {
      final response = await http.get(
        uri,
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      if(response.statusCode == 200 || response.statusCode == 201) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        print("responseData from getRoomsByPropertyId() Call: $responseData");
        return RoomResponse.fromJson(responseData);
      } else {
        print('Error: ${response.statusCode} - ${response.body}');
        return null;
      }
    } catch (e) {
      print('Exception: $e');
      return null;
    }
  }

  Future<PropertyResponse?> searchProperty({
    required String token,
    String? address,
    String? type,
    String? status,
    String? genderAllowed,
  }) async {
    print("getProperty(): token $token");
    
    final uri = Uri.parse('$rest/tenant/property/search');

    try {
      final response = await http.get(
        uri,
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
          "Authorization": "Bearer $token",
        }
      );

      
      if (response.statusCode == 200 || response.statusCode == 201) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        print("responseData from getProperty Call: $responseData");
        return PropertyResponse.fromJson(responseData);
      } else {
        print('Error: ${response.statusCode} - ${response.body}');
        return null;
      }

    } catch (e) {

      print('Exception: $e');
      return null;
    }

  }


  Future<RoomResponse?>getRoomById({
    required int roomId,
    required String token,
  }) async {

    print("getRoomById(): $roomId");
    print("getRoomById(): $token");
    
    final uri = Uri.parse('$rest/tenant/room/show/$roomId');

    try {
      final response = await http.get(
        uri,
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
          "Authorization": "Bearer $token",
        }
      );  

       if(response.statusCode == 200 || response.statusCode == 201) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        print("responseData from getRoomById() Call: $responseData");
        return RoomResponse.fromJson(responseData);
      } else {
        print('Error: ${response.statusCode} - ${response.body}');
        return null;
      }

    } catch (e) {
      print('Exception: $e');
      return null;
    }
  }

}

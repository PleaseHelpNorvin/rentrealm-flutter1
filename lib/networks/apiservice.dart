import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart'; // Import this for MediaType
import '../models/profile_model.dart';
import '../apis/api.dart';
import '../models/profile_model.dart';
import '../models/user_model.dart';

class ApiService {
  final String api = Api.baseUrl;

  //login api call
  Future<UserResponse?> loginUser({
    required String email,
    required String password,
  }) async {
    final uri = Uri.parse('${Api.baseUrl}/login');
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

  Future<bool> postLogout(String token) async {
    final uri = Uri.parse('${Api.baseUrl}/logout');
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

  Future<UserResponse?> registerUser({
    required String name,
    required String email,
    required String password,
  }) async {
    final url = Uri.parse(
        '${Api.baseUrl}/create/tenant'); // Replace with your API endpoint

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
    final uri = Uri.parse('${Api.baseUrl}/tenant/user/show/$userId');

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

  Future<UserProfileResponse?> getUserProfile({
    required int userId,
    required String token,
    // required context,
  }) async {
    final uri = Uri.parse('${Api.baseUrl}/tenant/profile/show/$userId');
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
        // print('response body ${response.body}');
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

    final uri = Uri.parse('${Api.baseUrl}/tenant/profile/storepicture/$userId');
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

    final uri = Uri.parse('${Api.baseUrl}/tenant/profile/store/$userId');
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
        "national_id_number": nationalIdNumber,
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
    final uri = Uri.parse('${Api.baseUrl}/tenant/user/update/$id');
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
        print('from ApiService.postProfileData:  $responseData');
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
    // required String line1Controller,
    // required String line2Controller,
    // required String provinceController,
    // required String countryController,
    // required String postalCodeController,
    // required String driverLicenseNumber,
    // required String nationalIdNumber,
    // required String passportNumber,
    // required String socialSecurityNumber,
  }) async {
    print('From updateUserProfile() User_id: $userId');
    print('From updateUserProfile() token: $token');
    print('From updateUserProfile() Phone Number: $phoneNumberController');
    print(
        'From updateUserProfile() Social Media Link: $socialMediaLinkController');
    print('From updateUserProfile() Occupation: $occupationController');
    // print('From updateUserProfile() Line 1 Address: $line1Controller');
    // print('From updateUserProfile() Line 2 Address: $line2Controller');
    // print('From updateUserProfile() Province: $provinceController');
    // print('From updateUserProfile() Country: $countryController');
    // print(
    //     'From updateUserProfile() Postal Code Controller: $postalCodeController');
    // print(
    //     'From updateUserProfile() Driver License Number: $driverLicenseNumber');
    // print('From updateUserProfile() National ID Number: $nationalIdNumber');
    // print('From updateUserProfile() Passport Number: $passportNumber');
    // print(
    //     'From updateUserProfile() Social Security Number: $socialSecurityNumber');
  }

  Future<UserProfileResponse?> updateUserAddress({
    required int userId,
    required String token,
    // required String phoneNumberController,
    // required String socialMediaLinkController,
    // required String occupationController,
    required String line1Controller,
    required String line2Controller,
    required String provinceController,
    required String countryController,
    required String postalCodeController,
    // required String driverLicenseNumber,
    // required String nationalIdNumber,
    // required String passportNumber,
    // required String socialSecurityNumber,
  }) async {
    print('From updateUserProfile() User_id: $userId');
    print('From updateUserProfile() token: $token');
    print('From updateUserProfile() Line 1 Address: $line1Controller');
    print('From updateUserProfile() Line 2 Address: $line2Controller');
    print('From updateUserProfile() Province: $provinceController');
    print('From updateUserProfile() Country: $countryController');
    print(
        'From updateUserProfile() Postal Code Controller: $postalCodeController');
    // print(
    //     'From updateUserProfile() Driver License Number: $driverLicenseNumber');
    // print('From updateUserProfile() National ID Number: $nationalIdNumber');
    // print('From updateUserProfile() Passport Number: $passportNumber');
    // print(
    //     'From updateUserProfile() Social Security Number: $socialSecurityNumber');
  }

  Future<UserProfileResponse?> updateUserIdentification({
    required int userId,
    required String token,
    // required String phoneNumberController,
    // required String socialMediaLinkController,
    // required String occupationController,
    // required String line1Controller,
    // required String line2Controller,
    // required String provinceController,
    // required String countryController,
    // required String postalCodeController,
    required String driverLicenseNumber,
    required String nationalIdNumber,
    required String passportNumber,
    required String socialSecurityNumber,
  }) async {
    print('From updateUserProfile() User_id: $userId');
    print('From updateUserProfile() token: $token');

    print(
        'From updateUserProfile() Driver License Number: $driverLicenseNumber');
    print('From updateUserProfile() National ID Number: $nationalIdNumber');
    print('From updateUserProfile() Passport Number: $passportNumber');
    print(
        'From updateUserProfile() Social Security Number: $socialSecurityNumber');
  }
}

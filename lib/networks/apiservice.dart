import 'dart:convert';
import 'package:http/http.dart' as http;

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
        return UserResponse
            .fromJson(responseData); // Parse response into model
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

  Future<UserResponse?>getUser({
    required int userId,
    required String token,
  }) async{
    final uri = Uri.parse('${Api.baseUrl}/tenant/user/show/$userId');

    print("getUser() token: $token");
    try {
      final response = await http.get(
        uri,
        headers: {
          "Content-Type" : "application/json",
          "Accept" : "application/json",
          "Authorization" : "Bearer $token", 
        },
      );

      if(response.statusCode == 200 || response.statusCode == 201){
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

  Future<UserProfileResponse?>getUserProfile({
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
            "Content-Type" : "application/json",
            "Accept" : "application/json",
            "Authorization" : "Bearer $token", 
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

  Future<UserProfileResponse?>postUserProfile({
    required int userId,
    required String token,
    required Map<String, String>userProfile
  }) async {

  }
  

  
}
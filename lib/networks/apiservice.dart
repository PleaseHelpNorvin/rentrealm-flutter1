import 'dart:convert';
import 'package:http/http.dart' as http;

import '../apis/api.dart';
import '../models/user_model.dart';

class ApiService {
  final String api = Api.baseUrl;
  
  //login api call
  Future<UserResponse?> loginUser({
    required String email,
    required String password,
  }) async {
    final url = Uri.parse('${Api.baseUrl}/login');

    try {
      // Prepare request body
      final body = {
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

      if (response.statusCode == 200 || response.statusCode == 201) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
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
}
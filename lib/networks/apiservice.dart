import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:rentealm_flutter/MODELS/room_model.dart';
import 'package:rentealm_flutter/models/inquiry_model.dart';
import 'package:rentealm_flutter/models/property_model.dart';
import 'package:rentealm_flutter/models/rentalAgreement_model.dart';
import 'package:rentealm_flutter/models/reservation_model.dart';
import 'package:rentealm_flutter/models/tenant_model.dart';

import '../API/rest.dart';

import '../MODELS/profile_model.dart';
import '../MODELS/user_model.dart';
import '../models/billing_model.dart';
// import '../models/dashboardData_model.dart';
import '../models/maintenanceRequest_model.dart';
import '../models/notification_model.dart';
import '../models/payment_model.dart';
import '../models/paymongo_model.dart';
import '../models/pickedRoom_model.dart';

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

  Future<PropertyResponse?> getProperty(
      // required String token,
      ) async {
    // print("getProperty(): token $token");

    final uri = Uri.parse('$rest/property/index');

    try {
      final response = await http.get(
        uri,
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
          // "Authorization": "Bearer $token",
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

  Future<RoomResponse?> getRoomsByPropertyId({required int propertyId}) async {
    print("getRoomsByPropertyId(): $propertyId");
    // print("getRoomsByPropertyId(): $token");

    final uri = Uri.parse('$rest/room/property/$propertyId');

    try {
      final response = await http.get(
        uri,
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
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

  Future<PropertyResponse?> getPropertyById({
    required String token,
    required int propertyId,
  }) async {
    final uri = Uri.parse('$rest/tenant/property/show/$propertyId');
    try {
      final response = await http.get(uri, headers: {
        "Content-Type": "application/json",
        "Accept": "application/json",
        "Authorization": "Bearer $token",
      });

      if (response.statusCode == 200 || response.statusCode == 201) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        print("responseData from getPropertyById() Call: $responseData");
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

  Future<RoomResponse?> getRoomById({
    required int roomId,
  }) async {
    print("getRoomById(): $roomId");

    final uri = Uri.parse('$rest/room/show/$roomId');

    try {
      final response = await http.get(uri, headers: {
        "Content-Type": "application/json",
        "Accept": "application/json",
      });

      if (response.statusCode == 200 || response.statusCode == 201) {
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

  Future<InquiryResponse?> postInquiry({
    required int roomId,
    required String name,
    required String contactNumber,
    required String message,
  }) async {
    print("storeInquiry() roomId $roomId");
    print("storeInquiry() message $message");

    final uri = Uri.parse('$rest/inquiry/store');

    try {
      final body = {
        "room_id": roomId,
        "name": name,
        "contact_no": contactNumber,
        "message": message,
      };

      final response = await http.post(
        uri,
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
        },
        body: jsonEncode(body),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        print(responseData);
        return InquiryResponse.fromJson(
            responseData); // Parse response into model
      } else {
        // Handle errors
        print('Error: ${response.statusCode} - ${response.body}');
        return null;
      }
    } catch (e) {
      print('Exception: $e');
      return null;
    }
  }

  Future<NotificationResponse?> getNotification({
    required String token,
    required int userId,
  }) async {
    print("getNotification(): $token");
    print("getNotification(): $userId");

    final uri = Uri.parse('$rest/tenant/notification/index/$userId');
    try {
      final response = await http.get(uri, headers: {
        "Content-Type": "application/json",
        "Accept": "application/json",
        "Authorization": "Bearer $token",
      });

      if (response.statusCode == 200 || response.statusCode == 201) {
        print("Raw API response: ${response.body}");
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        print("responseData from getNotification() Call: $responseData");
        return NotificationResponse.fromJson(responseData);
      } else {
        print('Error: ${response.statusCode} - ${response.body}');
        return null;
      }
    } catch (e) {
      print('Exception: $e');
      return null;
    }
  }

  Future<NotificationResponse?> patchNotificationStatus({
    required String token,
    required int userId,
    required int notifId,
  }) async {
    print("patchNotificationStatus(): $token");
    print("patchNotificationStatus():userId $userId");
    print("patchNotificationStatus(): notifId $notifId");

    final uri = Uri.parse('$rest/tenant/notification/updateIsRead/$notifId');
    try {
      final response = await http.patch(uri, headers: {
        "Content-Type": "application/json",
        "Accept": "application/json",
        "Authorization": "Bearer $token",
      });

      if (response.statusCode == 200 || response.statusCode == 201) {
        print("Raw API response: ${response.body}");
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        print(
            "responseData from patchNotificationStatus() Call: $responseData");
        return NotificationResponse.fromJson(responseData);
      } else {
        print('Error: ${response.statusCode} - ${response.body}');
        return null;
      }
    } catch (e) {
      print('Exception: $e');
      return null;
    }
  }

  // Future<InquiryResponse?> getInquiryById({
  //   required String token,
  //   required int unquiryId,
  // }) async {
  //   print("getInquiryById(): $token");
  //   print("getInquiryById(): $unquiryId");

  //   final uri = Uri.parse('$rest/tenant/inquiry/show/$unquiryId');

  //   try {
  //     final response = await http.get(uri, headers: {
  //       "Content-Type": "application/json",
  //       "Accept": "application/json",
  //       "Authorization": "Bearer $token",
  //     });

  //     if (response.statusCode == 200 || response.statusCode == 201) {
  //       print("Raw API response: ${response.body}");
  //       final Map<String, dynamic> responseData = jsonDecode(response.body);
  //       print("responseData from InquiryResponse() Call: $responseData");
  //       return InquiryResponse.fromJson(responseData);
  //     } else {
  //       print('Error: ${response.statusCode} - ${response.body}');
  //       return null;
  //     }
  //   } catch (e) {
  //     print('Exception: $e');
  //     return null;
  //   }
  // }

  Future<ReservationResponse?> showReservation({
    required int reservationId,
    required String token,
  }) async {
    final uri = Uri.parse("$rest/tenant/reservation/show/$reservationId");

    try {
      final response = await http.get(uri, headers: {
        "Content-Type": "application/json",
        "Accept": "application/json",
        "Authorization": "Bearer $token",
      });

      if (response.statusCode == 200 || response.statusCode == 201) {
        print("Raw API response: ${response.body}");
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        print("responseData from showReservation() Call: $responseData");
        return ReservationResponse.fromJson(responseData);
      } else {
        print('Error: ${response.statusCode} - ${response.body}');
        return null;
      }
    } catch (e) {
      print('Exception: $e');
      return null;
    }
  }

  Future<RentalAgreementResponse?> postRentalAgreement({
    required String token,
    required int reservationId,
    required String rentStartDate,
    required int personCount,
    required double totalMonthlyDue,
    required String? description,
    required bool? isAdvancePaymentChecked,
    required File svgSignatureString, // Now a File object
  }) async {
    final uri = Uri.parse('$rest/tenant/rental_agreement/store');

    try {
      final request = http.MultipartRequest('POST', uri);

      // Add fields to the request body (non-file fields)
      request.fields['reservation_id'] = reservationId.toString();
      request.fields['rent_start_date'] = rentStartDate;
      request.fields['person_count'] = personCount.toString();
      request.fields['total_amount'] = totalMonthlyDue.toString();
      request.fields['is_advance_payment'] =
          isAdvancePaymentChecked == true ? '1' : '0';
      if (description != null) {
        request.fields['description'] = description;
      }

      // Add the file (signature PNG)
      final fileBytes = await svgSignatureString.readAsBytes();
      final multipartFile = http.MultipartFile.fromBytes(
        'signature_png_string', // Field name in the form
        fileBytes,
        filename: 'signature.png', // Filename of the uploaded file
        contentType: MediaType('image', 'png'), // Content type of the file
      );
      request.files.add(multipartFile);

      // Add headers
      request.headers['Authorization'] = 'Bearer $token';
      request.headers['Accept'] = 'application/json';

      // Send the request
      final response = await request.send();

      // Get the response body
      final responseBody = await response.stream.bytesToString();
      if (response.statusCode == 200 || response.statusCode == 201) {
        final Map<String, dynamic> responseData = jsonDecode(responseBody);
        print('Response from API: $responseData');
        return RentalAgreementResponse.fromJson(responseData);
      } else {
        print('Error: ${response.statusCode} - ${responseBody}');
        return null;
      }
    } catch (e) {
      print("Exception error: $e");
      return null;
    }
  }

  Future<RentalAgreementResponse?> getIndexRentalAgreementByProfileId({
    required String token,
    required int? profileId,
  }) async {
    print("from getIndexRentalAgreement(): token: $token");
    final uri =
        Uri.parse("$rest/tenant/rental_agreement/index-profileId/$profileId");

    final headers = {
      "Content-Type": "application/json",
      "Accept": "application/json",
      "Authorization": "Bearer $token",
    };

    try {
      final response = await http.get(
        uri,
        headers: headers,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        print("Raw API response: ${response.body}");
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        print(
            "responseData from getIndexRentalAgreement(): Call: $responseData");
        return RentalAgreementResponse.fromJson(responseData);
      } else {
        print('Error: ${response.statusCode} - ${response.body}');
        return null;
      }
    } catch (e) {
      print("EXCEPTION: $e");
      return null;
    }
  }

  Future<PickedRoomResponse?> postPickedRoomByUser({
    required int userId,
    required String token,
    required int roomId,
  }) async {
    print("from postPickedRoomByUser() userId: $userId");
    print("from postPickedRoomByUser() token: $token");
    print("from postPickedRoomByUser() roomId: $roomId");
    final uri = Uri.parse('$rest/tenant/picked_room/addRoomForUser');

    final body = {
      "user_id": userId,
      "room_id": roomId,
    };

    final headers = {
      "Content-Type": "application/json",
      "Accept": "application/json",
      "Authorization": "Bearer $token",
    };

    try {
      final response = await http.post(
        uri,
        headers: headers,
        body: jsonEncode(body),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        print("Raw API response: ${response.body}");
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        print("responseData from postPickedRoomByUser() Call: $responseData");
        return PickedRoomResponse.fromJson(responseData);
      } else {
        print('Error: ${response.statusCode} - ${response.body}');
        return null;
      }
    } catch (e) {
      print('EXCEPTION $e');
      return null;
    }
  }

  Future<PickedRoomResponse?> getPickedRoomsByUser({
    required int userId,
    required String token,
  }) async {
    final uri = Uri.parse('$rest/tenant/picked_room/getRoomsByUser/$userId');

    final headers = {
      "Content-Type": "application/json",
      "Accept": "application/json",
      "Authorization": "Bearer $token",
    };

    final response = await http.get(uri, headers: headers);

    if (response.statusCode == 200 || response.statusCode == 201) {
      print("Raw API response: ${response.body}");
      final Map<String, dynamic> responseData = jsonDecode(response.body);
      print("responseData from getPickedRoomsByUser() Call: $responseData");
      return PickedRoomResponse.fromJson(responseData);
    } else {
      print('Error: ${response.statusCode} - ${response.body}');
      return null;
    }
  }

  Future<ReservationResponse?> postReservation({
    required int profileId,
    required int roomId,
    required File? paymentProof,
    required String paymentMethod,
    required String token,
  }) async {
    try {
      print("from postReservation(): $token");

      var uri = Uri.parse(
          '$rest/tenant/reservation/store'); // Replace with your actual API endpoint
      var request = http.MultipartRequest("POST", uri)
        ..fields['profile_id'] = profileId.toString()
        ..fields['room_id'] = roomId.toString()
        ..fields['payment_method'] = paymentMethod
        ..headers.addAll({
          'Authorization': 'Bearer $token', // Add the Authorization header
          'Content-Type': 'multipart/form-data',
          'Accept': 'application/json',
        });

      // Attach the file if it exists
      if (paymentProof != null) {
        request.files.add(
          await http.MultipartFile.fromPath(
            'reservation_payment_proof_url[]', // Field name in the API
            paymentProof.path,
          ),
        );
      }

      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200 || response.statusCode == 201) {
        var responseData = jsonDecode(response.body);
        print("Response Data: $responseData");
        return ReservationResponse.fromJson(responseData);
      } else {
        print("Error: ${response.statusCode} - ${response.body}");
        return null;
      }
    } catch (e) {
      print("Exception: $e");
      return null;
    }
  }

  // Future<ReservationResponse?> getReservations({required String token}) async {
  //   final uri = Uri.parse('$rest/tenant/reservation/index');

  //   final headers = {
  //     "Content-Type": "application/json",
  //     "Accept": "application/json",
  //     "Authorization": "Bearer $token",
  //   };

  //   final response = await http.get(uri, headers: headers);

  //   if (response.statusCode == 200 || response.statusCode == 201) {
  //     print("Raw API response: ${response.body}");
  //     final Map<String, dynamic> responseData = jsonDecode(response.body);
  //     print("responseData from getReservations() Call: $responseData");
  //     return ReservationResponse.fromJson(responseData);
  //   } else {
  //     print('Error: ${response.statusCode} - ${response.body}');
  //     return null;
  //   }
  // }

  Future<PickedRoomResponse?> deletePickedRoomById({
    required int pickedRoomId,
    required String token,
  }) async {
    try {
      print("pickedRoomId: $pickedRoomId");
      print("token: $token");

      final uri = Uri.parse('$rest/tenant/picked_room/destroy/$pickedRoomId');
      final headers = {
        "Content-Type": "application/json",
        "Accept": "application/json",
        "Authorization": "Bearer $token",
      };

      final response = await http.delete(uri, headers: headers);

      print("Raw API response: ${response.body}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (response.body.isNotEmpty) {
          final Map<String, dynamic> responseData = jsonDecode(response.body);
          print("responseData from deletePickedRoomById() Call: $responseData");
          return PickedRoomResponse.fromJson(responseData);
        } else {
          print("Error: Empty response body.");
          return null;
        }
      } else {
        print('Error: ${response.statusCode} - ${response.body}');
        return null;
      }
    } catch (e) {
      print("Error in deletePickedRoomById: $e");
      return null;
    }
  }

  Future<BillingResponse?> getBillingForRentalAgreement({
    required String token,
    required int rentalagreementId,
  }) async {
    print("getBillingForRentalAgreement REACHED!!!");
    print("from getBillingForRentalAgreement() $token");
    print("from getBillingForRentalAgreement() $rentalagreementId");

    final uri = Uri.parse(
        '$rest/tenant/billing/getbillingforrentalagreement/$rentalagreementId');

    final headers = {
      "Content-Type": "application/json",
      "Accept": "application/json",
      "Authorization": "Bearer $token",
    };

    final response = await http.get(uri, headers: headers);

    if (response.statusCode == 200 || response.statusCode == 201) {
      print("Raw API response: ${response.body}");
      final Map<String, dynamic> responseData = jsonDecode(response.body);
      print(
          "responseData from getBillingForRentalAgreement() Call: $responseData");
      return BillingResponse.fromJson(responseData);
    } else {
      print('Error: ${response.statusCode} - ${response.body}');
      return null;
    }
  }

  Future<CheckFailPaymentResponse?> checkFailPaymentCall(
      {required String token, required int? userid}) async {
    print("from CheckFailPaymentCall() token: $token");
    print("from CheckFailPaymentCall() userid: $userid");

    final uri = Uri.parse('$rest/tenant/payment/check-fail-payment/$userid');

    final headers = {
      "Content-Type": "application/json",
      "Accept": "application/json",
      "Authorization": "Bearer $token",
    };
    try {
      final response = await http.get(uri, headers: headers);

      if (response.statusCode == 200 || response.statusCode == 201) {
        print("Raw API response: ${response.body}");
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        print("responseData from checkFailPaymentCall() Call: $responseData");
        return CheckFailPaymentResponse.fromJson(responseData);
      } else {
        print('Error: ${response.statusCode} - ${response.body}');
        return null;
      }
    } catch (e) {
      print("EXCEPTION: $e");
      return null;
    }
  }

  Future<PaymongoResponse?> postPaymongo({
    required String token,
    required int billingId,
    required double amount,
    required String paymentDescription,
    int? selectedMonthsToPay,
  }) async {
    print("PAYMONGOPOST() REACHED!");
    print("from PaymongoPost $token");
    print("from PaymongoPost $billingId");
    print("from PaymongoPost $amount");
    print("from PaymongoPost $paymentDescription");
    final uri = Uri.parse('$rest/tenant/payment/process-payment');
    try {
      final headers = {
        "Content-Type": "application/json",
        "Accept": "application/json",
        "Authorization": "Bearer $token",
      };
      final body = {
        "billing_id": billingId,
        "amount": amount,
        "payment_description": paymentDescription,
        "selected_months_to_pay": selectedMonthsToPay,
      };

      final request = await http.post(
        uri,
        headers: headers,
        body: jsonEncode(body),
      );

      if (request.statusCode == 200 || request.statusCode == 201) {
        final Map<String, dynamic> responseData = jsonDecode(request.body);
        print('from postPaymongo():  $responseData');
        return PaymongoResponse.fromJson(responseData);
      } else {
        print('Error: ${request.statusCode} - ${request.body}');
        return null;
      }
    } catch (e) {
      print("Exception: $e");
      return null;
    }
  }

  Future<RetrievePaymongoPaymentResponse?> getRetrievePaymongoPayment(
      {required String token, required int billingId}) async {
    print("from getRetrievePayment(): token");
    print("from getRetrievePayment(): billingId $billingId");
    final uri = Uri.parse("$rest/tenant/payment/retrieve-payment/$billingId");
    final header = {
      "Content-Type": "application/json",
      "Accept": "application/json",
      "Authorization": "Bearer $token",
    };
    try {
      final response = await http.get(
        uri,
        headers: header,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        print("responseData from getRetrievePayment Call: $responseData");
        return RetrievePaymongoPaymentResponse.fromJson(
            responseData); // Corrected this line
      } else if (response.statusCode == 404) {
        print('Error: ${response.statusCode} - ${response.body}');
        print('navigating to create tenant screen');
        return null;
      }
    } catch (e) {
      print('Exception: $e');
      return null;
    }
    return null;
  }

  Future<RentalAgreementPdfUrlResponse?> getRentalAgreementUrl(
      {required String token, required String agreementCode}) async {
    print("from getRentalAgreementUrl(): $token");
    print("from getRentalAgreementUrl(): $agreementCode");
    final uri =
        Uri.parse("$rest/tenant/rental_agreement/view-pdf/$agreementCode");
    final header = {
      "Content-Type": "application/json",
      "Accept": "application/json",
      "Authorization": "Bearer $token",
    };

    try {
      final response = await http.get(uri, headers: header);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        print("responseData from getRentalAgreementUrl Call: $responseData");
        return RentalAgreementPdfUrlResponse.fromJson(
            responseData); // Corrected this line
      } else if (response.statusCode == 404) {
        print('Error: ${response.statusCode} - ${response.body}');
        return null;
      }
    } catch (e) {
      print("EXCEPTION: $e");
      return null;
    }
  }

  Future<ReceiptsResponse?> getReceiptByProfileId(
      {required String token, required int? profileId}) async {
    print("from getReceiptByProfileId(): $token");
    print("from getReceiptByProfileId(): $profileId");
    final uri = Uri.parse("$rest/tenant/payment/retrieve-receipt/$profileId");
    final header = {
      "Content-Type": "application/json",
      "Accept": "application/json",
      "Authorization": "Bearer $token",
    };

    try {
      final response = await http.get(uri, headers: header);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        print("responseData from getRentalAgreementUrl Call: $responseData");
        return ReceiptsResponse.fromJson(responseData); // Corrected this line
      } else if (response.statusCode == 404) {
        print('Error: ${response.statusCode} - ${response.body}');
        return null;
      }
    } catch (e) {
      print("EXCEPTION: $e");
      return null;
    }
  }

  Future<ReservationResponse?> getReservationsByProfileId(
      {required int? profileId, required String token}) async {
    print("from getReservationsByProfileId() ProfileId: $profileId");
    print("from getReservationsByProfileId() token: $token");
    final uri =
        Uri.parse('$rest/tenant/reservation/indexByProfileId/$profileId');
    final header = {
      "Content-Type": "application/json",
      "Accept": "application/json",
      "Authorization": "Bearer $token",
    };

    try {
      final response = await http.get(uri, headers: header);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        print("responseData from getTenant Call: $responseData");
        return ReservationResponse.fromJson(
            responseData); // Corrected this line
      } else if (response.statusCode == 404) {
        print('Error: ${response.statusCode} - ${response.body}');
        print('navigating to create tenant screen');
        return null;
      }
    } catch (e) {
      print("EXCEPTION: $e");
      return null;
    }
    return null;
  }

  Future<TenantResponse?> getTenantByProfileId({
    required int profileId,
    required String token,
  }) async {
    print("getTenant(): token $token");
    print("getTenant(): profile id $profileId");

    final uri = Uri.parse('$rest/tenant/tenant/showbyprofileId/$profileId');

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
        debugPrint(
            "responseData from getTenantByProfileId Call: ${jsonEncode(responseData)}",
            wrapWidth: 1024);
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
    return null;
  }

  Future<RentalAgreementResponse?> getActiveRentalAgreementByProfileId({
    required int? profileId,
    required String token,
  }) async {
    print("from getActiveRentalAgreementByProfileId() profileId: $profileId");
    print("from getActiveRentalAgreementByProfileId() token: $token");

    final uri = Uri.parse(
        "$rest/tenant/rental_agreement/show-active-Rental-agreement/$profileId");
    final header = {
      "Content-Type": "application/json",
      "Accept": "application/json",
      "Authorization": "Bearer $token",
    };

    try {
      final response = await http.get(uri, headers: header);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        debugPrint(
            "responseData from getActiveRentalAgreementByProfileId Call: ${jsonEncode(responseData)}",
            wrapWidth: 1024);
        return RentalAgreementResponse.fromJson(
            responseData); // Corrected this line
      } else if (response.statusCode == 404) {
        print('Error: ${response.statusCode} - ${response.body}');
        print('navigating to create tenant screen');
        return null;
      }
    } catch (e) {
      print("EXCEPTION: $e");
      return null;
    }
    return null;
  }

  Future<RentalAgreementCountdownResponse?> getRentalAgreementCountdown({
    required String token,
    required int rentalAgreement,
  }) async {
    print('from GetRentalAgreementCountdown() token: $token');
    print(
        'from GetRentalAgreementCountdown() rentalAgreement: $rentalAgreement');

    final uri = Uri.parse(
        "$rest/tenant/rental_agreement/view-contract-countdown/$rentalAgreement");

    final header = {
      "Content-Type": "application/json",
      "Accept": "application/json",
      "Authorization": "Bearer $token",
    };

    try {
      final response = await http.get(uri, headers: header);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        debugPrint(
            "responseData from getActiveRentalAgreementByProfileId Call: ${jsonEncode(responseData)}",
            wrapWidth: 1024);
        return RentalAgreementCountdownResponse.fromJson(
            responseData); // Corrected this line
      } else if (response.statusCode == 404) {
        print('Error: ${response.statusCode} - ${response.body}');
        print('navigating to create tenant screen');
        return null;
      }
    } catch (e) {
      print("EXCEPTION $e");
      return null;
    }
    return null;
  }

  Future<RoomsByProfileIdResponse?> getRoomByProfileId(
      {required String token, required int? profileId}) async {
    print("from getRoomByProfileId() token: $token");
    print("from getRoomByProfileId() profileId: $profileId");

    final uri = Uri.parse(
        "$rest/landlord/rental_agreement/get-rooms-by-profileid/$profileId");
    final header = {
      "Content-Type": "application/json",
      "Accept": "application/json",
      "Authorization": "Bearer $token",
    };

    try {
      final response = await http.get(uri, headers: header);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        debugPrint(
            "responseData from getActiveRentalAgreementByProfileId Call: ${jsonEncode(responseData)}",
            wrapWidth: 1024);
        return RoomsByProfileIdResponse.fromJson(
            responseData); // Corrected this line
      } else if (response.statusCode == 404) {
        print('Error: ${response.statusCode} - ${response.body}');
        print('navigating to create tenant screen');
        return null;
      }
    } catch (e) {
      print("EXCEPTION $e");
      return null;
    }
    return null;
  }

  Future<MaintenanceRequestResponse?> storeMaintenanceRequest(
      {required String token,
      required int? tenantId,
      required String title,
      required String description,
      required int roomId,
      required File? savedImage}) async {
    print(" API Call - storeMaintenanceRequest() token: $token");
    print(" API Call - storeMaintenanceRequest() tenantId: $tenantId");
    print(" API Call - storeMaintenanceRequest() title: $title");
    print(" API Call - storeMaintenanceRequest() description: $description");
    print(" API Call - storeMaintenanceRequest() roomId: $roomId");
    print(" API Call - storeMaintenanceRequest() savedImage: $savedImage");

    // Ensure required fields are not empty or null
    if (tenantId == null || title.isEmpty || description.isEmpty) {
      print(" Missing required fields");
      return null;
    }

    try {
      Uri url = Uri.parse(
          "$rest/tenant/maintenance_request/create-maintenance-request");

      var request = http.MultipartRequest("POST", url)
        ..headers['Authorization'] = "Bearer $token"
        ..headers['Accept'] = "application/json"
        ..fields['title'] = title
        ..fields['description'] = description
        ..fields['room_id'] = roomId.toString();

      if (tenantId != null) {
        request.fields['tenant_id'] = tenantId.toString();
      }

      // Handle file if image exists
      if (savedImage != null) {
        print("📷 Image exists at: ${savedImage.path}");
        request.files.add(
          await http.MultipartFile.fromPath(
            'images[]', // Match API field name
            savedImage.absolute.path,
          ),
        );
      } else {
        print(" No image selected");
      }

      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 201) {
        print("streamedResponse: ${streamedResponse}");
        print("✅ Maintenance request submitted!");
        return MaintenanceRequestResponse.fromJson(jsonDecode(response.body));
      } else {
        print(" Error: ${response.statusCode}");
        print("Response: ${response.body}");
        return null;
      }
    } catch (e) {
      print("storeMaintenanceRequest EXCEPTION: $e");
      return null;
    }
  }

  Future<MaintenanceRequestResponse?> getMaintenanceRequestsByTenantId(
      {required String token, required int? tenantId}) async {
    print("from getMaintenanceRequestsByTenantId(): token: $token");
    print("from getMaintenanceRequestsByTenantId(): tenantId: $tenantId");

    final uri = Uri.parse(
        "$rest/tenant/maintenance_request/index-by-tenant-id/$tenantId");
    final header = {
      "Content-Type": "application/json",
      "Accept": "application/json",
      "Authorization": "Bearer $token",
    };
    try {
      final response = await http.get(uri, headers: header);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        debugPrint(
            "responseData from getActiveRentalAgreementByProfileId Call: ${jsonEncode(responseData)}",
            wrapWidth: 1024);
        return MaintenanceRequestResponse.fromJson(
            responseData); // Corrected this line
      } else if (response.statusCode == 404) {
        print('Error: ${response.statusCode} - ${response.body}');
        print('navigating to create tenant screen');
        return null;
      }
    } catch (e) {
      print("EXCEPTION: $e");
      return null;
    }
    return null;
  }

  Future<MaintenanceRequestResponse?> patchMaintenanceRequest({
    required String token,
    required int? maintenanceRequestId,
    required String? newTitle,
    required String? newDescription,
    required File? newSavedImagePath,
    required int roomId,
  }) async {
    print("from patchMaintenanceRequest() token: $token");
    print(
        "from patchMaintenanceRequest() maintenanceRequestId: $maintenanceRequestId");
    print("from patchMaintenanceRequest() newTitle: $newTitle");
    print("from patchMaintenanceRequeest() newDescription: $newDescription");
    print(
        "from patchMaintenanceRequest() newSavedImagePath: $newSavedImagePath");
    print("from patchMaintenanceRequest() roomId: $roomId");

    // Validation: Check if maintenanceRequestId is null
    if (maintenanceRequestId == null) {
      print("❌ Missing maintenanceRequestId");
      return null;
    }

    // Validation: Check if at least one field (title or description) is provided
    if ((newTitle?.isEmpty ?? true) && (newDescription?.isEmpty ?? true)) {
      print(
          "❌ At least one field (title or description) must be provided for the update.");
      return null;
    }

    // Create the request URI
    final uri = Uri.parse(
        "$rest/tenant/maintenance_request/update/$maintenanceRequestId");

    // Start creating the request
    var request = http.MultipartRequest("POST", uri)
      ..headers['Authorization'] = "Bearer $token"
      ..headers['Accept'] = "application/json"
      ..fields['room_id'] = roomId.toString();

    // Add title if it's not null or empty
    if (newTitle?.isNotEmpty ?? false) {
      request.fields['title'] = newTitle!;
    }

    // Add description if it's not null or empty
    if (newDescription?.isNotEmpty ?? false) {
      request.fields['description'] = newDescription!;
    }

    // Add image if it's not null (this part can be skipped for now if you want to test without image)
    if (newSavedImagePath != null) {
      request.files.add(
        await http.MultipartFile.fromPath(
          'images[]', // Make sure this matches the key expected by the backend
          newSavedImagePath.path,
        ),
      );
    }

    try {
      // Send the request
      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      print("Server Response: ${response.statusCode}");
      print("Response Body: ${response.body}");

      // Handle the response
      if (response.statusCode == 200) {
        return MaintenanceRequestResponse.fromJson(jsonDecode(response.body));
      } else {
        print("Failed to update maintenance request");
        return null;
      }
    } catch (e) {
      print("Error in patchMaintenanceRequest: $e");
      return null;
    }
  }

  Future<MaintenanceRequestResponse?> showMaintenanceByMaintenanceId(
      {required String token, required int maintenanceId}) async {
    print("from showMaintenanceById() token: $token");
    print("from showMaintenanceById() maintenanceId: $maintenanceId");

    final uri =
        Uri.parse("$rest/tenant/maintenance_request/show/$maintenanceId");
    final header = {
      "Content-Type": "application/json",
      "Accept": "application/json",
      "Authorization": "Bearer $token",
    };

    try {
      final response = await http.get(uri, headers: header);
      if (response.statusCode == 200 || response.statusCode == 201) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        print(
            "responseData from showMaintenanceByMaintenanceId() Call: $responseData");
        return MaintenanceRequestResponse.fromJson(responseData);
      } else {
        print('Error: ${response.statusCode} - ${response.body}');
        return null;
      }
    } catch (e) {
      print("EXCEPTION: $e");
      return null;
    }
  }

  Future<MaintenanceRequestResponse?> changeStatusToCancel(
      {required String token, required int maintenanceId}) async {
    final uri = Uri.parse(
        "$rest/tenant/maintenance_request/cancel/$maintenanceId?status=cancelled");
    final header = {
      "Content-Type": "application/json",
      "Accept": "application/json",
      "Authorization": "Bearer $token",
    };

    try {
      final response = await http.patch(uri, headers: header);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        print("responseData from changeStatusToCancel() Call: $responseData");
        return MaintenanceRequestResponse.fromJson(responseData);
      } else {
        print('Error: ${response.statusCode} - ${response.body}');
        return null;
      }
    } catch (e) {
      print("EXCEPTION $e");
      return null;
    }
  }

// http://127.0.0.1:8000/api/tenant/billing/retrieve-latest-billing-for-monthly-rent/4
  Future<LatestRentBillingResponse?> getLatestMonthlyRentBilling(
      {required String token, required int userId}) async {
    final uri = Uri.parse(
        "$rest/tenant/billing/retrieve-latest-billing-for-monthly-rent/$userId");
    final header = {
      "Content-Type": "application/json",
      "Accept": "application/json",
      "Authorization": "Bearer $token",
    };

    try {
      final response = await http.get(uri, headers: header);
      if (response.statusCode == 200 || response.statusCode == 201) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        print(" getLatestMonthlyRentBilling Response body: ${response.body}");
        return LatestRentBillingResponse.fromJson(responseData);
      } else {
        print('Error: ${response.statusCode} - ${response.body}');
        return null;
      }
    } catch (e) {
      print("EXCEPTION: $e");
      return null;
    }
  }
}

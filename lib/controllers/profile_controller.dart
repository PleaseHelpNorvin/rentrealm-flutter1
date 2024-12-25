import 'dart:convert';
import 'dart:io';
import 'package:http_parser/http_parser.dart';
import 'package:image/image.dart' as img;
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import '../components/alert_utils.dart';
import '../controllers/auth_controller.dart';
import '../models/profile_model.dart';
import '../networks/apiservice.dart';

class ProfileController with ChangeNotifier {
  final ApiService apiService = ApiService();

  bool _isLoading = false;
  UserProfileResponse? _userProfile;

  bool get isLoading => _isLoading;
  UserProfileResponse? get userProfile => _userProfile;

  void setLoading(bool value) {
    _isLoading = value;
    // notifyListeners();
  }

  void setUserProfile(UserProfileResponse? profile) {
    _userProfile = profile;
    // notifyListeners();
  }

  Future<File> imageCompression(File pickedFile) async {
    // Decode the original image
    final originalImageData = img.decodeImage(pickedFile.readAsBytesSync());

    // Resize the image
    final resizedImage = img.copyResize(originalImageData!, width: 800);

    print("Decoded and resized image: $resizedImage");

    // Save the compressed image directly
    final appDocDir = await getApplicationDocumentsDirectory();
    final compressedFile = File('${appDocDir.path}/compressed_${pickedFile.path.split('/').last}')
      ..writeAsBytesSync(img.encodeJpg(resizedImage, quality: 80));

    print("Compressed image saved directly to persistent storage: ${compressedFile.path}");
    return compressedFile;

  }

 Future<void> createUserProfile(
  BuildContext context, String token, int userId, Map<String, String> profileData, File? compressedImageFile) async {
  try {
    setLoading(true);

    // Create the multipart request
    final request = await apiService.createMultipartRequest(
      userId: userId,
      token: token,
      data: profileData,
    );

    // Attach the image file if available
    if (compressedImageFile != null) {
      final imageFileName = compressedImageFile.path.split('/').last;
      request.files.add(await http.MultipartFile.fromPath(
        'image', // Field name expected by API
        compressedImageFile.path,
        filename: imageFileName,
        contentType: MediaType('image', 'jpeg'), // You can specify content type like jpeg, png, etc.
      ));
    }

    // Send the multipart request
    final response = await apiService.postUserProfile(request);

    if (response != null && response.success == true) {
      setUserProfile(response); // Store the profile if successful
      AlertUtils.showSuccessAlert(context, message: "Profile updated successfully!");
    } else {
      AlertUtils.showErrorAlert(context, message: "Failed to update profile.");
    }
  } catch (e) {
    print("Error creating/updating profile: $e");
    AlertUtils.showErrorAlert(context, message: "Something went wrong: $e");
  } finally {
    setLoading(false);
  }
}

  /// Load user profile
  Future<void> loadUserProfile(BuildContext context) async {
    final authController = Provider.of<AuthController>(context, listen: false);
    int? userId = authController.user?.data?.user.id;
    String? token = authController.token;

    if (token != null && userId != null) {
      try {
        await fetchUserProfile(context, token: token, userId: userId);
      } catch (e) {
        print("Error loading user profile: $e");
        AlertUtils.showErrorAlert(context, message: "Failed to load user profile.");
      }
    } else {
      AlertUtils.showErrorAlert(context, message: "User not authenticated.");
    }
  }

  /// Fetch user profile data
  Future<void> fetchUserProfile(context, {required String token, required int userId}) async {
    try {
      setLoading(true);

      final response = await apiService.getUserProfile(token: token, userId: userId);

      if (response != null && response.success) {
        setUserProfile(response);
        print("User profile Id $userId  fetched successfully:");
      } else {
        setUserProfile(null);
        AlertUtils.showInfoAlert(
          context,
          title: "Profile Not Found",
          message: "Please create your profile first!",
          onConfirmBtnTap: () {
            Navigator.pushReplacementNamed(context, '/createprofile1');
          },
        );
      }
    } catch (e) {
      print("Error fetching user profile: $e");
      AlertUtils.showErrorAlert(context, title: "Error", message: "Something went wrong: $e");
    } finally {
      setLoading(false);
    }
  }
}

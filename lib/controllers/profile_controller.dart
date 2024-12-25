import 'dart:convert';
import 'dart:io';
import 'package:http_parser/http_parser.dart';
import 'package:image/image.dart' as img;
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import '../components/alert_utils.dart';
import '../controllers/auth_controller.dart';
import '../models/profile_model.dart';
import '../networks/apiservice.dart';

class ProfileController with ChangeNotifier {
  final ApiService apiService = ApiService();
  final ImagePicker _picker = ImagePicker();

  File? _image;
  File? get image => _image;


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

   // Function to pick image from camera
  Future<void> pickImage(BuildContext context, ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      _image = File(pickedFile.path);
      print("picked Image : $_image");
      notifyListeners();  // Notify UI to update when the image is picked
      // You can perform image compression and send it here if needed
      // await compressAndSendImage(_image!);
      File compressedFile = await imageCompression(context, File(pickedFile.path) );
      sendProfilePicture(context, compressedFile);
    }
  }

  Future<File> imageCompression(BuildContext context, File pickedFile) async {
    // Decode the original image
    final originalImageData = img.decodeImage(pickedFile.readAsBytesSync());

    // Resize the image
    final resizedImage = img.copyResize(originalImageData!, width: 3000);

    print("Decoded and resized image: $resizedImage");

    // Save the compressed image directly
    final appDocDir = await getApplicationDocumentsDirectory();
    final compressedFile = File('${appDocDir.path}/compressed_${pickedFile.path.split('/').last}')
      ..writeAsBytesSync(img.encodeJpg(resizedImage, quality: 80));

    print("Compressed image saved directly to persistent storage: ${compressedFile.path}");
    return compressedFile;
  }

  Future<void> sendProfilePicture(BuildContext context, File compressedFile) async {
    final authController = Provider.of<AuthController>(context, listen: false);
    int? userId = authController.user?.data?.user.id;
    String? token = authController.token;
    
    // Check if token and userId are null
    if (userId == null || token == null) {
      AlertUtils.showErrorAlert(context, message: 'User is not authenticated.');
      return; // Exit the method if userId or token is null
    }

    print("sendProfilePicture() called with: ${compressedFile}");

    if (compressedFile == null) {
      AlertUtils.showErrorAlert(context, message: 'No file selected');
    } else {
      print("sendProfilePicture() called with: ${compressedFile.path}");
      print("File exists: ${await compressedFile.exists()}");  // Check if file exists
    } 
    await apiService.postProfilePicture(
      token: token,
      userId: userId,
      compressedFile: compressedFile,
    );
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

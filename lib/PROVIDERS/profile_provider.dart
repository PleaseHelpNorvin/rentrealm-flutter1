import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as img;
import 'package:provider/provider.dart';
import 'package:path_provider/path_provider.dart';
import 'package:rentealm_flutter/screens/homelogged.dart';
import '../PROVIDERS/auth_provider.dart';

import '../CUSTOMS/alert_utils.dart';
import '../MODELS/profile_model.dart';
import '../NETWORKS/apiservice.dart';
import '../SCREENS/PROFILE/CREATE/create_profile_screen1.dart';

class ProfileProvider extends ChangeNotifier {
  final ApiService apiService = ApiService();
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  File? _image;
  File? get image => _image;

  String? _token;
  String? get token => _token;

  UserProfileResponse? _userProfile;
  UserProfileResponse? get userProfile => _userProfile;

  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void setImage(File? image) {
    _image = image;
    notifyListeners();
  }

  void setUserProfile(UserProfileResponse? profile) {
    _userProfile = profile;
    notifyListeners();
  }

  Future<void> pickImage(BuildContext context, ImageSource source) async {
    final ImagePicker _picker = ImagePicker();

    final pickedFile = await _picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      _image = File(pickedFile.path);
      notifyListeners();
      setImage(_image);
      print("picked Image : $_image");
      // Notify UI to update when the image is picked
      // You can perform image compression and send it here if needed
      // await compressAndSendImage(_image!);
      File compressedFile =
          await imageCompression(context, File(pickedFile.path));
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
    final compressedFile =
        File('${appDocDir.path}/compressed_${pickedFile.path.split('/').last}')
          ..writeAsBytesSync(img.encodeJpg(resizedImage, quality: 80));

    print(
        "Compressed image saved directly to persistent storage: ${compressedFile.path}");
    return compressedFile;
  }

  Future<void> sendProfilePicture(
      BuildContext context, File compressedFile) async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    int? userId = authProvider.user?.data?.user.id;
    String? token = authProvider.token;

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
      print(
          "File exists: ${await compressedFile.exists()}"); // Check if file exists
    }
    final response = await apiService.postProfilePicture(
      token: token,
      userId: userId,
      compressedFile: compressedFile,
    );

    if (response != null && response.success) {
      // Update user profile with the new picture URL
      String updatedProfilePictureUrl = response.data.profilePictureUrl;

      // You should update the profileController with the new data
      // _userProfile?.data.profilePictureUrl = updatedProfilePictureUrl;

      // Notify listeners to update the UI
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _userProfile?.data.profilePictureUrl = updatedProfilePictureUrl;

        // You should update the profileController with the new data
        setUserProfile(_userProfile);

        // AlertUtils.showSuccessAlert(
        //   context,
        //   title: "Profile Picture Updated",
        //   message: "Your profile picture has been updated successfully.",
        // );
      });
    } else {
      AlertUtils.showErrorAlert(context,
          message: "Failed to update profile picture.");
    }
    // await loadUserProfile(context);
  }

  Future<void> onCreateUserProfile(
      BuildContext context,
      String phoneNumberController,
      String socialMediaLinkController,
      String occupationController,
      String line1Controller,
      String line2Controller,
      String provinceController,
      String countryController,
      String postalCodeController,
      List<Map<String, dynamic>> identificationData) async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    int? userId = authProvider.user?.data?.user.id;
    String? token = authProvider.token;
    String? driverLicenseNumber;
    String? nationalIdNumber;
    String? passportNumber;
    String? socialSecurityNumber;

    for (var idData in identificationData) {
      switch (idData['type']) {
        case 'Driver License Number':
          driverLicenseNumber = idData['controller'].text;
          break;
        case 'National ID':
          nationalIdNumber = idData['controller'].text;
          break;
        case 'Passport Number':
          passportNumber = idData['controller'].text;
          break;
        case 'Social Security Number':
          socialSecurityNumber = idData['controller'].text;
          break;
        default:
          print('Unknown identification type: ${idData['type']}');
      }
    }
    print('User_id: $userId');
    print('token: $token');
    print('Phone Number: $phoneNumberController');
    print('Social Media Link: $socialMediaLinkController');
    print('Occupation: $occupationController');
    print('Line 1 Address: $line1Controller');
    print('Line 2 Address: $line2Controller');
    print('Province: $provinceController');
    print('Country: $countryController');
    print('Postal Code Controller: $postalCodeController');
    print('Driver License Number: $driverLicenseNumber');
    print('National ID Number: $nationalIdNumber');
    print('Passport Number: $passportNumber');
    print('Social Security Number: $socialSecurityNumber');
    final response = await apiService.postProfileData(
        userId: userId,
        token: token,
        phoneNumberController: phoneNumberController,
        socialMediaLinkController: socialMediaLinkController,
        occupationController: occupationController,
        line1Controller: line1Controller,
        line2Controller: line2Controller,
        provinceController: provinceController,
        countryController: countryController,
        postalCodeController: postalCodeController,
        driverLicenseNumber: driverLicenseNumber,
        nationalIdNumber: nationalIdNumber,
        passportNumber: passportNumber,
        socialSecurityNumber: socialSecurityNumber);

    if (response != null && response.success) {
      setUserProfile(response);
      AlertUtils.showSuccessAlert(
        context,
        title: "Profile Created Successfully",
        message: "Thank You For Creating Profile",
        onConfirmBtnTap: () {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const HomeLoggedScreen()),
            );
          });
        },
      );
    } else {
      setUserProfile(null);
      AlertUtils.showErrorAlert(context,
          title: "Its Not You Its Us",
          message: "Something wrong with the server", onConfirmBtnTap: () {
        return;
      });
    }
  }

  Future<bool> loadUserProfile(BuildContext context) async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    int? userId = authProvider.user?.data?.user.id;
    String? token = authProvider.token;

    if (token != null && userId != null) {
      try {
        await fetchUserProfile(context, token: token, userId: userId);
        return true;
      } catch (e) {
        print("Error loading user profile: $e");
        AlertUtils.showErrorAlert(context,
            message: "Failed to load user profile.");
      }
      return false;
    } else {
      AlertUtils.showErrorAlert(context, message: "User not authenticated.");
      return false;
    }
  }

  Future<void> fetchUserProfile(context,
      {required String token, required int userId}) async {
    try {
      setLoading(true);

      final response =
          await apiService.getUserProfile(token: token, userId: userId);

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
            Navigator.pushReplacementNamed(
                context, '/createprofile1'); // Then navigate
          },
        );
      }
    } catch (e) {
      print("Error fetching user profile: $e");
      AlertUtils.showErrorAlert(context,
          title: "Error", message: "Something went wrong: $e");
    } finally {
      setLoading(false);
    }
  }

  Future<void> onUpdateUserAddress(
    BuildContext context,
    String line1Controller,
    String line2Controller,
    String provinceController,
    String countryController,
    String postalCodeController,
  ) async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final userId = authProvider.user?.data?.user.id ?? 0;
    final token = authProvider.token ?? 'no token';

    // print('User_id: $userId');
    // print('token: $token');
    // print('Line 1 Address: $line1Controller');
    // print('Line 2 Address: $line2Controller');
    // print('Province: $provinceController');
    // print('Country: $countryController');
    // print('Postal Code Controller: $postalCodeController');

    try {
      _isLoading = true;
      notifyListeners();

      final response = await apiService.updateUserAddress(
        userId: userId,
        token: token,
        line1Controller: line1Controller,
        line2Controller: line2Controller,
        provinceController: provinceController,
        countryController: countryController,
        postalCodeController: postalCodeController,
      );

      if (response != null && response.success) {
        setUserProfile(userProfile);
        AlertUtils.showSuccessAlert(
          context,
          title: "Update Success",
          message: "your address updated successfully",
          onConfirmBtnTap: () {
            Navigator.pop(
                context); // Go back to ProfileScreen if it was opened via Navigator

            WidgetsBinding.instance.addPostFrameCallback((_) {
              // Navigate back to Profile screen
              Navigator.pop(
                  context); // This will go back to the previous screen, which is Profile.
            });
          },
        );
      } else {}
    } catch (e) {}
  }

  Future<void> onUpdateUserProfile(
    BuildContext context,
    String phoneNumberController,
    String socialMediaLinksController,
    String occupationController,
  ) async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final userId = authProvider.user?.data?.user.id ?? 0;
    final token = authProvider.token ?? 'no token';

    print('User_id: $userId');
    print('token: $token');
    print('Phone Number: $phoneNumberController');
    print('Social Media Links: $socialMediaLinksController');
    print('Occupation: $occupationController');

    try {
      _isLoading = true;
      notifyListeners();

      final response = await apiService.updateUserProfile(
        userId: userId,
        token: token,
        phoneNumberController: phoneNumberController,
        socialMediaLinkController: socialMediaLinksController,
        occupationController: occupationController,
      );

      if (response != null && response.success) {
        setUserProfile(response);

        // await loadUserProfile(context);
        AlertUtils.showSuccessAlert(
          context,
          title: "Update Success",
          message: "your Profile updated successfully",
          onConfirmBtnTap: () {
            Navigator.pop(context);
            WidgetsBinding.instance.addPostFrameCallback((_) {
              Navigator.pop(context);
            });
          },
        );
        print('response: $response');
      } else {
        print('Error: $response');
      }
    } catch (e) {}
  }

  Future<void> onUpdateIdentifications(
    BuildContext context,
    String driverLicenseNumber,
    String nationalIdNumber,
    String passportNumber,
    String socialSecurityNumber,
  ) async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final userId = authProvider.user?.data?.user.id ?? 0;
    final token = authProvider.token ?? 'no token';

    try {
      final response = await apiService.updateUserIdentifications(
        userId: userId,
        token: token,
        driverLicenseNumber: driverLicenseNumber,
        nationalIdNumber: nationalIdNumber,
        passportNumber: passportNumber,
        socialSecurityNumber: socialSecurityNumber,
      );
      if (response != null && response.success) {
        setUserProfile(response);
        AlertUtils.showSuccessAlert(
          context,
          title: "Update Success",
          message: "your Identificaitons updated successfully",
          onConfirmBtnTap: () {
            Navigator.pop(context);
            WidgetsBinding.instance.addPostFrameCallback((_) {
              Navigator.pop(context);
            });
          },
        );
        print('response: $response');
      } else {
        print('response: $response');
      }
    } catch (e) {
      // Catch any error and print it to the console.
      print("Error in onUpdateIdentifications: $e");
    }
  }
}

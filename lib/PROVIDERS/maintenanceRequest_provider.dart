import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:path_provider/path_provider.dart';

import '../models/rentalAgreement_model.dart';
import '../networks/apiservice.dart';
import 'auth_provider.dart';
import 'profile_provider.dart';

class MaintenancerequestProvider extends ChangeNotifier {
  final ApiService apiService = ApiService();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  late String token;
  late int? profileId;

  List<RoomByProfileId>_roomByProfileIdList = [];
  List<RoomByProfileId> get roomByProfileIdList => _roomByProfileIdList;
  

  void initAuthDetails(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final profileProvider =
        Provider.of<ProfileProvider>(context, listen: false);

    token = authProvider.token ?? 'no token';
    profileId = profileProvider.userProfile?.data.id;
  }


  Future<void> fetchRoomByProfileId(BuildContext context) async {
    initAuthDetails(context);

    if (token == 'no token' || profileId == null) {
      print("Error: Missing authentication details");
      print("token: $token");
      print("profileId: $profileId");
      return;
    }

    _isLoading = true;
    notifyListeners(); 

    try {
      final response = await apiService.getRoomByProfileId(token: token, profileId: profileId);

      if (response != null && response.success) {
        print(" fetchRoomByProfileId() _roomByProfileIdList: ${response.data.length}");
        _roomByProfileIdList = response.data; 
        print("Fetched Rooms: $_roomByProfileIdList");
      } else {
        print("No rooms found for profile ID: $profileId");
        _roomByProfileIdList = [];
      }
    } catch (e) {
      print("Error fetching rooms: $e");
      _roomByProfileIdList = [];
    } finally {
      _isLoading = false;
      notifyListeners(); 
    }
  }

  Future<File> saveImagePermanently(File imageFile) async {
    final directory = await getApplicationDocumentsDirectory();
    final newPath = '${directory.path}/${DateTime.now().millisecondsSinceEpoch}.jpg';
    final newImage = await imageFile.copy(newPath);
    return newImage;
  }

  Future<void> createMaintenanceRequest(
  BuildContext context, 
  String title,
  String description, 
  int roomId,
  File? imageFile
) async {
  initAuthDetails(context);

  if (token == 'no token' || profileId == null) {
    print("❌ Error: Missing authentication details");
    print("🛑 token: $token");
    print("🛑 profileId: $profileId");
    return;
  }

  print("📌 from createMaintenanceRequest title: $title");
  print("📌 from createMaintenanceRequest description: $description");
  print("📌 from createMaintenanceRequest roomId: $roomId");
  print("📌 from createMaintenanceRequest imageFile: $imageFile");

  // File? savedImage;
  
  // if (imageFile != null) {
  //   savedImage = await saveImagePermanently(imageFile);
  //   print("✅ New image path: ${savedImage.path}");
  // } else {
  //   print("⚠️ No image selected");
  // }

  // final response = await apiService.storeMaintenanceRequest(
  //   token: token, 
  //   profileId: profileId, 
  //   title: title, 
  //   description: description, 
  //   roomId: roomId, 
  //   savedImage: savedImage // This now has a value or remains null
  // );

  // if (response != null) {
  //   print("🎉 Maintenance request submitted successfully!");
  // } else {
  //   print("❌ Failed to submit maintenance request.");
  // }
}

}
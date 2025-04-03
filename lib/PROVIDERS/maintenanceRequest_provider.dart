import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'package:path_provider/path_provider.dart';
import 'package:rentealm_flutter/PROVIDERS/tenant_provider.dart';

import '../models/maintenanceRequest_model.dart';
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
  late int? tenantId;

  List<RoomByProfileId>_roomByProfileIdList = [];
  List<RoomByProfileId> get roomByProfileIdList => _roomByProfileIdList;

  List<MaintenanceRequest> _maintenanceRequests = [];
  List<MaintenanceRequest> get maintenanceRequests => _maintenanceRequests;

  void updateMaintenanceRequestsList(List<MaintenanceRequest> requests) {
    _maintenanceRequests = requests;
    notifyListeners(); // ✅ Notify UI after list update
  }

  MaintenanceRequest? _selectedMaintenanceRequest;
  MaintenanceRequest? get selectedMaintenanceRequest => _selectedMaintenanceRequest;
  
  File? _newImage; // New image picked by the user
  String? _currentImage; // Current image URL/Path from the API

  String? get currentImage => _currentImage;
    File? get newImage => _newImage;

  void setSelectedMaintenanceRequest(
    int id, 
    String? title, 
    String? description, 
    File? newSavedImagePath, 
    int? roomId,
    String? status,
  ) {
    _selectedMaintenanceRequest = _maintenanceRequests.firstWhere(
      (request) =>
          request.id == id || 
          (title != null && request.title == title) || 
          (description != null && request.description == description) || 
          (newSavedImagePath != null && request.images.isNotEmpty && 
          request.images.contains(newSavedImagePath.path)) ||  // ✅ Check if image exists
          (roomId != null && request.roomId == roomId) ||  // ✅ Match roomId if provided
          (roomId != null && request.status == status),
      orElse: () => MaintenanceRequest(
        id: 0,
        ticketCode: '',
        tenantId: 0,
        roomId: 0,
        title: 'Not Found',
        description: 'No description available',
        images: [],
        status: 'Unknown',
        requestedAt: DateTime.now(),
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
    );

    print("✅ Updated selectedMaintenanceRequest: ${_selectedMaintenanceRequest?.title}, ${_selectedMaintenanceRequest?.description} ${_selectedMaintenanceRequest?.images.first}");

    notifyListeners(); // Notify UI to update
  }


  void updateNewImage(File newImage) {
      _newImage = newImage;
      print("from updateNewImage() $newImage");
      notifyListeners();
  }

  void clearNewImage() {
    _newImage = null;
    notifyListeners();
  }
  
  void initAuthDetails(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final profileProvider =
        Provider.of<ProfileProvider>(context, listen: false);
    final tenantProvider = Provider.of<TenantProvider>(context, listen: false);

    token = authProvider.token ?? 'no token';
    profileId = profileProvider.userProfile?.data.id;
    tenantId = tenantProvider.tenant?.data.tenant.id;
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

  Future<void>updateMaintenanceRequest(
    BuildContext context, 
    String newTitle,
    String newDescription, 
    int roomId,
    File? imageFile,
    int maintenanceRequestId
  ) async {
    initAuthDetails(context);
    
    if (token == 'no token' ) {
      print("❌ Missing authentication details");
      return;
    }
    File? newSavedImagePath;
    if (imageFile != null) {
        newSavedImagePath = await saveImagePermanently(imageFile);
        print("✅ New image path: ${newSavedImagePath.path}");
      } else {
        print("⚠️ No image selected");
      }

      print("from updateMaintenanceRequest() token: token $token");
      print("from updateMaintenanceRequest() token: maintenanceRequestId $maintenanceRequestId");
      print("from updateMaintenanceRequest() newTitle: $newTitle");
      print("from updateMaintenanceRequest() newDescription: $newDescription");
      print("from updateMaintenanceRequest() newSavedImagePath: $newSavedImagePath");
      print("from updateMaintenanceRequest() roomId: $roomId");

    try {
      final response = await apiService.patchMaintenanceRequest(
        token: token, 
        maintenanceRequestId: maintenanceRequestId, 
        newTitle: newTitle, 
        newDescription: newDescription, 
        newSavedImagePath: newSavedImagePath, 
        roomId: roomId
      );

      if (response != null && response.success) {
        if (response.data != null) {
          print("✅ Response success - Updating selectedMaintenanceRequest");
          
          // ✅ Use setSelectedMaintenanceRequest to update the selected maintenance request
          setSelectedMaintenanceRequest(maintenanceRequestId, newTitle, newDescription,newSavedImagePath,roomId, _selectedMaintenanceRequest?.status);

          // ✅ Update the list of maintenance requests
          await fetchMaintenanceRequestListByTenantId(context);
          // updateMaintenanceRequestsList(response.data.maintenanceRequests);

          // await fetchMaintenanceRequestListByTenantId(context);
        } else {
          print("⚠️ No maintenance request found in the response.");
        }
      } else {
        print("❌ Failed to update maintenance request: ${response?.message}");
          
      } 
    } catch (e) {
      print("EXCEPTION: $e");
      return;
    }

  }

  Future<void> createMaintenanceRequest(
    BuildContext context, 
    String title,
    String description, 
    int roomId,
    File? imageFile
  ) async {
    try {
      initAuthDetails(context);
      // int? tenantId = Provider.of<TenantProvider>(context, listen: false).tenant?.data.tenant.id;

      if (token == 'no token' || profileId == null || tenantId == null) {
        print("❌ Missing authentication details");
        return;
      }

      File? savedImage;
      if (imageFile != null) {
        savedImage = await saveImagePermanently(imageFile);
        print("✅ New image path: ${savedImage.path}");
      } else {
        print("⚠️ No image selected");
      }

      final response = await apiService.storeMaintenanceRequest(
        token: token, 
        tenantId: tenantId,
        title: title, 
        description: description, 
        roomId: roomId, 
        savedImage: savedImage
      );

      if (response != null) {
          print("✅ API response: ${response.data}");

        print("Maintenance request submitted successfully!");
          _maintenanceRequests.addAll(response.data.maintenanceRequests);

        notifyListeners();
        await fetchMaintenanceRequestListByTenantId(context);
      } else {
        print("Failed to submit maintenance request.");
        return;
      }
    } catch (e) {
      print(" Error during request: $e");
    }
  }

  Future<void>fetchMaintenanceRequestSingleObject(BuildContext context, int? maintenanceId) async {
    initAuthDetails(context);
    print("from fetchMaintenanceRequestSingleObject(): token: $token");

    if (token == 'no token' || tenantId == null) {
      print("Error: Missing authentication details");
      print("token: $token");
      return;
    }

    if (maintenanceId == null) {
      print("no maintenance Id detected: $maintenanceId");
      return;
    }

    _isLoading = true;
    notifyListeners(); 
    
    try {
      final response = await apiService.showMaintenanceByMaintenanceId(token: token, maintenanceId: maintenanceId);
      if(response != null && response.success){
        _selectedMaintenanceRequest = response.data.maintenanceRequests.first;
        notifyListeners();
      }
    } catch (e) {
      print("EXCEPTION $e");
      return;
    }

  }

  Future<void>fetchMaintenanceRequestListByTenantId(context) async {
    initAuthDetails(context);

    print("from fetchIndexByTenantId(): token: $token");
    print("from fetchIndexByTenantId(): tenantId: $tenantId");

    if (token == 'no token' || tenantId == null) {
      print("Error: Missing authentication details");
      print("token: $token");
      print("tenantId: $profileId");
      return;
    }

    _isLoading = true;
    notifyListeners(); 
    try {
      final response = await apiService.getMaintenanceRequestsByTenantId(token: token, tenantId: tenantId);

      if (response != null && response.success) {
        _maintenanceRequests = response.data.maintenanceRequests;
        notifyListeners();
        print("test");
        // await fetchMaintenanceRequestSingleObject(context, _maintenanceRequests.first.id);
        
      } else {
        print("Failed to fetch maintenance request.");
        return;
      }

    } catch (e) {
      print("EXCEPTION: $e");
      return;
    }
  }


  Future<void>patchStatusToCancel(BuildContext context, maintenanceId) async {
    print("from PatchStatusToCancel() maintenanceId: $maintenanceId");
    initAuthDetails(context);

    
    print("from fetchIndexByTenantId(): token: $token");
    print("from fetchIndexByTenantId(): tenantId: $tenantId");

    if (token == 'no token' || tenantId == null) {
      print("Error: Missing authentication details");
      print("token: $token");
      print("tenantId: $profileId");
      return;
    }

    _isLoading = true;
    notifyListeners(); 

    try {
      final response = await apiService.changeStatusToCancel(token: token, maintenanceId: maintenanceId);
      if (response != null && response.success) {
        String? imagePathString = selectedMaintenanceRequest?.getImages[0]; // Get the first image path as a string
          if (imagePathString == null ) {
            print("no image path string detected");
            return;
          }
        File? imagePath = File(imagePathString);
        setSelectedMaintenanceRequest(maintenanceId, _selectedMaintenanceRequest?.title, _selectedMaintenanceRequest?.description, imagePath, _selectedMaintenanceRequest?.roomId, response.data.maintenanceRequests.first.status);
        print(" ${response.data.maintenanceRequests}");
      }else {
        print("from patchStatusToCancel error ${response?.data.maintenanceRequests.first}");
      }
    } catch (e) {
      print("EXCEPTION: $e");
      return;
    }
  }


}
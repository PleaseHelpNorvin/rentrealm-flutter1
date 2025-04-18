import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'package:rentealm_flutter/API/rest.dart';
import 'package:rentealm_flutter/PROVIDERS/auth_provider.dart';
import 'package:rentealm_flutter/models/property_model.dart';
import 'package:rentealm_flutter/networks/apiservice.dart';
import '../MODELS/room_model.dart';
import '../SCREENS/TENANT/CREATE/create_tenant_screen2.dart';

class RoomProvider extends ChangeNotifier {
  final ApiService apiService = ApiService();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  List<Room> _room = [];
  List<Room> get rooms => _room;
  
  Room? _singleRoom;
  Room? get singleRoom => _singleRoom;

  Future<void> fetchRoom(BuildContext context, int propertyId) async {
    // final authProvider = Provider.of<AuthProvider>(context, listen: false);
    // String? token = authProvider.token;

    // print("Token: $token");
    print("Property ID: $propertyId");

    // if (token == null) {
    //   print('Token is null, cannot fetch Room');
    //   return;
    // }

    _isLoading = true;
    notifyListeners();

    try {
      final response = await apiService
        .getRoomsByPropertyId(propertyId: propertyId)
        .timeout(const Duration(seconds: 15));

      if (response != null) {
        _room = response.data.rooms.map((room) {
          return Room(
            id: room.id,
            propertyId: room.propertyId,
            roomPictureUrls: _cleanRoomPictureUrls(room.roomPictureUrls), 
            roomCode: room.roomCode,
            description: room.description,
            roomDetails: room.roomDetails,
            category: room.category,
            rentPrice: room.rentPrice,
            capacity: room.capacity,
            currentOccupants: room.currentOccupants,
            minLease: room.minLease,
            size: room.size,
            status: room.status,
            unitType: room.unitType,
            createdAt: room.createdAt,
            updatedAt: room.updatedAt,
          );
        }).toList();

        print("Rooms fetched successfully: ${_room.length}");
      } else {
        print("Failed to fetch Rooms");
      }
    } catch (e) {
      print('Exception fetching Room: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Helper function to clean room picture URLs
  List<String> _cleanRoomPictureUrls(List<String>? urls) {


    print("cleanedURl: $urls");   
    if (urls == null || urls.isEmpty) return [];
    
    String correctBaseUrl = Rest.baseUrl.replaceAll('api', 'storage/');
    
    return urls.map((url) {
      String cleanedUrl = url.replaceFirst(RegExp(r'^https?://[^/]+/storage/'), '');
      return "$correctBaseUrl$cleanedUrl"; // Append the correct base URL
    }).toList();
  }

    // getRoomById
  Future<void> fetchRoomById(BuildContext context, int roomId) async {

    print("Room ID: $roomId");



    _isLoading = true;
    notifyListeners();

    try {
      final response = await apiService
          .getRoomById(roomId: roomId)
          .timeout(const Duration(seconds: 15));

      if (response != null) {
        _singleRoom = response.data.rooms.first; // ✅ Assign the first (only) room
        print("Room fetched successfully: ${_singleRoom?.roomPictureUrls}");
      } else {
        print("No rooms found in response.");
      }
    } catch (e) {
      print('Exception fetching Room: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  
}


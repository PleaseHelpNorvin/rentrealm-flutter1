import 'package:flutter/material.dart';
import 'package:rentealm_flutter/networks/apiservice.dart';
import 'auth_provider.dart';
import '../models/pickedRoom_model.dart';

class PickedroomProvider extends ChangeNotifier {
  final ApiService apiService = ApiService();
  final AuthProvider authProvider;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  late String token;
  late int userId;

  bool hasReservation = false; 

  List<PickedRoomDetails>? _pickedRooms;
  
  // ✅ Getter for picked rooms
  List<PickedRoomDetails>? get pickedRooms => _pickedRooms;

  // ✅ Setter for picked rooms
  set pickedRooms(List<PickedRoomDetails>? rooms) {
    _pickedRooms = rooms;
    notifyListeners();  // Notify UI about changes
  }

  PickedroomProvider({required this.authProvider}) {
    token = authProvider.token ?? 'no token';
    userId = authProvider.userId ?? 0;
  }

  // ✅ Fetch picked rooms for user
  Future<void> fetchPickedRooms() async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await apiService.getPickedRoomsByUser(userId: userId, token: token);
      
      if (response != null && response.success) {
        pickedRooms = response.data.pickedRooms;
        print("the state reached here but not yet set nofitify()");
      } else {
        print("Failed to fetch picked rooms.");
      }
    } catch (e) {
      print("Error in fetchPickedRooms: $e");
    }

    _isLoading = false;
    notifyListeners();
  }

  // ✅ Add room for user and update list
  Future<void> addRoomForUser(int roomId) async {
    if (token == 'no token') {
      print("Error: Missing authentication details");
      return;
    }

    print("Picked roomId: $roomId");
    print("Token: $token");
    print("UserId: $userId");

    try {
      final response = await apiService.postPickedRoomByUser(
        userId: userId, 
        token: token, 
        roomId: roomId,
      );

      if (response != null && response.success) {
        print("Room successfully picked for user.");
        
       
      } else {
        print("Failed to pick room. API response was unsuccessful.");
      }
    } catch (e) {
      print("Error in addRoomForUser: $e");
    }
  }
}

import 'package:flutter/material.dart';
import 'package:rentealm_flutter/networks/apiservice.dart';
import 'auth_provider.dart';
import '../models/pickedRoom_model.dart';

class PickedRoomProvider extends ChangeNotifier {
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

  PickedRoomDetails? get singlePickedRoom =>
      _pickedRooms?.isNotEmpty == true ? _pickedRooms!.first : null;

  // ✅ Setter for picked rooms
  set pickedRooms(List<PickedRoomDetails>? pickedRoomsByUser) {
    _pickedRooms = pickedRoomsByUser;
    notifyListeners(); // Notify UI about changes
  }

  set singlePickedRoom(PickedRoomDetails? pickedRoom) {
    _pickedRooms = pickedRoom != null ? [pickedRoom] : [];
    notifyListeners(); // Notify UI about changes
  }

  PickedRoomProvider({required this.authProvider}) {
    token = authProvider.token ?? 'no token';
    userId = authProvider.userId ?? 0;
  }

  // ✅ Fetch picked rooms for user
  Future<void> fetchPickedRooms({
    required int userProfileUserId,
    required String token,
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      print("Fetching picked rooms...");
      print("Token: $token");
      print("UserId: $userId");

      final response =
          await apiService.getPickedRoomsByUser(userId: userId, token: token);

      if (response != null &&
          response.success) {
        pickedRooms = response.data.pickedRooms; // ✅ Update list
        singlePickedRoom = response.data.pickedRooms.isNotEmpty
            ? response.data.pickedRooms.first
            : null; // ✅ Update single room

        print("Picked rooms updated successfully.");

        print("pickedRoomslist ${pickedRooms?.length}");
        print("singlePickedRoom ${singlePickedRoom?.room.id}");
      } else {
        print("Failed to fetch picked rooms.");
        pickedRooms = []; // Ensure list is not null
        singlePickedRoom = null;
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

        await fetchPickedRooms(
          token: token,
          userProfileUserId: userId,
        );
      } else {
        print("Failed to pick room. API response was unsuccessful.");
      }
    } catch (e) {
      print("Error in addRoomForUser: $e");
    }
  }
// destroyPickedRoomResponse = await apiService.deletePickedRoomById(pickedRoomId: pickedRoomId, token: token); 

  Future<void> destroyPickedRoom({
  required int pickedRoomId,
  required String token,
}) async {
  print("from destroyPickedRoom() pickedRoomId: $pickedRoomId");
  print("from destroyPickedRoom() token: $token");

  try {
    final response = await apiService.deletePickedRoomById(
      pickedRoomId: pickedRoomId,
      token: token,
    );

    if (response != null && response.success) {
      print("Room successfully removed.");

      // Remove the deleted room from the list
      _pickedRooms?.removeWhere((room) => room.id == pickedRoomId);
      
      // Update singlePickedRoom if necessary
      singlePickedRoom = _pickedRooms!.isNotEmpty ? _pickedRooms!.first : null;

      notifyListeners(); // ✅ Notify UI about the change
    } else {
      print("Failed to remove the picked room.");
    }
  } catch (e) {
    print("Error in destroyPickedRoom: $e");
  }
}
}

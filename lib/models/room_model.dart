import 'dart:convert';
import '../API/rest.dart';

class RoomResponse {
  final bool success;
  final String message;
  final RoomData data;

  RoomResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory RoomResponse.fromJson(Map<String, dynamic> json) {
    return RoomResponse(
      success: json['success'],
      message: json['message'],
      data: RoomData.fromJson(json['data']),
    );
  }
}


class RoomData {
  final List<Room> rooms;

  RoomData({required this.rooms});

  factory RoomData.fromJson(Map<String, dynamic> json) {
    var roomsJson = json['rooms'];

    if (roomsJson is List) {
      // ✅ If "rooms" is a list, parse normally
      return RoomData(
        rooms: List<Room>.from(roomsJson.map((x) => Room.fromJson(x))),
      );
    } else if (roomsJson is Map<String, dynamic>) {
      // ✅ If "rooms" is a single object, wrap it in a list
      return RoomData(
        rooms: [Room.fromJson(roomsJson)],
      );
    } else {
      throw Exception('Invalid room data format');
    }
  }
}


// class RoomData {
//   final List<Room> rooms;

//   RoomData({required this.rooms});

//   factory RoomData.fromJson(Map<String, dynamic> json) {
//     return RoomData(
//       rooms: List<Room>.from(json['rooms'].map((x) => Room.fromJson(x))),
//     );
//   }
// }

class Room {
  final int id;
  final int propertyId;
  final List<String> roomPictureUrls;
  final String roomCode;
  final String description;
  final String roomDetails;
  final String category;
  final double rentPrice;
  final int capacity;
  final int currentOccupants;
  final int minLease;
  final String size;
  final String status;
  final String unitType;
  final DateTime createdAt;
  final DateTime updatedAt;

  Room({
    required this.id,
    required this.propertyId,
    required this.roomPictureUrls,
    required this.roomCode,
    required this.description,
    required this.roomDetails,
    required this.category,
    required this.rentPrice,
    required this.capacity,
    required this.currentOccupants,
    required this.minLease,
    required this.size,
    required this.status,
    required this.unitType,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Room.fromJson(Map<String, dynamic> json) {
  return Room(
    id: json['id'],
    propertyId: json['property_id'],
    roomPictureUrls: _parseRoomPictureUrls(json['room_picture_url']), // Fix here
    roomCode: json['room_code'],
    description: json['description'],
    roomDetails: json['room_details'],
    category: json['category'],
    rentPrice: double.tryParse(json['rent_price'].toString()) ?? 0.0,
 // Ensure it's a string
    capacity: json['capacity'],
    currentOccupants: json['current_occupants']?? 0,
    minLease: json['min_lease'],
    size: json['size'],
    status: json['status'],
    unitType: json['unit_type'],
    createdAt: DateTime.parse(json['created_at']),
    updatedAt: DateTime.parse(json['updated_at']),
  );
}

  // Helper function to properly parse `room_picture_url`
  static List<String> _parseRoomPictureUrls(dynamic url) {
    print("URL FROM ROOMPICTUREURLS: $url");

    // Define the correct base URL
    String correctBaseUrl = Rest.baseUrl.replaceAll('api', 'storage/');

    if (url == null) {
      return []; // Return empty list if `room_picture_url` is null
    }

    if (url is List) {
      return url
        .map((e) => e.toString().replaceAll("http://127.0.0.1:8000/storage/", correctBaseUrl))
        .toList()
        .cast<String>(); 
    } else if (url is String) {
      try {
        // Extract JSON array from the string if needed
        final match = RegExp(r"\[(.*?)\]").firstMatch(url);
        if (match != null) {
          String cleanedJson = "[${match.group(1)}]".replaceAll("\\/", "/");
          List<dynamic> decoded = jsonDecode(cleanedJson);

          return decoded
            .map((e) => e.toString().replaceAll("http://127.0.0.1:8000/storage/", correctBaseUrl))
            .toList()
            .cast<String>(); // ✅ Ensure correct type
        }
      } catch (e) {
        print("Error parsing room_picture_url: $e");
      }
    }
    return [];
  }


}

import 'dart:convert';


class RoomResponse {
  final bool success;
  final String message;
  final Room data;

  RoomResponse({
    required this.success,
    required this.message,
    required this.data,
  }); 

  factory RoomResponse.fromJson(Map<String, dynamic> json) {
    return RoomResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: Room.fromJson(json['data']['rooms']),
    );
  }

}

class Room {
  final int id;
  final int propertyId;
  final List<String> roomPictureUrls;  // URLs should be a list of strings
  final String roomCode;
  final String description;
  final String roomDetails;
  final String category;
  final double rentPrice;  // Can be a numeric value (double)
  final int capacity;  // Must be an integer
  final int currentOccupants;  // Nullable integer
  final int minLease;  // Must be an integer
  final String size;  // String with a max length of 20
  final String status;  // One of the predefined statuses
  final String unitType;  // One of the predefined unit types
  final String createdAt;
  final String updatedAt;

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
      id: json['id'] ?? 0,
      propertyId: int.tryParse(json['property_id'].toString()) ?? 0,  // Convert to integer
      roomPictureUrls: json['room_picture_url'] != null
          ? List<String>.from(jsonDecode(json['room_picture_url']))
          : [],
      roomCode: json['room_code'] ?? '',
      description: json['description'] ?? '',
      roomDetails: json['room_details'] ?? '',
      category: json['category'] ?? '',
      rentPrice: double.tryParse(json['rent_price'].toString()) ?? 0.0,  // Ensure numeric format
      capacity: int.tryParse(json['capacity'].toString()) ?? 0,
      currentOccupants: int.tryParse(json['current_occupants'].toString()) ?? 0,  // Nullable integer
      minLease: int.tryParse(json['min_lease'].toString()) ?? 0,
      size: json['size'] ?? '',
      status: json['status'] ?? '',
      unitType: json['unit_type'] ?? '',
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'property_id': propertyId,  // Send as integer
      'room_picture_url': jsonEncode(roomPictureUrls),  // Convert list of URLs to JSON string
      'description': description,
      'room_details': roomDetails,
      'category': category,
      'rent_price': rentPrice.toString(),  // Ensure rent price is a string for backend
      'capacity': capacity,
      'current_occupants': currentOccupants ?? 0,  // Ensure it's an integer or nullable
      'min_lease': minLease,
      'size': size,
      'status': status,
      'unit_type': unitType,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}
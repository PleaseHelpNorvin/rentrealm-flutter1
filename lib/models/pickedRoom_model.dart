import 'dart:convert';

class PickedRoomResponse {
  final bool success;
  final String message;
  final PickedRoomsData data;

  PickedRoomResponse({required this.success, required this.message, required this.data});

  factory PickedRoomResponse.fromJson(Map<String, dynamic> json) {
    return PickedRoomResponse(
      success: json['success'],
      message: json['message'],
      data: PickedRoomsData.fromJson(json['data']),
    );
  }
}

class PickedRoomsData {
  final List<PickedRoomDetails> pickedRooms;

  PickedRoomsData({required this.pickedRooms});

  factory PickedRoomsData.fromJson(Map<String, dynamic> json) {
    return PickedRoomsData(
      pickedRooms: List<PickedRoomDetails>.from(
        json['picked_rooms'].map((x) => PickedRoomDetails.fromJson(x)),
      ),
    );
  }
}

class PickedRoomDetails {
  final int id;
  final int userId;
  final int roomId;
  final String createdAt;
  final String updatedAt;
  final Room room;

  PickedRoomDetails({required this.id, required this.userId, required this.roomId, required this.createdAt, required this.updatedAt, required this.room});

  factory PickedRoomDetails.fromJson(Map<String, dynamic> json) {
    return PickedRoomDetails(
      id: json['id'],
      userId: json['user_id'],
      roomId: json['room_id'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      room: Room.fromJson(json['room']),
    );
  }
}

class Room {
  final int id;
  final int propertyId;
  final List<String> roomPictureUrls;
  final String roomCode;
  final String description;
  final String roomDetails;
  final String category;
  final String rentPrice;
  final String reservationFee;
  final int capacity;
  final int currentOccupants;
  final int minLease;
  final String size;
  final String status;
  final String unitType;
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
    required this.reservationFee,
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
      roomPictureUrls: List<String>.from(jsonDecode(json['room_picture_url'])),
      roomCode: json['room_code'],
      description: json['description'],
      roomDetails: json['room_details'],
      category: json['category'],
      rentPrice: json['rent_price'],
      reservationFee: json['reservation_fee'],
      capacity: json['capacity'],
      currentOccupants: json['current_occupants'],
      minLease: json['min_lease'],
      size: json['size'],
      status: json['status'],
      unitType: json['unit_type'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }
}

import 'dart:convert';

class InquiryResponse {
  final bool success;
  final String message;
  final InquiryData data;

  InquiryResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory InquiryResponse.fromJson(Map<String, dynamic> json) {
    return InquiryResponse(
      success: json['success'],
      message: json['message'],
      data: InquiryData.fromJson(json['data']),
    );
  }
}

class InquiryData {
  final List<Inquiry> inquiries;

  InquiryData({required this.inquiries});

  factory InquiryData.fromJson(Map<String, dynamic> json) {
    var data = json;
    List<dynamic> inquiriesJson = [];

    if (data.containsKey('inquiries')) {
      // If response contains "inquiries" (multiple)
      inquiriesJson = data['inquiries'];
    } else if (data.containsKey('inquiry')) {
      // If response contains "inquiry" (single but still in a list)
      inquiriesJson = data['inquiry'];
    }

    return InquiryData(
      inquiries: inquiriesJson.map((i) => Inquiry.fromJson(i)).toList(),
    );
  }
}

class Inquiry {
  final int id;
  final int profileId;
  final int roomId;
  final String status;
  final bool hasPets;
  final bool wifiEnabled;
  final bool hasLaundryAccess;
  final bool hasPrivateFridge;
  final bool hasTv;
  final DateTime createdAt;
  final DateTime updatedAt;

  Inquiry({
    required this.id,
    required this.profileId,
    required this.roomId,
    required this.status,
    required this.hasPets,
    required this.wifiEnabled,
    required this.hasLaundryAccess,
    required this.hasPrivateFridge,
    required this.hasTv,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Inquiry.fromJson(Map<String, dynamic> json) {
    return Inquiry(
      id: int.tryParse(json['id']?.toString() ?? '0') ?? 0, // Ensure valid integer
      profileId: int.tryParse(json['profile_id']?.toString() ?? '0') ?? 0,
      roomId: int.tryParse(json['room_id']?.toString() ?? '0') ?? 0,
      status: json['status']?.toString() ?? '', // Ensure it's a valid string
      hasPets: json['has_pets']?.toString().trim() == "1", 
      wifiEnabled: json['wifi_enabled']?.toString().trim() == "1",
      hasLaundryAccess: json['has_laundry_access']?.toString().trim() == "1",
      hasPrivateFridge: json['has_private_fridge']?.toString().trim() == "1",
      hasTv: json['has_tv']?.toString().trim() == "1",
      createdAt: json['created_at'] != null ? DateTime.tryParse(json['created_at']) ?? DateTime(1970, 1, 1) : DateTime(1970, 1, 1),
      updatedAt: json['updated_at'] != null ? DateTime.tryParse(json['updated_at']) ?? DateTime(1970, 1, 1) : DateTime(1970, 1, 1),
    );
  }

  // ✅ Add this method to format the output
 
}

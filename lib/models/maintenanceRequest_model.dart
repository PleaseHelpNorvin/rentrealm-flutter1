import 'dart:convert';

class MaintenanceRequestResponse {
  final bool success;
  final String message;
  final MaintenanceData data;

  MaintenanceRequestResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory MaintenanceRequestResponse.fromJson(Map<String, dynamic> json) {
    return MaintenanceRequestResponse(
      success: json['success'],
      message: json['message'],
      data: MaintenanceData.fromJson(json['data']),
    );
  }
}

class MaintenanceData {
  final List<MaintenanceRequest> maintenanceRequests;

  MaintenanceData({required this.maintenanceRequests});

  factory MaintenanceData.fromJson(Map<String, dynamic> json) {
    var list = json['maintenance_requests'];
    List<MaintenanceRequest> requests = [];
    
    if (list is List) {
      requests = list.map((i) => MaintenanceRequest.fromJson(i)).toList();
    } else if (list is Map<String, dynamic>) {
      requests = [MaintenanceRequest.fromJson(list)];
    }
    
    return MaintenanceData(maintenanceRequests: requests);
  }
}

class MaintenanceRequest {
  final int id;
  final String ticketCode;
  final int tenantId;
  final int roomId;
  final int? handymanId;
  final String title;
  final String description;
  final List<String> images;
  final String status;
  final DateTime requestedAt;
  final DateTime? assistedAt;
  final DateTime? completedAt;
  final DateTime createdAt;
  final DateTime updatedAt;

  MaintenanceRequest({
    required this.id,
    required this.ticketCode,
    required this.tenantId,
    required this.roomId,
    this.handymanId,
    required this.title,
    required this.description,
    required this.images,
    required this.status,
    required this.requestedAt,
    this.assistedAt,
    this.completedAt,
    required this.createdAt,
    required this.updatedAt,
  });

  factory MaintenanceRequest.fromJson(Map<String, dynamic> json) {
    return MaintenanceRequest(
      id: int.parse(json['id'].toString()),
      ticketCode: json['ticket_code'] ?? '',
      tenantId: int.parse(json['tenant_id'].toString()),
      roomId: int.parse(json['room_id'].toString()),
      handymanId: json['handyman_id'] != null ? int.tryParse(json['handyman_id'].toString()) : null,
      title: json['title'],
      description: json['description'],
      images: json['images'] != null && json['images'] is List
          ? List<String>.from(json['images'])
          : [],  // Handle empty or null images field
      status: json['status'],
      requestedAt: DateTime.parse(json['requested_at']),
      assistedAt: json['assisted_at'] != null ? DateTime.parse(json['assisted_at']) : null,
      completedAt: json['completed_at'] != null ? DateTime.parse(json['completed_at']) : null,
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }
}
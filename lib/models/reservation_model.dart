import 'dart:convert';

class ReservationResponse {
  final bool success;
  final String message;
  final ReservationData data;

  ReservationResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory ReservationResponse.fromJson(Map<String, dynamic> json) {
    return ReservationResponse(
      success: json['success'],
      message: json['message'],
      data: ReservationData.fromJson(json['data'] ?? {}),
    );
  }
}

class ReservationData {
  final List<Reservation> reservations;

  ReservationData({required this.reservations});

  factory ReservationData.fromJson(Map<String, dynamic> json) {
    if (json['reservations'] is List) {
      return ReservationData(
        reservations: (json['reservations'] as List<dynamic>)
            .map((e) => Reservation.fromJson(e))
            .toList(),
      );
    } else if (json['reservations'] is Map<String, dynamic>) {
      return ReservationData(
        reservations: [Reservation.fromJson(json['reservations'])],
      );
    } else {
      return ReservationData(reservations: []);
    }
  }
}

class Reservation {
  final int id;
  final int profileId;
  final int roomId;
  final String reservationCode;
  final String paymentMethod;
  final List<String> reservationPaymentProofUrl;
  final String status;
  final int? approvedBy;
  final String? approvalDate;
  final String createdAt;
  final String updatedAt;

  Reservation({
    required this.id,
    required this.profileId,
    required this.roomId,
    required this.reservationCode,
    required this.paymentMethod,
    required this.reservationPaymentProofUrl,
    required this.status,
    required this.approvedBy,
    required this.approvalDate,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Reservation.empty() {
    return Reservation(
      id: 0,
      profileId: 0,
      roomId: 0,
      reservationCode: '',
      paymentMethod: '',
      reservationPaymentProofUrl: [],
      status: '',
      approvedBy: null,
      approvalDate: null,
      createdAt: '',
      updatedAt: '',
    );
  }

  factory Reservation.fromJson(Map<String, dynamic> json) {
    return Reservation(
      id: json['id'],
      profileId: json['profile_id'],
      roomId: json['room_id'],
      paymentMethod: json['payment_method'],
      reservationCode: json['reservation_code'],
      reservationPaymentProofUrl: json['reservation_payment_proof_url'] is List
          ? List<String>.from(json['reservation_payment_proof_url'])
          : json['reservation_payment_proof_url'] is String
              ? [json['reservation_payment_proof_url']]
              : [],

      status: json['status'],
      approvedBy: json['approved_by'], // Can be null
      approvalDate: json['approval_date'], // Can be null
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }

  // Add this method to resolve the error
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'profile_id': profileId,
      'room_id': roomId,
      'payment_method': paymentMethod,
      'reservation_code': reservationCode,
      'reservation_payment_proof_url': jsonEncode(reservationPaymentProofUrl),
      'status': status,
      'approved_by': approvedBy,
      'approval_date': approvalDate,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}

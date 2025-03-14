import 'dart:convert';
import '../models/reservation_model.dart';
import '../models/property_model.dart';

// Rental Agreement Response
class RentalAgreementResponse {
  final bool success;
  final String message;
  final List<RentalAgreement> rentalAgreements;

  RentalAgreementResponse({
    required this.success,
    required this.message,
    required this.rentalAgreements,
  });

  factory RentalAgreementResponse.fromJson(Map<String, dynamic> json) {
    var data = json['data']['rentalAgreement'];

    List<RentalAgreement> agreements = [];
    if (data is List) {
      // Handle list of agreements
      agreements = data.map((e) => RentalAgreement.fromJson(e)).toList();
    } else if (data is Map<String, dynamic>) {
      // Handle single agreement (convert to list)
      agreements = [RentalAgreement.fromJson(data)];
    }

    return RentalAgreementResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      rentalAgreements: agreements,
    );
  }
}

// Rental Agreement Model
class RentalAgreement {
  final int id;
  final int reservationId;
  final String rentStartDate;
  final String? rentEndDate;
  final int personCount;
  final double totalAmount;
  final String description;
  final String signaturePngString;
  final String agreementCode;
  final String status;
  final String createdAt;
  final String updatedAt;
  final Reservation reservation; // Nested Reservation

  RentalAgreement({
    required this.id,
    required this.reservationId,
    required this.rentStartDate,
    this.rentEndDate,
    required this.personCount,
    required this.totalAmount,
    required this.description,
    required this.signaturePngString,
    required this.agreementCode,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.reservation,
  });

  factory RentalAgreement.fromJson(Map<String, dynamic> json) {
    return RentalAgreement(
      id: json['id'] ?? 0,
      reservationId: json['reservation_id'] is int
          ? json['reservation_id']
          : int.tryParse(json['reservation_id'].toString()) ?? 0,
      rentStartDate: json['rent_start_date'] ?? '',
      rentEndDate: json['rent_end_date'], // Nullable, so no default needed
      personCount: json['person_count'] is int
          ? json['person_count']
          : int.tryParse(json['person_count'].toString()) ?? 0,
      totalAmount: json['total_amount'] is double
          ? json['total_amount']
          : double.tryParse(json['total_amount'].toString()) ?? 0.0,
      description: json['description'] ?? '',
      signaturePngString: json['signature_png_string'] ?? '',
      agreementCode: json['agreement_code'] ?? '',
      status: json['status'] ?? '',
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
      reservation: Reservation.fromJson(json['reservation'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'reservation_id': reservationId.toString(),
      'rent_start_date': rentStartDate,
      'rent_end_date': rentEndDate,
      'person_count': personCount.toString(),
      'total_amount': totalAmount.toString(),
      'description': description,
      'signature_png_string': signaturePngString,
      'agreement_code': agreementCode,
      'status': status,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'reservation': reservation.toJson(),
    };
  }
}

import 'package:intl/intl.dart';

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
    return RentalAgreementResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      rentalAgreements: (json['data']['rentalAgreements'] as List<dynamic>)
          .map((item) => RentalAgreement.fromJson(item))
          .toList(),
    );
  }
}

class RentalAgreement {
  final int id;
  final int inquiryId;
  final DateTime rentStartDate;
  final DateTime? rentEndDate;
  final int personCount;
  final double totalMonthlyDue;
  final String? description;
  final String signaturePngString;
  final String agreementCode;
  final String status;
  final DateTime updatedAt;
  final DateTime createdAt;

  RentalAgreement({
    required this.id,
    required this.inquiryId,
    required this.rentStartDate,
    this.rentEndDate,
    required this.personCount,
    required this.totalMonthlyDue,
    this.description,
    required this.signaturePngString,
    required this.agreementCode,
    required this.status,
    required this.updatedAt,
    required this.createdAt,
  });

  factory RentalAgreement.fromJson(Map<String, dynamic> json) {
    return RentalAgreement(
      id: json['id'],
      inquiryId: int.parse(json['inquiry_id'].toString()), // Convert string to int
      rentStartDate: DateTime.parse(json['rent_start_date']),
      rentEndDate: json['rent_end_date'] != null ? DateTime.parse(json['rent_end_date']) : null,
      personCount: int.parse(json['person_count'].toString()), // Convert string to int
      totalMonthlyDue: double.parse(json['total_monthly_due'].toString()), // Convert string to double
      description: json['description'],
      signaturePngString: json['signature_png_string'],
      agreementCode: json['agreement_code'],
      status: json['status'],
      updatedAt: DateTime.parse(json['updated_at']),
      createdAt: DateTime.parse(json['created_at']),
    );
  }
}

class RentalAgreementResponse {
  final bool success;
  final String message;
  final RentalAgreement data;

  RentalAgreementResponse({
    required this.success,
    required this.message,
    required this.data,
  }); 
  
  factory RentalAgreementResponse.fromJson(Map<String, dynamic> json) {
    return RentalAgreementResponse(
      success: json['success'],
      message: json['message'],
      data: RentalAgreement.fromJson(json['data']['rental_agreement']),
    );
  }
}

class RentalAgreement{
  final int propertyId;
  final int roomId;
  final String agreementCode;
  final String rentStartDate;
  final String rentEndDate;
  final double rentPrice;
  final double deposit;
  final String status;
  final String updatedAt;
  final String createdAt;
  final int id;

    RentalAgreement({
    required this.propertyId,
    required this.roomId,
    required this.agreementCode,
    required this.rentStartDate,
    required this.rentEndDate,
    required this.rentPrice,
    required this.deposit,
    required this.status,
    required this.updatedAt,
    required this.createdAt,
    required this.id,
  });

  factory RentalAgreement.fromJson(Map<String, dynamic> json) {
    return RentalAgreement(
      id: json['id'],
      propertyId: int.parse(json['property_id']),
      roomId: int.parse(json['room_id']),
      agreementCode: json['agreement_code'],
      rentStartDate: json['rent_start_date'],
      rentEndDate: json['rent_end_date'],
      rentPrice: double.parse(json['rent_price']),
      deposit: double.parse(json['deposit']),
      status: json['status'],
      updatedAt: json['updated_at'],
      createdAt: json['created_at'],
    );
  }
}

class Tenant {
  final int id;
  final int profileId;
  final int roomId;
  final int rentalAgreementId;
  final String startDate;
  final String endDate;
  final String rentPrice;
  final String deposit;
  final String paymentStatus;
  final String status;
  final String emergencyContactName;
  final String emergencyContactPhone;
  final bool hasPets;
  final bool wifiEnabled;
  final bool hasLaundryAccess;
  final bool hasPrivateFridge;
  final bool hasTv;
  final DateTime createdAt;
  final DateTime updatedAt;

  Tenant({
    required this.id,
    required this.profileId,
    required this.roomId,
    required this.rentalAgreementId,
    required this.startDate,
    required this.endDate,
    required this.rentPrice,
    required this.deposit,
    required this.paymentStatus,
    required this.status,
    required this.emergencyContactName,
    required this.emergencyContactPhone,
    required this.hasPets,
    required this.wifiEnabled,
    required this.hasLaundryAccess,
    required this.hasPrivateFridge,
    required this.hasTv,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Tenant.fromJson(Map<String, dynamic> json) {
    return Tenant(
      id: json['id'],
      profileId: json['profile_id'],
      roomId: json['room_id'],
      rentalAgreementId: json['rental_agreement_id'],
      startDate: json['start_date'],
      endDate: json['end_date'],
      rentPrice: json['rent_price'],
      deposit: json['deposit'],
      paymentStatus: json['payment_status'],
      status: json['status'],
      emergencyContactName: json['emergency_contact_name'],
      emergencyContactPhone: json['emergency_contact_phone'],
      hasPets: json['has_pets'] == 1,
      wifiEnabled: json['wifi_enabled'] == 1,
      hasLaundryAccess: json['has_laundry_access'] == 1,
      hasPrivateFridge: json['has_private_fridge'] == 1,
      hasTv: json['has_tv'] == 1,
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }
}


class TenantResponse {
  final bool success;
  final String message;
  final Tenant data;

  TenantResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory TenantResponse.fromJson(Map<String, dynamic> json) {
    return TenantResponse(
      success: json['success'],
      message: json ['message'],
      data: json['data'] != null && json['data']['tenant'] != null 
          ? Tenant.fromJson(json['data']['tenant'])
          : Tenant(
            id: 0, // Default values for missing tenant data
            profileId: 0,
            roomId: 0,
            rentalAgreementId: 0,
            startDate: '',
            endDate: '',
            rentPrice: '',
            deposit: '',
            paymentStatus: '',
            status: '',
            emergencyContactName: '',
            emergencyContactPhone: '',
            hasPets: false,
            wifiEnabled: false,
            hasLaundryAccess: false,
            hasPrivateFridge: false,
            hasTv: false,
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          )
    );
  }
}
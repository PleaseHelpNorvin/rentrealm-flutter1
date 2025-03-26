class TenantResponse {
  final bool success;
  final String message;
  final TenantData data;

  TenantResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory TenantResponse.fromJson(Map<String, dynamic> json) {
    return TenantResponse(
      success: json['success'],
      message: json['message'],
      data: TenantData.fromJson(json['data']),
    );
  }
}

class TenantData {
  final Tenant tenant;
  final Billing? latestBilling;
  final String? nextBillingMonth;
  final List<MaintenanceRequest> maintenanceRequests;

  TenantData({
    required this.tenant,
    this.latestBilling,
    this.nextBillingMonth,
    required this.maintenanceRequests,
  });

  factory TenantData.fromJson(Map<String, dynamic> json) {
    return TenantData(
      tenant: Tenant.fromJson(json['tenant']),
      latestBilling: json['latest_billing'] != null
          ? Billing.fromJson(json['latest_billing'])
          : null,
      nextBillingMonth: json['next_billing_month'],
      maintenanceRequests: (json['maintenance_requests'] as List<dynamic>?)
              ?.map((e) => MaintenanceRequest.fromJson(e))
              .toList() ??
          [],
    );
  }
}

class Tenant {
  final int id;
  final int profileId;
  final int rentalAgreementId;
  final String status;
  final String? evacuationDate;
  final String? moveOutDate;
  final DateTime createdAt;
  final DateTime updatedAt;
  final RentalAgreement rentalAgreement;
  final UserProfile userProfile;

  Tenant({
    required this.id,
    required this.profileId,
    required this.rentalAgreementId,
    required this.status,
    this.evacuationDate,
    this.moveOutDate,
    required this.createdAt,
    required this.updatedAt,
    required this.rentalAgreement,
    required this.userProfile,
  });

  factory Tenant.fromJson(Map<String, dynamic> json) {
    return Tenant(
      id: json['id'],
      profileId: json['profile_id'],
      rentalAgreementId: json['rental_agreement_id'],
      status: json['status'],
      evacuationDate: json['evacuation_date'],
      moveOutDate: json['move_out_date'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      rentalAgreement: RentalAgreement.fromJson(json['rental_agreement']),
      userProfile: UserProfile.fromJson(json['user_profile']),
    );
  }
}

class RentalAgreement {
  final int id;
  final int reservationId;
  final String agreementCode;
  final String rentStartDate;
  final String? rentEndDate;
  final int personCount;
  final String totalAmount;
  final bool isAdvancePayment;
  final String? description;
  final String signaturePngString;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;

  RentalAgreement({
    required this.id,
    required this.reservationId,
    required this.agreementCode,
    required this.rentStartDate,
    this.rentEndDate,
    required this.personCount,
    required this.totalAmount,
    required this.isAdvancePayment,
    this.description,
    required this.signaturePngString,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  factory RentalAgreement.fromJson(Map<String, dynamic> json) {
    return RentalAgreement(
      id: json['id'],
      reservationId: json['reservation_id'],
      agreementCode: json['agreement_code'],
      rentStartDate: json['rent_start_date'],
      rentEndDate: json['rent_end_date'],
      personCount: json['person_count'],
      totalAmount: json['total_amount'],
      isAdvancePayment: json['is_advance_payment'] == 1,
      description: json['description'],
      signaturePngString: json['signature_png_string'],
      status: json['status'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }
}

class UserProfile {
  final int id;
  final int userId;
  final String profilePictureUrl;
  final String phoneNumber;
  final String socialMediaLinks;
  final String occupation;
  final String? driverLicenseNumber;
  final String nationalId;
  final String? passportNumber;
  final String? socialSecurityNumber;
  final int steps;
  final DateTime createdAt;
  final DateTime updatedAt;

  UserProfile({
    required this.id,
    required this.userId,
    required this.profilePictureUrl,
    required this.phoneNumber,
    required this.socialMediaLinks,
    required this.occupation,
    this.driverLicenseNumber,
    required this.nationalId,
    this.passportNumber,
    this.socialSecurityNumber,
    required this.steps,
    required this.createdAt,
    required this.updatedAt,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id'],
      userId: json['user_id'],
      profilePictureUrl: json['profile_picture_url'],
      phoneNumber: json['phone_number'],
      socialMediaLinks: json['social_media_links'],
      occupation: json['occupation'],
      driverLicenseNumber: json['driver_license_number'],
      nationalId: json['national_id'],
      passportNumber: json['passport_number'],
      socialSecurityNumber: json['social_security_number'],
      steps: json['steps'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }
}

class Billing {
  final String billingMonth;
  final String status;
  final String totalAmount;
  final String amountPaid;
  final String remainingBalance;

  Billing({
    required this.billingMonth,
    required this.status,
    required this.totalAmount,
    required this.amountPaid,
    required this.remainingBalance,
  });

  factory Billing.fromJson(Map<String, dynamic> json) {
    return Billing(
      billingMonth: json['billing_month'],
      status: json['status'],
      totalAmount: json['total_amount'],
      amountPaid: json['amount_paid'],
      remainingBalance: json['remaining_balance'],
    );
  }
}

class MaintenanceRequest {
  final int id;
  final String requestType;
  final String description;
  final String status;
  final String requestedAt;

  MaintenanceRequest({
    required this.id,
    required this.requestType,
    required this.description,
    required this.status,
    required this.requestedAt,
  });

  factory MaintenanceRequest.fromJson(Map<String, dynamic> json) {
    return MaintenanceRequest(
      id: json['id'],
      requestType: json['request_type'],
      description: json['description'],
      status: json['status'],
      requestedAt: json['requested_at'],
    );
  }
}

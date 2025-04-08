import 'dart:convert';

import 'profile_model.dart';

class BillingResponse {
  final bool success;
  final String message;
  final BillingData data;

  BillingResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  // FIX: Accepts a Map instead of a String
  factory BillingResponse.fromJson(Map<String, dynamic> json) =>
      BillingResponse.fromMap(json);

  factory BillingResponse.fromMap(Map<String, dynamic> json) => BillingResponse(
        success: json["success"],
        message: json["message"],
        data: BillingData.fromMap(json["data"]),
      );
}

class BillingData {
  final List<Billing> billings;

  BillingData({required this.billings});

  factory BillingData.fromMap(Map<String, dynamic> json) => BillingData(
        billings:
            List<Billing>.from(json["billings"].map((x) => Billing.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "billings": List<dynamic>.from(billings.map((x) => x.toMap())),
      };
}

class Billing {
  final int id;
  final int profileId;
  final String billableType;
  final int billableId;
  final String totalAmount;
  final String amountPaid;
  final String remainingBalance;
  final DateTime billingMonth;
  final String status;
  final String? checkoutSessionId;
  final DateTime createdAt;
  final DateTime updatedAt;

  Billing({
    required this.id,
    required this.profileId,
    required this.billableType,
    required this.billableId,
    required this.totalAmount,
    required this.amountPaid,
    required this.remainingBalance,
    required this.billingMonth,
    required this.status,
    this.checkoutSessionId,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Billing.fromMap(Map<String, dynamic> json) => Billing(
        id: json["id"],
        profileId: json["profile_id"],
        billableType: json["billable_type"],
        billableId: json["billable_id"],
        totalAmount: json["total_amount"],
        amountPaid: json["amount_paid"],
        remainingBalance: json["remaining_balance"],
        billingMonth: DateTime.parse(json["billing_month"]),
        status: json["status"],
        checkoutSessionId: json["checkout_session_id"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "profile_id": profileId,
        "billable_type": billableType,
        "billable_id": billableId,
        "total_amount": totalAmount,
        "amount_paid": amountPaid,
        "remaining_balance": remainingBalance,
        "billing_month": billingMonth.toIso8601String(),
        "status": status,
        "checkout_session_id": checkoutSessionId,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
      };
}



class CheckFailPaymentResponse {
  bool success;
  String message;
  CheckFailPaymentData data;

  CheckFailPaymentResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory CheckFailPaymentResponse.fromJson(Map<String, dynamic> json) {
    return CheckFailPaymentResponse(
      success: json['success'],
      message: json['message'],
      data: CheckFailPaymentData.fromJson(json['data']),
    );
  }
}

class CheckFailPaymentData {
  CheckFailPaymentAgreement checkFailPaymentAgreement;
  CheckFailPaymentBilling checkFailPaymentBilling;

  CheckFailPaymentData({
    required this.checkFailPaymentAgreement,
    required this.checkFailPaymentBilling,
  });

  factory CheckFailPaymentData.fromJson(Map<String, dynamic> json) {
    return CheckFailPaymentData(
      checkFailPaymentAgreement: CheckFailPaymentAgreement.fromJson(json['unpaid_rental_agreement']),
      checkFailPaymentBilling: CheckFailPaymentBilling.fromJson(json['pending_billing']),
    );
  }
}

class CheckFailPaymentAgreement {
  int id;
  int reservationId;
  String agreementCode;
  DateTime rentStartDate;
  DateTime? rentEndDate; // Make rentEndDate nullable
  int personCount;
  double totalAmount;
  int isAdvancePayment;
  String? description; // Nullable string
  String? signaturePngString; // Nullable string
  String status;
  DateTime createdAt;
  DateTime updatedAt;

  CheckFailPaymentAgreement({
    required this.id,
    required this.reservationId,
    required this.agreementCode,
    required this.rentStartDate,
    this.rentEndDate, // Nullable
    required this.personCount,
    required this.totalAmount,
    required this.isAdvancePayment,
    this.description,
    this.signaturePngString, // Nullable
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  factory CheckFailPaymentAgreement.fromJson(Map<String, dynamic> json) {
    return CheckFailPaymentAgreement(
      id: json['id'],
      reservationId: json['reservation_id'],
      agreementCode: json['agreement_code'],
      rentStartDate: DateTime.parse(json['rent_start_date']),
      rentEndDate: json['rent_end_date'] != null ? DateTime.parse(json['rent_end_date']) : null, // Handle null for rent_end_date
      personCount: json['person_count'],
      totalAmount: double.parse(json['total_amount'].toString()),
      isAdvancePayment: json['is_advance_payment'],
      description: json['description'], // Nullable
      signaturePngString: json['signature_png_string'], // Nullable
      status: json['status'] ?? "", // Default empty string if null
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }
}



class CheckFailPaymentBilling {
  int id;
  int profileId;
  String billableType;
  int billableId;
  String billingTitle;
  double totalAmount;
  double amountPaid;
  double remainingBalance;
  DateTime billingMonth;
  String status;
  String? checkoutSessionId;
  DateTime createdAt;
  DateTime updatedAt;
  UserProfile? userProfile; // Nullable userProfile

  CheckFailPaymentBilling({
    required this.id,
    required this.profileId,
    required this.billableType,
    required this.billableId,
    required this.billingTitle,
    required this.totalAmount,
    required this.amountPaid,
    required this.remainingBalance,
    required this.billingMonth,
    required this.status,
    this.checkoutSessionId,
    required this.createdAt,
    required this.updatedAt,
    this.userProfile, // Nullable
  });

  factory CheckFailPaymentBilling.fromJson(Map<String, dynamic> json) {
    return CheckFailPaymentBilling(
      id: json['id'],
      profileId: json['profile_id'],
      billableType: json['billable_type'],
      billableId: json['billable_id'],
      billingTitle: json['billing_title'],
      totalAmount: double.parse(json['total_amount'].toString()),
      amountPaid: double.parse(json['amount_paid'].toString()),
      remainingBalance: double.parse(json['remaining_balance'].toString()),
      billingMonth: DateTime.parse(json['billing_month']),
      status: json['status'] ?? "", // Default empty string if null
      checkoutSessionId: json['checkout_session_id'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      userProfile: json['user_profile'] != null ? UserProfile.fromJson(json['user_profile']) : null, // Nullable
    );
  }
}

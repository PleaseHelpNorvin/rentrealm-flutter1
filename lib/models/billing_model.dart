import 'dart:convert';

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

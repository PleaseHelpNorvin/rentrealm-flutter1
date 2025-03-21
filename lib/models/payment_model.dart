// Model for a single receipt
class Receipt {
  final String paymongoPaymentReference;
  final String receiptUrl;

  Receipt({
    required this.paymongoPaymentReference,
    required this.receiptUrl,
  });

  // Convert JSON to Receipt object
  factory Receipt.fromJson(Map<String, dynamic> json) {
    return Receipt(
      paymongoPaymentReference: json['paymongo_payment_reference'],
      receiptUrl: json['receipt_url'],
    );
  }
}

// Model for the full API response
class ReceiptsResponse {
  final bool success;
  final String message;
  final List<Receipt> receipts;

  ReceiptsResponse({
    required this.success,
    required this.message,
    required this.receipts,
  });

  // Convert JSON to ReceiptsResponse object
  factory ReceiptsResponse.fromJson(Map<String, dynamic> json) {
    return ReceiptsResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      receipts: (json['data']['receipts'] as List<dynamic>?)
              ?.map((e) => Receipt.fromJson(e))
              .toList() ??
          [],
    );
  }
}

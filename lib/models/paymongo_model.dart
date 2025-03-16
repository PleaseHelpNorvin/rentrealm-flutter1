import 'dart:convert';

class PaymongoResponse {
  final bool success;
  final String message;
  final dynamic data;

  PaymongoResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  // Factory constructor to create an instance from JSON
  factory PaymongoResponse.fromJson(Map<String, dynamic> json) {
    return PaymongoResponse(
      success: json['success'],
      message: json['message'],
      data: json['success']
          ? PaymongoSuccessData.fromJson(json['data']) // Parse success response
          : (json['data'] is List
              ? (json['data'] as List)
                  .map((e) => PaymongoErrorData.fromJson(e))
                  .toList()
              : json['data']), // Parse error response
    );
  }

  // Convert back to JSON
  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'data': success
          ? (data as PaymongoSuccessData).toJson()
          : (data is List
              ? (data as List).map((e) => e.toJson()).toList()
              : data),
    };
  }
}

// Model for Successful Paymongo Response
class PaymongoSuccessData {
  final String checkoutUrl;

  PaymongoSuccessData({required this.checkoutUrl});

  factory PaymongoSuccessData.fromJson(Map<String, dynamic> json) {
    return PaymongoSuccessData(checkoutUrl: json['checkout_url']);
  }

  Map<String, dynamic> toJson() => {'checkout_url': checkoutUrl};
}

// Model for Error Response
class PaymongoErrorData {
  final String code;
  final String detail;

  PaymongoErrorData({required this.code, required this.detail});

  factory PaymongoErrorData.fromJson(Map<String, dynamic> json) {
    return PaymongoErrorData(
      code: json['code'],
      detail: json['detail'],
    );
  }

  Map<String, dynamic> toJson() => {'code': code, 'detail': detail};
}

class ReservationResponse {
  final bool success;
  final String message;
  // final InquiryData data;

  ReservationResponse({
    required this.success,
    required this.message,
    // required this.data,
  });

  factory ReservationResponse.fromJson(Map<String, dynamic> json) {
    return ReservationResponse(
      success: json['success'],
      message: json['message'],
      // data: InquiryData.fromJson(json['data'] ?? {}),
    );
  }
}
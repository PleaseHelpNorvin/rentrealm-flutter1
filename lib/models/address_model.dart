class Address {
  final String line1;
  final String line2;
  final String province;
  final String country;
  final String postalCode;

  Address({
    required this.line1,
    required this.line2,
    required this.province,
    required this.country,
    required this.postalCode,
  });

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      line1: json['line_1'] ?? '',
      line2: json['line_2'] ?? '',
      province: json['province'] ?? '',
      country: json['country'] ?? '',
      postalCode: json['postal_code'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'line_1': line1,
      'line_2': line2,
      'province': province,
      'country': country,
      'postal_code': postalCode,
    };
  }
}

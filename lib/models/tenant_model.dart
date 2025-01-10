import '../models/tenant_model.dart';

class Tenant {
  final int userId;
  final int roomId;
  final String leaseStartDate;
  final String leaseEndDate;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Tenant({
    required this.userId,
    required this.roomId,
    required this.leaseStartDate,
    required this.leaseEndDate,
    required this.createdAt,
    required this.updatedAt,
  });
}

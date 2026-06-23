class VehicleModel {
  final int id;
  final int user;
  final String ownerName;
  final String vehicleNumber;
  final String vehicleType;
  final String vehicleModel;
  final String vehicleColor;
  final String rcNumber;
  final bool isActive;
  final String createdAt;

  VehicleModel({
    required this.id,
    required this.user,
    required this.ownerName,
    required this.vehicleNumber,
    required this.vehicleType,
    required this.vehicleModel,
    required this.vehicleColor,
    required this.rcNumber,
    required this.isActive,
    required this.createdAt,
  });

  factory VehicleModel.fromJson(Map<String, dynamic> json) => VehicleModel(
        id: json['id'],
        user: json['user'],
        ownerName: json['owner_name'],
        vehicleNumber: json['vehicle_number'],
        vehicleType: json['vehicle_type'],
        vehicleModel: json['vehicle_model'],
        vehicleColor: json['vehicle_color'],
        rcNumber: json['rc_number'],
        isActive: json['is_active'],
        createdAt: json['created_at'],
      );
}
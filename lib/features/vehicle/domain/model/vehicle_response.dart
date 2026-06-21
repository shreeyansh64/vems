class VehicleResponse {
  final int id;
  final int user;
  final String ownerName;
  final String vehicleNumber;
  final String vehicleType;
  final String vehicleModel;
  final String vehicleColor;
  final String rcNumber;
  final bool isActive;

  VehicleResponse({
    required this.id,
    required this.user,
    required this.ownerName,
    required this.vehicleNumber,
    required this.vehicleType,
    required this.vehicleModel,
    required this.vehicleColor,
    required this.rcNumber,
    required this.isActive,
  });

  factory VehicleResponse.fromJson(Map<String, dynamic> json) {
    return VehicleResponse(
      id: json['id'],
      user: json['user'],
      ownerName: json['owner_name'],
      vehicleNumber: json['vehicle_number'],
      vehicleType: json['vehicle_type'],
      vehicleModel: json['vehicle_model'],
      vehicleColor: json['vehicle_color'],
      rcNumber: json['rc_number'],
      isActive: json['is_active'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user': user,
      'owner_name': ownerName,
      'vehicle_number': vehicleNumber,
      'vehicle_type': vehicleType,
      'vehicle_model': vehicleModel,
      'vehicle_color': vehicleColor,
      'rc_number': rcNumber,
      'is_active': isActive,
    };
  }
}
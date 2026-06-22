class VehicleResponse {
  final int id;
  final int user;

  VehicleResponse({required this.id, required this.user});

  factory VehicleResponse.fromJson(Map<String, dynamic> json) {
    return VehicleResponse(id: json['id'], user: json['user']);
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'user': user};
  }
}

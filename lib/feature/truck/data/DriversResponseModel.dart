class DriversResponseModel {
  final String? status;
  final int? results;
  final List<DriverModel> drivers;

  DriversResponseModel({
    this.status,
    this.results,
    required this.drivers,
  });

  factory DriversResponseModel.fromJson(Map<String, dynamic> json) {
    return DriversResponseModel(
      status: json['status'] ?? '',
      results: json['results'] ?? 0,
      drivers: (json['data']['drivers'] as List<dynamic>?)
              ?.map((e) => DriverModel.fromJson(e))
              .toList() ??
          [],
    );
  }
}

class DriverModel {
  final String id;
  final UserModel user;
  final String title;
  final String description;
  final String vehicleType;
  final String vehicleCapacity;
  final String cargoType;
  final String lastMaintenance;
  final String deliveryType;
  final List<String> vehicleImages;
  final String createdAt;
  final String updatedAt;

  DriverModel({
    required this.id,
    required this.user,
    required this.title,
    required this.description,
    required this.vehicleType,
    required this.vehicleCapacity,
    required this.cargoType,
    required this.lastMaintenance,
    required this.deliveryType,
    required this.vehicleImages,
    required this.createdAt,
    required this.updatedAt,
  });

  factory DriverModel.fromJson(Map<String, dynamic> json) {
    return DriverModel(
      id: json['_id'] ?? '',
      user: UserModel.fromJson(json['user']),
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      vehicleType: json['vehicleType'] ?? '',
      vehicleCapacity: json['vehicleCapacity'] ?? '',
      cargoType: json['cargoType'] ?? '',
      lastMaintenance: json['lastMaintenance'] ?? '',
      deliveryType: json['deliveryType'] ?? '',
      vehicleImages: List<String>.from(json['vehicleImages'] ?? []),
      createdAt: json['createdAt'] ?? '',
      updatedAt: json['updatedAt'] ?? '',
    );
  }
}

class UserModel {
  final String id;
  final String name;
  final String phone;
  final String email;
  final String address;
  final String area;

  UserModel({
    required this.id,
    required this.name,
    required this.phone,
    required this.email,
    required this.address,
    required this.area,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['_id'] ?? json['id'] ?? '',
      name: json['name'] ?? '',
      phone: json['phone'] ?? '',
      email: json['email'] ?? '',
      address: json['address'] ?? '',
      area: json['area'] ?? '',
    );
  }
}

class DeliveryData {
  final List<String> deliveryTypes;
  final List<String> vehicleTypes;
  final List<String> cargoTypes;
  final List<String> areas;
  final List<DriverModel> drivers;

  DeliveryData({
    required this.deliveryTypes,
    required this.vehicleTypes,
    required this.cargoTypes,
    required this.areas,
    required this.drivers,
  });

  factory DeliveryData.fromJson(Map<String, dynamic> json) {
    return DeliveryData(
      deliveryTypes: List<String>.from(json['deliveryTypes']),
      vehicleTypes: List<String>.from(json['vehicleTypes']),
      cargoTypes: List<String>.from(json['cargoTypes']),
      areas: List<String>.from(json['areas']),
      drivers:
      (json['drivers'] as List)
          .map((driver) => DriverModel.fromJson(driver))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'deliveryTypes': deliveryTypes,
      'vehicleTypes': vehicleTypes,
      'cargoTypes': cargoTypes,
      'areas': areas,
      'drivers': drivers.map((d) => d.toJson()).toList(),
    };
  }
}

class DriverModel {
  final String id;
  final String name;
  final String profilePhoto;

  DriverModel({
    required this.id,
    required this.name,
    required this.profilePhoto,
  });

  factory DriverModel.fromJson(Map<String, dynamic> json) {
    return DriverModel(
      id: json['id'],
      name: json['name'],
      profilePhoto: json['profilePhoto'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name, 'profilePhoto': profilePhoto};
  }
}
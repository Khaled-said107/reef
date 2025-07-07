class CarModel {
  final String title;
  final String description;
  final String vehicleType;
  final String vehicleCapacity;
  final String cargoType;
  final String lastMaintenance;
  final String deliveryType;
  final List<String> vehicleImages;
  CarModel({
    required this.title,
    required this.description,
    required this.vehicleType,
    required this.vehicleCapacity,
    required this.cargoType,
    required this.lastMaintenance,
    required this.deliveryType,
    required this.vehicleImages,
  });

  factory CarModel.fromJson(Map<String, dynamic> json) {
    return CarModel(
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      vehicleType: json['vehicleType'] ?? '',
      vehicleCapacity: json['vehicleCapacity'] ?? '',
      cargoType: json['cargoType'] ?? '',
      lastMaintenance: json['lastMaintenance'] ?? '',
      deliveryType: json['deliveryType'] ?? '',
      vehicleImages: List<String>.from(json['vehicleImages'] ?? []),
    );
  }
}
class UpdateMyCarModle {
  String? id;
  String? title;
  String? description;
  String? vehicleType;
  String? vehicleCapacity;
  String? cargoType;
  String? lastMaintenance;
  String? deliveryType;
  List<String>? vehicleImages; // ✅ هنا التعديل

  UpdateMyCarModle({
    this.id,
    this.title,
    this.description,
    this.vehicleType,
    this.vehicleCapacity,
    this.cargoType,
    this.lastMaintenance,
    this.deliveryType,
    this.vehicleImages, // ✅ هنا التعديل
  });

  factory UpdateMyCarModle.fromJson(Map<String, dynamic> json) {
    final driver = json['data']['driver'];

    return UpdateMyCarModle(
      id: driver['_id'],
      title: driver['title'],
      description: driver['description'],
      vehicleType: driver['vehicleType'],
      vehicleCapacity: driver['vehicleCapacity'],
      cargoType: driver['cargoType'],
      lastMaintenance: driver['lastMaintenance'],
      deliveryType: driver['deliveryType'],
      vehicleImages:
          List<String>.from(driver['vehicleImages'] ?? []), // ✅ هنا التعديل
    );
  }
}

class ImageModel {
  final String imagePath;

  ImageModel({required this.imagePath});

  factory ImageModel.fromJson(Map<String, dynamic> json) {
    return ImageModel(
      imagePath: json['imagePath'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'imagePath': imagePath,
    };
  }
}

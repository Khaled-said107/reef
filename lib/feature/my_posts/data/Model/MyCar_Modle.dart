class MyCarModel {
  String? id;
  String? title;
  String? description;
  String? vehicleType;
  String? vehicleCapacity;
  String? cargoType;
  String? lastMaintenance;
  String? deliveryType;
  List<String>? vehicleImages;
  String? time;
  String? userName;
  String? userPhone;
  String? userEmail;
  String? userPhoto;
  String? UserAdrres;
  MyCarModel(
      {this.id,
      this.title,
      this.description,
      this.vehicleType,
      this.vehicleCapacity,
      this.cargoType,
      this.lastMaintenance,
      this.deliveryType,
      this.vehicleImages,
      this.userName,
      this.userPhone,
      this.userEmail,
      this.userPhoto,
      this.time,
      this.UserAdrres});

  factory MyCarModel.fromJson(Map<String, dynamic> json) {
    final driver = json['data']['driver'];
    final user = driver['user'];

    return MyCarModel(
        id: driver['_id'],
        title: driver['title'],
        description: driver['description'],
        vehicleType: driver['vehicleType'],
        vehicleCapacity: driver['vehicleCapacity'],
        cargoType: driver['cargoType'],
        lastMaintenance: driver['lastMaintenance'],
        deliveryType: driver['deliveryType'],
        vehicleImages: List<String>.from(driver['vehicleImages'] ?? []),
        time: driver['createdAt'],
        userName: user['name'],
        userPhone: user['phone'],
        userEmail: user['email'],
        userPhoto: user['profilePhoto'],
        UserAdrres: user['address']);
  }
}

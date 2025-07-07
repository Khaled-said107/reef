class UserModel {
  final String? id;
  final String? name;
  final String? email;
  final String? phone;
  final String? profilePhoto;
  final String? address;
  final String? area;
  final String? role;

  UserModel({
    this.id,
    this.name,
    this.email,
    this.phone,
    this.profilePhoto,
    this.address,
    this.area,
    this.role,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['_id'],
      name: json['name'],
      email: json['email'],
      phone: json['phone'],
      profilePhoto: json['profilePhoto'],
      address: json['address'],
      area: json['area'],
      role: json['role'],
    );
  }
}

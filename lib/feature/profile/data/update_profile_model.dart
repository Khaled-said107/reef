class UpdateProfileModel {
  final String status;
  final String message;
  final ProfileData data;

  UpdateProfileModel({
    required this.status,
    required this.message,
    required this.data,
  });

  factory UpdateProfileModel.fromJson(Map<String, dynamic> json) {
    return UpdateProfileModel(
      status: json['status'],
      message: json['message'],
      data: ProfileData.fromJson(json['data']),
    );
  }

  Map<String, dynamic> toJson() => {
    'status': status,
    'message': message,
    'data': data.toJson(),
  };
}
class ProfileData {
  final User user;

  ProfileData({required this.user});

  factory ProfileData.fromJson(Map<String, dynamic> json) {
    return ProfileData(
      user: User.fromJson(json['user']),
    );
  }

  Map<String, dynamic> toJson() => {
    'user': user.toJson(),
  };
}
class User {
  final String id;
  final String name;
  final String phone;
  final String profilePhoto;
  final String email;
  final String address;
  final String area;
  final String role;
  final bool verification;
  final String? subscriptionEndDate;
  final String createdAt;
  final String updatedAt;

  User({
    required this.id,
    required this.name,
    required this.phone,
    required this.profilePhoto,
    required this.email,
    required this.address,
    required this.area,
    required this.role,
    required this.verification,
    required this.subscriptionEndDate,
    required this.createdAt,
    required this.updatedAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['_id'],
      name: json['name'],
      phone: json['phone'],
      profilePhoto: json['profilePhoto'],
      email: json['email'],
      address: json['address'],
      area: json['area'],
      role: json['role'],
      verification: json['verification'],
      subscriptionEndDate: json['subscriptionEndDate'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
    );
  }

  Map<String, dynamic> toJson() => {
    '_id': id,
    'name': name,
    'phone': phone,
    'profilePhoto': profilePhoto,
    'email': email,
    'address': address,
    'area': area,
    'role': role,
    'verification': verification,
    'subscriptionEndDate': subscriptionEndDate,
    'createdAt': createdAt,
    'updatedAt': updatedAt,
  };
}

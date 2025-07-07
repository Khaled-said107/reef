class AuthModel {
  final String status;
  final String message;
  final AuthData data;

  AuthModel({
    required this.status,
    required this.message,
    required this.data,
  });

  factory AuthModel.fromJson(Map<String, dynamic> json) {
    return AuthModel(
      status: json['status'] ?? '',
      message: json['message'] ?? '',
      data: json['data'] != null
          ? AuthData.fromJson(json['data'])
          : AuthData(user: UserModel(), token: ''),
    );
  }
}

class AuthData {
  final UserModel user;
  final String token;

  AuthData({
    required this.user,
    required this.token,
  });

  factory AuthData.fromJson(Map<String, dynamic> json) {
    return AuthData(
      user: UserModel.fromJson(json['user']),
      token: json['token'] ?? '',
    );
  }
}

class UserModel {
  final String? id;
  final String? email;
  final String? name;
  final String? phone;
  final String? profilePhoto;
  final String? address;
  final String? area;
  final String? role;

  UserModel({
    this.id,
    this.email,
    this.name,
    this.phone,
    this.profilePhoto,
    this.address,
    this.area,
    this.role,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['_id'] ?? json['id'],
      email: json['email'],
      name: json['name'],
      phone: json['phone'],
      profilePhoto: json['profilePhoto'],
      address: json['address'],
      area: json['area'],
      role: json['role'],
    );
  }
}

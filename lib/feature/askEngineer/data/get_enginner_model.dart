// Main response model
class GetEngineerModel {
  final String status;
  final int results;
  final List<UserModel> users;

  GetEngineerModel({
    required this.status,
    required this.results,
    required this.users,
  });

  factory GetEngineerModel.fromJson(Map<String, dynamic> json) {
    return GetEngineerModel(
      status: json['status'] ?? '',
      results: json['results'] ?? 0,
      users: (json['data']['users'] as List<dynamic>?)
          ?.map((e) => UserModel.fromJson(e))
          .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'results': results,
      'data': {
        'users': users.map((e) => e.toJson()).toList(),
      }
    };
  }
}

class UserModel {
  final String? id;
  final String? name;
  final String? phone;
  final String? profilePhoto;
  final String? email;
  final String? address;
  final String? area;
  final String? role;
  final bool? verification;
  final String? subscriptionEndDate;
  final String? createdAt;
  final String? updatedAt;
  final int? v;

  UserModel({
    this.id,
    this.name,
    this.phone,
    this.profilePhoto,
    this.email,
    this.address,
    this.area,
    this.role,
    this.verification,
    this.subscriptionEndDate,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['_id'] ?? json['id'],
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
      v: json['__v'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
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
      '__v': v,
    };
  }
}


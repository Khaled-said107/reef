class GetUserModel {
  final String status;
  final UserData data;

  GetUserModel({required this.status, required this.data});

  factory GetUserModel.fromJson(Map<String, dynamic> json) {
    return GetUserModel(
      status: json['status'],
      data: UserData.fromJson(json['data']),
    );
  }

  Map<String, dynamic> toJson() => {
    'status': status,
    'data': data.toJson(),
  };
}

class UserData {
  final User user;
  final PostStats postStats;

  UserData({required this.user, required this.postStats});

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      user: User.fromJson(json['user']),
      postStats: PostStats.fromJson(json['postStats']),
    );
  }

  Map<String, dynamic> toJson() => {
    'user': user.toJson(),
    'postStats': postStats.toJson(),
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
      profilePhoto: json['profilePhoto'].trim(),
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

class PostStats {
  final int olderThanWeek;
  final int notAccepted;
  final int lessThanWeek;

  PostStats({
    required this.olderThanWeek,
    required this.notAccepted,
    required this.lessThanWeek,
  });

  factory PostStats.fromJson(Map<String, dynamic> json) {
    return PostStats(
      olderThanWeek: json['olderThanWeek'],
      notAccepted: json['notAccepted'],
      lessThanWeek: json['lessThanWeek'],
    );
  }

  Map<String, dynamic> toJson() => {
    'olderThanWeek': olderThanWeek,
    'notAccepted': notAccepted,
    'lessThanWeek': lessThanWeek,
  };
}

class UpdatePostModel {
  final String status;
  final String message;
  final UpdatedPostData data;

  UpdatePostModel({
    required this.status,
    required this.message,
    required this.data,
  });

  factory UpdatePostModel.fromJson(Map<String, dynamic> json) {
    return UpdatePostModel(
      status: json['status'],
      message: json['message'],
      data: UpdatedPostData.fromJson(json['data']),
    );
  }
}

class UpdatedPostData {
  final UpdatedPost updatedPost;

  UpdatedPostData({required this.updatedPost});

  factory UpdatedPostData.fromJson(Map<String, dynamic> json) {
    return UpdatedPostData(
      updatedPost: UpdatedPost.fromJson(json['updatedPost']),
    );
  }
}

class UpdatedPost {
  final String id;
  final String userId;
  final String categoryId;
  final String subCategoryId;
  final List<String> images;
  final int views;
  final bool accept;
  final String name;
  final String description;
  final int price;
  final String priceUnit;
  final int quantity;
  final String quantityUnit;
  final String sellType;
  final String condition;
  final String address;
  final String phone;
  final String whatsapp;
  final String createdAt;
  final String updatedAt;

  UpdatedPost({
    required this.id,
    required this.userId,
    required this.categoryId,
    required this.subCategoryId,
    required this.images,
    required this.views,
    required this.accept,
    required this.name,
    required this.description,
    required this.price,
    required this.priceUnit,
    required this.quantity,
    required this.quantityUnit,
    required this.sellType,
    required this.condition,
    required this.address,
    required this.phone,
    required this.whatsapp,
    required this.createdAt,
    required this.updatedAt,
  });

  factory UpdatedPost.fromJson(Map<String, dynamic> json) {
    return UpdatedPost(
      id: json['_id'],
      userId: json['userId'],
      categoryId: json['categoryId'],
      subCategoryId: json['subCategoryId'],
      images: List<String>.from(json['images']),
      views: json['views'],
      accept: json['accept'],
      name: json['name'],
      description: json['description'],
      price: json['price'],
      priceUnit: json['priceUnit'],
      quantity: json['quantity'],
      quantityUnit: json['quantityUnit'],
      sellType: json['sellType'],
      condition: json['condition'],
      address: json['address'],
      phone: json['phone'],
      whatsapp: json['whatsapp'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
    );
  }
}

// Main response model
class GetAllPostsModel {
  final String status;
  final int results;
  final List<PostModel> posts;

  GetAllPostsModel({
    required this.status,
    required this.results,
    required this.posts,
  });

  factory GetAllPostsModel.fromJson(Map<String, dynamic> json) {
    return GetAllPostsModel(
      status: json['status'] ?? '',
      results: json['results'] ?? 0,
      posts: (json['data']['posts'] as List<dynamic>?)
          ?.map((e) => PostModel.fromJson(e))
          .toList() ??
          [],
    );
  }
}

// Post model
class PostModel {
  final String? id;
  final String? name;
  final String? description;
  final int? price;
  final String? priceUnit;
  final int? quantity;
  final String? quantityUnit;
  final String? sellType;
  final String? condition;
  final String? address;
  final String? phone;
  final String? whatsapp;
  final List<String> images;
  final int? views;
  final bool? accept;
  final String? createdAt;
  final String? updatedAt;
  final int? commentsCount;
  final int? likesCount;
  final UserModel? user;
  final CategoryModel? category;
  final SubCategoryModel? subCategory;

  PostModel({
    this.id,
    this.name,
    this.description,
    this.price,
    this.priceUnit,
    this.quantity,
    this.quantityUnit,
    this.sellType,
    this.condition,
    this.address,
    this.phone,
    this.whatsapp,
    required this.images,
    this.views,
    this.accept,
    this.createdAt,
    this.updatedAt,
    this.commentsCount,
    this.likesCount,
    this.user,
    this.category,
    this.subCategory,
  });

  factory PostModel.fromJson(Map<String, dynamic> json) {
    return PostModel(
      id: json['_id'],
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
      images: List<String>.from(json['images'] ?? []),
      views: json['views'],
      accept: json['accept'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      commentsCount: json['commentsCount'],
      likesCount: json['likesCount'],
      user: json['userId'] != null ? UserModel.fromJson(json['userId']) : null,
      category: json['categoryId'] != null ? CategoryModel.fromJson(json['categoryId']) : null,
      subCategory:
      json['subCategoryId'] != null ? SubCategoryModel.fromJson(json['subCategoryId']) : null,
    );
  }
}

// User model
class UserModel {
  final String? id;
  final String? name;
  final String? profilePhoto;

  UserModel({this.id, this.name, this.profilePhoto});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['_id'],
      name: json['name'],
      profilePhoto: json['profilePhoto'],
    );
  }
}

// Category model
class CategoryModel {
  final String? id;
  final String? name;
  final String? image;
  final String? createdAt;
  final String? updatedAt;

  CategoryModel({this.id, this.name, this.image, this.createdAt, this.updatedAt});

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['_id'],
      name: json['name'],
      image: json['image'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
    );
  }
}

// SubCategory model
class SubCategoryModel {
  final String? id;
  final String? name;
  final String? image;
  final String? categoryId;
  final String? createdAt;
  final String? updatedAt;

  SubCategoryModel({
    this.id,
    this.name,
    this.image,
    this.categoryId,
    this.createdAt,
    this.updatedAt,
  });

  factory SubCategoryModel.fromJson(Map<String, dynamic> json) {
    return SubCategoryModel(
      id: json['_id'],
      name: json['name'],
      image: json['image'],
      categoryId: json['categoryId'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
    );
  }
}

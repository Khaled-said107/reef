class MyPostModel {
  final String status;
  final int results;
  final List<Post> posts;

  MyPostModel({
    required this.status,
    required this.results,
    required this.posts,
  });

  factory MyPostModel.fromJson(Map<String, dynamic> json) {
    return MyPostModel(
      status: json['status'],
      results: json['results'],
      posts: List<Post>.from(
        json['data']['posts'].map((post) => Post.fromJson(post)),
      ),
    );
  }
}

class Post {
  final String id;
  final User user;
  final Category category;
  final SubCategory subCategory;
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

  Post({
    required this.id,
    required this.user,
    required this.category,
    required this.subCategory,
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

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['_id'],
      user: User.fromJson(json['userId']),
      category: Category.fromJson(json['categoryId']),
      subCategory: SubCategory.fromJson(json['subCategoryId']),
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
class User {
  final String id;
  final String name;

  User({required this.id, required this.name});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['_id'],
      name: json['name'],
    );
  }
}
class Category {
  final String id;
  final String name;

  Category({required this.id, required this.name});

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['_id'],
      name: json['name'],
    );
  }
}
class SubCategory {
  final String id;
  final String name;

  SubCategory({required this.id, required this.name});

  factory SubCategory.fromJson(Map<String, dynamic> json) {
    return SubCategory(
      id: json['_id'],
      name: json['name'],
    );
  }
}

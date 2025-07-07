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
  final String? userId;
  final String? userName;
  final String? userProfilePhoto;
  final String? categoryId;
  final String? categoryName;
  final String? subCategoryId;
  final String? subCategoryName;
  final bool? likedByCurrentUser;
  final int? likesCount;
  final int? commentsCount;

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
    this.userId,
    this.userName,
    this.userProfilePhoto,
    this.categoryId,
    this.categoryName,
    this.subCategoryId,
    this.subCategoryName,
    this.likedByCurrentUser,
    this.likesCount,
    this.commentsCount,
  });

  factory PostModel.fromJson(Map<String, dynamic> json) {
    final data = json.containsKey('data') ? json['data']['post'] : json;

    return PostModel(
      id: data['_id'],
      name: data['name'],
      description: data['description'],
      price: data['price'],
      priceUnit: data['priceUnit'],
      quantity: data['quantity'],
      quantityUnit: data['quantityUnit'],
      sellType: data['sellType'],
      condition: data['condition'],
      address: data['address'],
      phone: data['phone'],
      whatsapp: data['whatsapp'],
      images: List<String>.from(data['images'] ?? []),
      views: data['views'],
      accept: data['accept'],
      createdAt: data['createdAt'],
      updatedAt: data['updatedAt'],
      userId: data['userId']?['_id'],
      userName: data['userId']?['name'],
      userProfilePhoto: data['userId']?['profilePhoto'],
      categoryId: data['categoryId']?['_id'],
      categoryName: data['categoryId']?['name'],
      subCategoryId: data['subCategoryId']?['_id'],
      subCategoryName: data['subCategoryId']?['name'],
      likedByCurrentUser: json['data']?['likedByCurrentUser'],
      likesCount: json['data']?['likesCount'],
      commentsCount: json['data']?['commentsCount'],
    );
  }
}

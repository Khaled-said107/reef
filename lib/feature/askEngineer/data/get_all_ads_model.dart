class GetAllAdsModel {
  final String status;
  final int results;
  final List<AdModel> ads;

  GetAllAdsModel({
    required this.status,
    required this.results,
    required this.ads,
  });

  factory GetAllAdsModel.fromJson(Map<String, dynamic> json) {
    return GetAllAdsModel(
      status: json['status'] ?? '',
      results: json['results'] ?? 0,
      ads: (json['data']['ads'] as List<dynamic>?)
              ?.map((e) => AdModel.fromJson(e))
              .toList() ??
          [],
    );
  }
}

class AdModel {
  final String id;
  final AdUser user;
  final List<String> images;
  final int views;
  final bool accept;
  final String title;
  final String description;
  final String createdAt;
  final String updatedAt;
  final int likesCount;
  final int commentsCount;
  final bool likedByCurrentUser;

  AdModel(
      {required this.id,
      required this.user,
      required this.images,
      required this.views,
      required this.accept,
      required this.title,
      required this.description,
      required this.createdAt,
      required this.updatedAt,
      required this.likesCount,
      required this.commentsCount,
      required this.likedByCurrentUser});

  factory AdModel.fromJson(Map<String, dynamic> json) {
    return AdModel(
      id: json['_id'] ?? '',
      user: json['userId'] is Map
          ? AdUser.fromJson(json['userId'])
          : AdUser(id: json['userId'] ?? '', name: ''),
      images: List<String>.from(json['images'] ?? []),
      views: json['views'] ?? 0,
      accept: json['accept'] ?? false,
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      createdAt: json['createdAt'] ?? '',
      updatedAt: json['updatedAt'] ?? '',
      likesCount: json['likesCount'] ?? 0,
      commentsCount: json['commentsCount'] ?? 0,
      likedByCurrentUser: json['likedByCurrentUser'] ?? false,
    );
  }
}

class AdUser {
  final String id;
  final String name;

  AdUser({
    required this.id,
    required this.name,
  });

  factory AdUser.fromJson(Map<String, dynamic> json) {
    return AdUser(
      id: json['_id'] ?? json['id'] ?? '',
      name: json['name'] ?? '',
    );
  }
}

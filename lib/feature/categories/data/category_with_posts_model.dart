import 'package:reef/feature/categories/data/post_model.dart';

class CategoryWithPostsModel {
  final String id;
  final String name;
  final String image;
  final List<PostModel> posts;

  CategoryWithPostsModel({
    required this.id,
    required this.name,
    required this.image,
    required this.posts,
  });

  factory CategoryWithPostsModel.fromJson(Map<String, dynamic> json) {
    return CategoryWithPostsModel(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      image: json['image'] ?? '',
      posts:
          (json['posts'] as List<dynamic>?)
              ?.map((e) => PostModel.fromJson(e))
              .toList() ??
          [],
    );
  }
}

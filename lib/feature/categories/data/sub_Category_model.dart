import 'package:reef/feature/categories/data/category_model.dart';

class SubCategoryModel {
  final String id;
  final String name;
  final CategoryModel? category;

  SubCategoryModel({required this.id, required this.name, this.category});

  factory SubCategoryModel.fromJson(Map<String, dynamic> json) {
    return SubCategoryModel(
      id: json['_id'],
      name: json['name'],
      category:
          json['categoryId'] != null &&
                  json['categoryId'] is Map<String, dynamic>
              ? CategoryModel.fromJson(json['categoryId'])
              : null,
    );
  }
}

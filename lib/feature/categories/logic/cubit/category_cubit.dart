import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:reef/core/helpers/cach_helper.dart';
import 'package:reef/core/helpers/error_handle.dart';
import 'package:reef/core/network/dio_helper.dart';
import 'package:reef/feature/categories/data/category_model.dart';
import 'package:reef/feature/categories/data/category_with_posts_model.dart';
import 'package:reef/feature/categories/data/post_model.dart';
import 'package:reef/feature/categories/data/sub_Category_model.dart';

part 'category_state.dart';

class CategoryCubit extends Cubit<CategoryState> {
  CategoryCubit() : super(CategoryInitial());

  static CategoryCubit get(context) => BlocProvider.of(context);
  List<CategoryModel> categories = [];
  List<CategoryWithPostsModel> categoriesWithPosts = [];
  List<CategoryWithPostsModel> allCategoriesWithPosts = [];
  List<PostModel> posts = [];
  Map<String, List<SubCategoryModel>> subCategoriesMap = {};

  void getCategories() async {
    emit(CategoryLoading());
    try {
      final token = CacheHelper.getData('token');
      if (token == null || token.isEmpty) {
        emit(CategoryError("التوكن غير موجود"));
        return;
      }

      Response response = await DioHelper.getData(
        url: 'category',
        token: token,
      );
      final data = response.data['data'];
      if (data != null && data['categories'] != null) {
        categories = (data['categories'] as List)
            .map((json) => CategoryModel.fromJson(json))
            .toList();

        _emitCombinedState(); // 👈
      } else {
        emit(CategoryError("لا توجد بيانات متاحة"));
      }
    } catch (e) {
      emit(CategoryError(handleDioError(e)));
    }
  }

  Future<void> fetchCategoriesWithPosts() async {
    emit(CategoryWithPostsLoading());
    try {
      final token = CacheHelper.getData('token');
      final response = await DioHelper.getData(
        url: 'category/with-posts',
        token: token,
      );

      final data = response.data['data'] as List;

      allCategoriesWithPosts =
          data.map((e) => CategoryWithPostsModel.fromJson(e)).toList();

      categoriesWithPosts = allCategoriesWithPosts;

      _emitCombinedState(); // وظيفتها تطلع state فيها القايمتين
    } catch (e) {
      emit(CategoryWithPostsError(handleDioError(e)));
    }
  }

  void searchPosts(String query) {
    if (query.isEmpty) {
      categoriesWithPosts = allCategoriesWithPosts;
    } else {
      categoriesWithPosts = allCategoriesWithPosts
          .map((category) {
            final filteredPosts = category.posts.where((post) {
              return post.name!.toLowerCase().contains(query.toLowerCase()) ||
                  post.description!.toLowerCase().contains(query.toLowerCase());
            }).toList();

            return CategoryWithPostsModel(
              id: category.id,
              name: category.name,
              image: category.image,
              posts: filteredPosts,
            );
          })
          .where((category) => category.posts.isNotEmpty)
          .toList();
    }

    _emitCombinedState(); // كل مرة بعد التعديل
  }

  void _emitCombinedState() {
    emit(
      CategoryCombinedSuccess(
        categories: categories,
        categoriesWithPosts: categoriesWithPosts,
      ),
    );
  }

  Future<void> getPostsByCategory(String categoryId) async {
    emit(CategoryPostsLoading());
    try {
      final token = CacheHelper.getData('token');
      final response = await DioHelper.getData(
        url: 'post',
        query: {'categoryId': categoryId},
        token: token,
      );

      final data = response.data['data']['posts'] as List;
      posts = data.map((e) => PostModel.fromJson(e)).toList();
      emit(CategoryPostsSuccess(posts));
    } catch (e) {
      emit(CategoryPostsError(handleDioError(e)));
    }
  }

  Future<void> getSinglePost(String postId) async {
    emit(SinglePostLoading());
    try {
      final token = CacheHelper.getData('token');
      final response = await DioHelper.getData(
        url: 'post/$postId',
        token: token,
      );

      final postData = response.data;
      final postModel = PostModel.fromJson(postData);

      if (postModel.accept == true) {
        emit(SinglePostSuccess(postModel));
      } else {
        emit(SinglePostError("هذا المنشور لم يتم قبوله بعد"));
      }
    } catch (e) {
      emit(SinglePostError(handleDioError(e)));
    }
  }

  void getSubCategories(String categoryId) async {
    emit(SubCategoriesLoading());
    try {
      final token = CacheHelper.getData('token');
      if (token == null) {
        emit(SubCategoriesError("التوكن مش موجود"));
        return;
      }

      final response = await DioHelper.getData(
        url: 'subCategory',
        query: {'categoryId': categoryId}, // ✅ لازم يكون ده شغال في الـ backend
        token: token,
      );

      final List<dynamic> subCatJson = response.data['data']['subCategories'];

      // ✅ اطبع كل حاجة عشان تتأكد
      print('🔵 categoryId from UI: $categoryId');
      print('✅ Total from API: ${subCatJson.length}');

      List<SubCategoryModel> filtered =
          subCatJson.map((e) => SubCategoryModel.fromJson(e)).where((sub) {
        print('🟡 SubCategory: ${sub.name} - catId: ${sub.category?.id}');
        return sub.category?.id == categoryId;
      }).toList();

      print('✅ Filtered: ${filtered.length} subCategories');

      subCategoriesMap[categoryId] = filtered;

      emit(SubCategoriesSuccess(filtered));
    } catch (e) {
      emit(SubCategoriesError(handleDioError(e)));
    }
  }
}

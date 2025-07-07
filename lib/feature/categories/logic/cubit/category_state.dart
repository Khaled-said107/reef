part of 'category_cubit.dart';

@immutable
sealed class CategoryState {}

final class CategoryInitial extends CategoryState {}

final class CategoryLoading extends CategoryState {}

final class CategorySuccess extends CategoryState {
  final List<CategoryModel> categories;

  CategorySuccess({required this.categories});
}

final class CategoryError extends CategoryState {
  final String error;

  CategoryError(this.error);
}

class CategoryWithPostsLoading extends CategoryState {}

class CategoryWithPostsSuccess extends CategoryState {
  final List<CategoryWithPostsModel> categoriesWithPosts;
  CategoryWithPostsSuccess(this.categoriesWithPosts);
}

class CategoryWithPostsError extends CategoryState {
  final String error;
  CategoryWithPostsError(this.error);
}

class CategoryCombinedSuccess extends CategoryState {
  final List<CategoryModel> categories;
  final List<CategoryWithPostsModel> categoriesWithPosts;

  CategoryCombinedSuccess({
    required this.categories,
    required this.categoriesWithPosts,
  });
}

final class CategoryPostsLoading extends CategoryState {}

final class CategoryPostsSuccess extends CategoryState {
  final List<PostModel> posts;

  CategoryPostsSuccess(this.posts);
}

final class CategoryPostsError extends CategoryState {
  final String error;

  CategoryPostsError(this.error);
}

class SinglePostLoading extends CategoryState {}

class SinglePostSuccess extends CategoryState {
  final PostModel post;
  SinglePostSuccess(this.post);
}

class SinglePostError extends CategoryState {
  final String message;
  SinglePostError(this.message);
}

class SubCategoriesLoading extends CategoryState {}

class SubCategoriesSuccess extends CategoryState {
  final List<SubCategoryModel> subCategories;
  SubCategoriesSuccess(this.subCategories);
}

class SubCategoriesError extends CategoryState {
  final String message;
  SubCategoriesError(this.message);
}

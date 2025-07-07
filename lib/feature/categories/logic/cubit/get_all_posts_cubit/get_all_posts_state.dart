
import '../../../data/get_all_posts_model.dart';

sealed class GetAllPostsState {}

final class GetAllPostsInitial extends GetAllPostsState {}

class SinglePostLoading extends GetAllPostsState {}

class SinglePostSuccess extends GetAllPostsState {
  final GetAllPostsModel post;
  SinglePostSuccess(this.post);
}

class SinglePostError extends GetAllPostsState {
  final String message;
  SinglePostError(this.message);
}

part of 'my_post_cubit.dart';

@immutable
sealed class MyPostState {}

final class MyPostInitial extends MyPostState {}

class LoadingGetMyPostsState extends MyPostState {}

class SuccessGetMyPostsState extends MyPostState {
  final MyPostModel myPost;
  SuccessGetMyPostsState(this.myPost);
}

class ErrorGetMyPostsState extends MyPostState {}

class UpdateLoading extends MyPostState {}

class UpdateSuccess extends MyPostState {
  final dynamic data;
  UpdateSuccess(this.data);
}

class UpdateError extends MyPostState {
  final String error;
  UpdateError(this.error);
}

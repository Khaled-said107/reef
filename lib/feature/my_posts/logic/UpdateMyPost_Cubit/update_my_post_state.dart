part of 'update_my_post_cubit.dart';

sealed class UpdateMyPostState {}

final class UpdateMyPostInitial extends UpdateMyPostState {}

final class LodingMyUpdate extends UpdateMyPostState {}

final class UpdateMyPost extends UpdateMyPostState {
  final UpdatePostModel myPost;
  UpdateMyPost(this.myPost);
}

final class ErrorOfUpdate extends UpdateMyPostState {
  final String error;
  ErrorOfUpdate(this.error);
}

class LoadingDeletePostState extends UpdateMyPostState {}

class SuccessDeletePostState extends UpdateMyPostState {}

class ErrorDeletePostState extends UpdateMyPostState {
  final String error;
  ErrorDeletePostState(this.error);
}

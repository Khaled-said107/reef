part of 'create_post_cubit.dart';

@immutable
sealed class CreatePostState {}

final class CreatePostInitial extends CreatePostState {}

final class CreatePostLoading extends CreatePostState {}

final class CreatePostSuccess extends CreatePostState {

}

final class CreatePostFailure extends CreatePostState {
  final String error;

  CreatePostFailure({required this.error});
}

import 'package:reef/feature/askEngineer/data/get_all_ads_model.dart';

sealed class AskEngineerState {}

final class AskEngineerInitial extends AskEngineerState {}

class LoadingGetEngineerState extends AskEngineerState {}

class SuccessGetEngineerState extends AskEngineerState {}

class ErrorGetEngineerState extends AskEngineerState {}

class LoadingGetAllAdsState extends AskEngineerState {}

class SuccessGetAllAdsState extends AskEngineerState {}

class ErrorGetAllAdsState extends AskEngineerState {}

class LoadingCreatePostState extends AskEngineerState {}

class SuccessCreatePostState extends AskEngineerState {}

class ErrorCreatePostState extends AskEngineerState {
  final String error;
  ErrorCreatePostState({required this.error});
}

class LoadingChangeLikeState extends AskEngineerState {}

class SuccessChangeLikeState extends AskEngineerState {}

class ErrorChangeLikeState extends AskEngineerState {}

class LoadingGetAllCommentState extends AskEngineerState {}

class SuccessGetAllCommentState extends AskEngineerState {}

class ErrorGetAllCommentState extends AskEngineerState {}

class LoadingCreateCommentState extends AskEngineerState {}

class SuccessCreateCommentState extends AskEngineerState {}

class ErrorCreateCommentState extends AskEngineerState {}

class LoadingUpdatePostState extends AskEngineerState {}

class SuccessUpdatePostState extends AskEngineerState {
  final AdModel adModel;

  SuccessUpdatePostState({required this.adModel});
}

class ErrorUpdatePostState extends AskEngineerState {
  final String error;

  ErrorUpdatePostState({required this.error});
}

class LoadingDeletePostState extends AskEngineerState {}

class SuccessDeletePostState extends AskEngineerState {}

class ErrorDeletePostState extends AskEngineerState {
  final String error;
  ErrorDeletePostState({required this.error});
}

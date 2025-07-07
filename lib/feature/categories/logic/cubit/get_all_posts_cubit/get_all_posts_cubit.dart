import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/helpers/cach_helper.dart';
import '../../../../../core/helpers/error_handle.dart';
import '../../../../../core/network/dio_helper.dart';
import '../../../data/get_all_posts_model.dart';
import 'get_all_posts_state.dart';

class GetAllPostsCubit extends Cubit<GetAllPostsState> {
  GetAllPostsCubit() : super(GetAllPostsInitial());

  static GetAllPostsCubit get(context) => BlocProvider.of(context);

  GetAllPostsModel? getAllPostModel;

  void getAllPost(String subCategoryId) {
    emit(SinglePostLoading());
    DioHelper.getData(
      token: CacheHelper.getData('token'),
      url: 'post',
      query: {'subCategoryId': subCategoryId},
    ).then((value) {
      print('data subCategoryId : ${jsonEncode(value.data)}');
      getAllPostModel = GetAllPostsModel.fromJson(value.data);
      emit(SinglePostSuccess(getAllPostModel!));
    }).catchError((error) {
      emit(SinglePostError(handleDioError(error)));
      print('error subCategoryId' + error.toString());
    });
  }
}

import 'dart:convert';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http_parser/http_parser.dart';
import 'package:reef/core/widgets/show_toast.dart';
import 'package:reef/feature/askEngineer/data/create_comment_model.dart';
import 'package:reef/feature/askEngineer/data/get_alll_comm_model.dart';

import '../../../../../core/helpers/cach_helper.dart';
import '../../../../../core/helpers/error_handle.dart';
import '../../../../../core/network/dio_helper.dart';
import '../../data/get_all_ads_model.dart';
import '../../data/get_enginner_model.dart';
import 'ask_engineer_state.dart';

class ASkEngineerCubit extends Cubit<AskEngineerState> {
  ASkEngineerCubit() : super(AskEngineerInitial());

  static ASkEngineerCubit get(context) => BlocProvider.of(context);

  GetEngineerModel? getEngineerModel;

  void getEngineer() {
    emit(LoadingGetEngineerState());
    DioHelper.getData(
      token: CacheHelper.getData('token'),
      url: 'dashboard/allUser',
    ).then((value) {
      print('data Engineer : ${jsonEncode(value.data)}');
      getEngineerModel = GetEngineerModel.fromJson(value.data);
      emit(SuccessGetEngineerState());
    }).catchError((error) {
      emit(ErrorGetEngineerState());
      print('error subCategoryId' + error.toString());
    });
  }

  GetAllAdsModel? getAllAdsModel;

  void getAllAds() {
    emit(LoadingGetAllAdsState());
    DioHelper.getData(
      token: CacheHelper.getData('token'),
      url: 'ads',
    ).then((value) {
      print('data GetAllAds : ${jsonEncode(value.data)}');
      getAllAdsModel = GetAllAdsModel.fromJson(value.data);
      emit(SuccessGetAllAdsState());
    }).catchError((error) {
      emit(ErrorGetAllAdsState());
      print('error GetAllAds' + error.toString());
    });
  }

  void ChangeLike({required String adsId}) async {
    emit(LoadingChangeLikeState());
    DioHelper.postData(url: 'likes/$adsId', token: CacheHelper.getData('token'))
        .then((value) {
      if (value != null) {
        emit(SuccessChangeLikeState());
      } else {
        emit(ErrorChangeLikeState());
      }
    }).catchError((error) {
      print(error.toString());
      emit(ErrorChangeLikeState());
    });
  }

  GetAllCommentsModel? getAllCommentsModel;

  void getAllComment(String adsId) {
    emit(LoadingGetAllCommentState());
    DioHelper.getData(
      token: CacheHelper.getData('token'),
      url: 'comments/$adsId',
    ).then((value) {
      print('data AllComment : ${jsonEncode(value.data)}');
      getAllCommentsModel = GetAllCommentsModel.fromJson(value.data);
      emit(SuccessGetAllCommentState());
    }).catchError((error) {
      emit(ErrorGetAllCommentState());
      print('error AllComment' + error.toString());
    });
  }

  void createComment({required String adsId, required String content}) async {
    emit(LoadingCreateCommentState());
    DioHelper.postData(
            url: 'comments/$adsId',
            data: {'content': content},
            token: CacheHelper.getData('token'))
        .then((value) {
      if (value != null) {
        emit(SuccessCreateCommentState());
      } else {
        emit(ErrorCreateCommentState());
      }
    }).catchError((error) {
      print(error.toString());
      emit(ErrorCreateCommentState());
    });
  }

  //{{BaseUrl}}/api/v1/comments/${adsId}/reply/${commentId}
  void createReplayComment(
      {required String adsId,
      required String commentId,
      required String content}) async {
    emit(LoadingCreateCommentState());
    DioHelper.postData(
            url: 'comments/${adsId}/reply/${commentId}',
            data: {'content': content},
            token: CacheHelper.getData('token'))
        .then((value) {
      if (value != null) {
        emit(SuccessCreateCommentState());
      } else {
        emit(ErrorCreateCommentState());
      }
    }).catchError((error) {
      print(error.toString());
      emit(ErrorCreateCommentState());
    });
  }

  Future<void> createEngPost(String title, String description,
      [File? imageFile]) async {
    emit(LoadingCreatePostState());
    try {
      final token = CacheHelper.getData('token');

      final Map<String, dynamic> postData = {
        'title': title,
        'description': description,
      };

      // إذا تم اختيار صورة أضفها إلى FormData
      if (imageFile != null) {
        postData['images'] = await MultipartFile.fromFile(
          imageFile.path,
          filename: imageFile.path.split('/').last,
          contentType: MediaType('image', 'png'), // أو 'jpeg'
        );
      }

      final formData = FormData.fromMap(postData);

      final response = await DioHelper.postMultipartData(
        url: 'ads',
        data: formData,
        token: token,
      );

      emit(SuccessCreatePostState());
      print('✅ تم إرسال الإعلان: ${response.data}');
    } catch (e) {
      emit(ErrorCreatePostState(error: e.toString()));
      print("❌ Error creating post: $e");
    }
  }

  Future<void> updatePostWithImage({
    required String postId,
    required String title,
    required String description,
    File? imageFile, // ✅ خليها nullable
  }) async {
    emit(LoadingUpdatePostState());

    final token = CacheHelper.getData('token');

    // Base form data
    Map<String, dynamic> data = {
      'title': title,
      'description': description,
    };

    // Conditionally add image file
    if (imageFile != null) {
      String fileName = imageFile.path.split('/').last;
      data['images'] = await MultipartFile.fromFile(imageFile.path,
          filename: fileName, contentType: MediaType('image', 'png'));
    }

    final formData = FormData.fromMap(data);

    DioHelper.putData(
      url: 'http://82.29.172.199:8001/api/v1/ads/$postId',
      token: token,
      data: formData,
    ).then((value) {
      if (value != null) {
        print('data Update : ${jsonEncode(value.data)}');
        print(
            '✅ updatedAds runtimeType: ${value.data['data']['updatedAds'].runtimeType}');

        final adModel = AdModel.fromJson(value.data['data']['updatedAds']);
        emit(SuccessUpdatePostState(adModel: adModel));
      } else {
        emit(ErrorUpdatePostState(error: 'Empty response'));
      }
    }).catchError((error) {
      print(error.toString());
      emit(ErrorUpdatePostState(error: error.toString()));
    });
  }

  void deleteAd(String adId, BuildContext context) {
    emit(LoadingDeletePostState());

    DioHelper.deleteData(
      url: 'http://82.29.172.199:8001/api/v1/ads/$adId',
      token: CacheHelper.getData('token'),
    ).then((value) {
      if (value?.data['status'] == 'success') {
        showToast(
          message: "تم حذف الإعلان بنجاح",
          color: Colors.green,
          msg: '',
          state: null,
        );
        getAllAds();
        emit(SuccessDeletePostState());
      } else {
        showToast(
          message: "فشل في حذف الإعلان",
          color: Colors.red,
          msg: 'فشل في حذف الإعلان',
          state: null,
        );
        emit(ErrorDeletePostState(error: "فشل في حذف الإعلان"));
      }
    }).catchError((error) {
      showToast(
        message: "حدث خطأ أثناء الحذف",
        color: Colors.red,
        msg: '',
        state: null,
      );
      emit(ErrorDeletePostState(error: error.toString()));
    });
  }
}

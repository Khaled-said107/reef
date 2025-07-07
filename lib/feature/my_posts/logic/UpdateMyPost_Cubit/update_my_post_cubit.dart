import 'dart:convert';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';
import 'package:reef/core/network/dio_helper.dart';
import 'package:reef/feature/my_posts/data/Model/update_post_model.dart';
import '../../../../core/helpers/cach_helper.dart';
import '../../data/Model/MyPost_Model.dart';
part 'update_my_post_state.dart';

class UpdateMyPostCubit extends Cubit<UpdateMyPostState> {
  UpdateMyPostCubit() : super(UpdateMyPostInitial());

  UpdatePostModel? updatePostModel ;

  Future<void> updatePost({
    required String id,
    required String name,
    required String description,
    required dynamic price,
    required String priceUnit,
    required dynamic quantity,
    required String quantityUnit,
    required String sellType,
    required String condition,
    required String address,
    required String phone,
    required String whatsapp,
    required String token,
    File? imageFile,
  }) async {
    emit(LodingMyUpdate());

    final token = CacheHelper.getData('token');

    // Base form data
    final formDataMap = {
      "name": name,
      "description": description,
      "price": price ?? 0,
      "priceUnit": priceUnit,
      "quantity": quantity ?? 0,
      "quantityUnit": quantityUnit,
      "sellType": sellType,
      "condition": condition,
      "address": address,
      "phone": phone,
      "whatsapp": whatsapp,
    };

    // Conditionally add image file
    if (imageFile != null) {
      formDataMap['images'] = await MultipartFile.fromFile(
        imageFile.path,
        filename: imageFile.path.split('/').last,
        contentType: MediaType('image', 'png'), // or jpeg if needed
      );
    }

    final formData = FormData.fromMap(formDataMap);

    DioHelper.putData(
      url: 'http://82.29.172.199:8001/api/v1/post/$id',
      token: token,
      data: formData,
    ).then((value) {
      if (value != null) {
        print('data Update : ${jsonEncode(value.data)}');
        updatePostModel = UpdatePostModel.fromJson(value.data);
        emit(UpdateMyPost(updatePostModel!));
      } else {
        emit(ErrorOfUpdate('Empty response'));
      }
    }).catchError((error) {
      print(error.toString());
      emit(ErrorOfUpdate(error.toString()));
    });
  }

// Future<void> updatePost({
  //   required String id,
  //   required String name,
  //   required String description,
  //   required dynamic price,
  //   required String priceUnit,
  //   required dynamic quantity,
  //   required String quantityUnit,
  //   required String sellType,
  //   required String condition,
  //   required String address,
  //   required String phone,
  //   required String whatsapp,
  //   required String token,
  //    File? imageFile,
  // }) async {
  //   emit(LodingMyUpdate());
  //   final token = CacheHelper.getData('token');
  //
  //
  //   final formData = FormData.fromMap({
  //     "name": name,
  //     "description": description,
  //     "price": price ?? 0,
  //     "priceUnit": priceUnit,
  //     "quantity": quantity ?? 0,
  //     "quantityUnit": quantityUnit,
  //     "sellType": sellType,
  //     "condition": condition,
  //     "address": address,
  //     "phone": phone,
  //     "whatsapp": whatsapp,
  //     'images': await MultipartFile.fromFile(
  //       imageFile!.path,
  //       filename: imageFile.path.split('/').last,
  //       contentType: MediaType('image', 'png'), // أو 'jpeg' حسب الصورة
  //     ),
  //   });
  //   DioHelper.putData(
  //     url: 'http://82.29.172.199:8001/api/v1/post/$id',
  //     token: token,
  //     data: formData
  //     // data: {
  //     //   "name": name,
  //     //   "description": description,
  //     //   "price": price ?? 0,
  //     //   "priceUnit": priceUnit,
  //     //   "quantity": quantity ?? 0,
  //     //   "quantityUnit": quantityUnit,
  //     //   "sellType": sellType,
  //     //   "condition": condition,
  //     //   "address": address,
  //     //   "phone": phone,
  //     //   "whatsapp": whatsapp,
  //     // },
  //   ).then((value) {
  //     if (value != null) {
  //       print('data Update : ${jsonEncode(value.data)}');
  //       updatePostModel = UpdatePostModel.fromJson(value.data);
  //       emit(UpdateMyPost(updatePostModel!));
  //     } else {
  //       emit(ErrorOfUpdate('erorrrrrr'));
  //     }
  //   }).catchError((error) {
  //     print(error.toString());
  //     emit(ErrorOfUpdate(error.toString()));
  //   });
  // }


  Future<void> deletePost(String id) async {
    emit(LoadingDeletePostState());

    final token = CacheHelper.getData('token');

    try {
      final response = await DioHelper.deleteData(
        url: 'http://82.29.172.199:8001/api/v1/post/$id',
        token: token,
      );

      if (response != null && response.statusCode == 200) {
        print('✅ Post Deleted: ${response.data}');
        emit(SuccessDeletePostState());
      } else {
        print('❌ Failed to delete post. Response was null or not 200.');
        emit(ErrorDeletePostState('حدث خطأ أثناء حذف المنشور'));
      }
    } catch (error) {
      print('❌ Error deleting post: $error');
      emit(ErrorDeletePostState(error.toString()));
    }
  }


}

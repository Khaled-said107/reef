import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';
import 'package:http_parser/http_parser.dart';
import 'package:meta/meta.dart';
import 'package:reef/core/helpers/cach_helper.dart';
import 'package:reef/core/network/dio_helper.dart';
import 'package:reef/feature/create_post/data/create_post_model.dart';

part 'create_post_state.dart';

class CreatePostCubit extends Cubit<CreatePostState> {
  CreatePostCubit() : super(CreatePostInitial());
  Future<void> createPostWithImage(CreatePostModel post, List<File> imageFile) async {
    emit(CreatePostLoading());
    try {
      final token = CacheHelper.getData('token');
      final List<MultipartFile> imageMultipartFileList = await Future.wait(
        imageFile.map((file) async {
          return await MultipartFile.fromFile(
            file.path,
            filename: file.path.split('/').last,
            contentType: MediaType('image', 'png'),
          );
        }),
      );

      final formData = FormData.fromMap({
        'name': post.name,
        'description': post.description,
        'price': post.price,
        'priceUnit': post.priceUnit,
        'quantity': post.quantity,
        'quantityUnit': post.quantityUnit,
        'sellType': post.sellType,
        'condition': post.condition,
        'address': post.address,
        'phone': post.phone,
        'whatsapp': post.whatsapp,
        'categoryId': post.categoryId,
        'subCategoryId': post.subCategoryId,
        'images': imageMultipartFileList,
      });
      print('📦 Request to server:');
      print(formData.fields);
      print(formData.files);

      final response = await DioHelper.postMultipartData(
        url: 'post',
        data: formData,
        token: token,
      );

      emit(CreatePostSuccess());
      print('✅ تم إرسال الإعلان: ${response.data}');
    } catch (e) {
      emit(CreatePostFailure(error: e.toString()));
      print("❌ Error creating post: $e");
    }
  }
}

import 'dart:convert';
import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http_parser/http_parser.dart';
import 'package:meta/meta.dart';
import 'package:reef/core/helpers/cach_helper.dart';
import 'package:reef/core/helpers/error_handle.dart';
import 'package:reef/core/network/dio_helper.dart';
import 'package:reef/feature/profile/data/profile_model.dart';

import '../../data/update_profile_model.dart';

part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit() : super(ProfileInitial());

  static ProfileCubit get(context) => BlocProvider.of(context);

  GetUserModel? getUserModel;
  void getUser(){
    emit(ProfileLoading());
    DioHelper.getData(
      token: CacheHelper.getData('token'),
      url: 'user/profile',
    ).then((value){
      print('data get User : ${jsonEncode(value.data)}');
      getUserModel = GetUserModel.fromJson(value.data);
      emit(ProfileSuccess(getUserModel!));
    }).catchError((error){
      emit(ProfileError(error.toString()));
      print('error AllComment' + error.toString());
    });


  }


  UpdateProfileModel? updateProfileModel;
  Future<void> updateProfile({
    required String name,
    required String email,
    required String phone,
    required String address,
    required dynamic area,
    required String token,
    File? imageFile,
  }) async {
    emit(UpdateProfileLoading());

    final token = CacheHelper.getData('token');

    // Base form data
    final formDataMap = {
      "name": name,
      "email": email,
      "address": address,
      "phone": phone,
      "area": area,
    };

    // Conditionally add image file
    if (imageFile != null) {
      formDataMap['profilePhoto'] = await MultipartFile.fromFile(
        imageFile.path,
        filename: imageFile.path.split('/').last,
        contentType: MediaType('image', 'png'), // or jpeg if needed
      );
    }

    final formData = FormData.fromMap(formDataMap);

    DioHelper.patchData(
      url: 'http://82.29.172.199:8001/api/v1/user/:id',
      token: token,
      data: formData,
    ).then((value) {
      if (value != null) {
        print('data Update : ${jsonEncode(value.data)}');
        updateProfileModel = UpdateProfileModel.fromJson(value.data);
        emit(UpdateProfileSuccess(updateProfileModel!));
      } else {
        emit(UpdateProfileError('Empty response'));
      }
    }).catchError((error) {
      print(error.toString());
      emit(UpdateProfileError(error.toString()));
    });
  }



}

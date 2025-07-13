import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:reef/core/helpers/cach_helper.dart';
import 'package:reef/core/network/dio_helper.dart';
import 'package:reef/feature/my_posts/data/Model/UpdateMyCar_Modle.dart';

import 'package:http_parser/http_parser.dart';
import 'package:reef/feature/my_posts/logic/UpdateMyCarCubit/cubit/up_date_my_car_state.dart';

class UpdateMyCarCubit extends Cubit<UpdateMyCarState> {
  UpdateMyCarCubit() : super(UpdateMyCarInitial());

  UpdateMyCarModle? updateMyCarModle;
  ImageModel? imgModle;
  static UpdateMyCarCubit get(context) => BlocProvider.of(context);

  Future<void> updateCar({
    required String title,
    required String description,
    required String vehicleType,
    required String vehicleCapacity,
    required String cargoType,
    required String lastMaintenance,
    required String deliveryType,
    List<File>? vehicleImages, // الصور الجديدة
    List<String>? oldImages, // الصور القديمة (روابط)
  }) async {
    emit(UpdateMyCarLoding());

    final token = CacheHelper.getData('token');

    final formDataMap = <String, dynamic>{
      "title": title,
      "description": description,
      "vehicleType": vehicleType,
      "vehicleCapacity": vehicleCapacity,
      "cargoType": cargoType,
      "lastMaintenance": lastMaintenance,
      "deliveryType": deliveryType,
    };

// فقط لو فيه صور جديدة
    if (vehicleImages != null && vehicleImages.isNotEmpty) {
      List<MultipartFile> imageFiles = [];

      for (File image in vehicleImages) {
        final fileName = image.path.split('/').last;
        imageFiles.add(await MultipartFile.fromFile(
          image.path,
          filename: fileName,
          contentType: MediaType("image", "jpg"),
        ));
      }

      formDataMap['vehicleImages'] = imageFiles;
    }

// ❌ لا ترسل oldImages نهائيًا لأن الـ backend مش عايزها

    final formData = FormData.fromMap(formDataMap);

    try {
      final response = await DioHelper.putData(
        url: 'driver',
        token: token,
        data: formData,
      );

      if (response.statusCode == 200) {
        updateMyCarModle = UpdateMyCarModle.fromJson(response.data);
        emit(UpdateMyCarSucsses(updateMyCarModle!));
      } else {
        debugPrint('❌ Response status: ${response.statusCode}');
        debugPrint('❌ Response data: ${response.data}');
        emit(UpdateMyCarError('حدث خطأ غير متوقع، برجاء المحاولة لاحقًا'));
      }
    } on DioException catch (e) {
      debugPrint('❌ DioException: ${e.type}');
      debugPrint('❌ Message: ${e.message}');
      debugPrint('❌ Response: ${e.response?.data}');

      if (e.type == DioExceptionType.receiveTimeout) {
        emit(UpdateMyCarError('انتهت مهلة الاتصال بالسيرفر، حاول مرة أخرى'));
      } else if (e.response?.statusCode == 400) {
        final msg = e.response?.data['message'] ?? 'طلب غير صحيح';
        emit(UpdateMyCarError(msg));
      } else if (e.response?.statusCode == 403) {
        emit(UpdateMyCarError('غير مسموح لك بتنفيذ هذا الإجراء'));
      } else {
        emit(UpdateMyCarError('حدث خطأ، يرجى المحاولة لاحقًا'));
      }
    } catch (e) {
      debugPrint('❌ Unexpected error: $e');
      emit(UpdateMyCarError('حدث خطأ غير متوقع'));
    }
  }
}

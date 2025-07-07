import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http_parser/http_parser.dart';
import 'package:meta/meta.dart';
import 'package:reef/core/helpers/cach_helper.dart';
import 'package:reef/core/helpers/error_handle.dart';
import 'package:reef/core/network/dio_helper.dart';

import '../data/CarModel.dart';
import '../data/DeliveryData.dart';
import '../data/DriversResponseModel.dart';
import 'dreiver_state.dart';

class DriverCubit extends Cubit<DriverState> {
  DriverCubit() : super(DriverInitial());

  static DriverCubit get(context) => BlocProvider.of(context);

  late DriversResponseModel? driverModel;
  late DeliveryData? deliveryData;
  late DriversResponseModel? allDeliveryData;

  Future<void> featchDrivers({Map<String, dynamic>? filters}) async {
    emit(DriverLoading());
    try {
      final response = await DioHelper.getData(
        url: 'driver',
        token: CacheHelper.getData('token'),
        query: filters ?? {},
      );
      driverModel = DriversResponseModel.fromJson(response.data);
      allDeliveryData = driverModel;
      emit(DriverSuccess(driverModel));
      print(response.data);
    } catch (e) {
      final errorMessage = handleDioError(e);
      emit(DriverError(errorMessage));
      if (e is DioException && e.response != null) {
        print('🧩 Server error body: ${e.response?.data}');
      }
      print("❌ Dio Error Message: $errorMessage");
    }
  }

  void searchDrivers(String query) {
    if (query.isEmpty) {
      driverModel = allDeliveryData;
    } else {
      final filtered = allDeliveryData!.drivers.where((driver) {
        final name = driver.title.toLowerCase() ?? '';
        final address = driver.user.address.toLowerCase() ?? '';
        return name.contains(query.toLowerCase()) ||
            address.contains(query.toLowerCase());
      }).toList();
      driverModel = DriversResponseModel(
        drivers: filtered,
      );
    }
    emit(DriverSuccess(driverModel));
  }

  Future<void> postCarWithImage(CarModel driver, List<File> imageFiles) async {
    emit(AddDriverLoading());
    try {
      final token = CacheHelper.getData('token');

      final List<MultipartFile> imageMultipartFileList = await Future.wait(
        imageFiles.map((file) async {
          return await MultipartFile.fromFile(
            file.path,
            filename: file.path.split('/').last,
            contentType: MediaType('image', 'jpeg'),
          );
        }),
      );
      print('📸 Multipart files count: ${imageMultipartFileList.length}');
      for (final f in imageMultipartFileList) {
        print('📷 file: ${f.filename}');
      }
      final formData = FormData.fromMap({
        'title': driver.title,
        'description': driver.description,
        'vehicleType': driver.vehicleType,
        'vehicleCapacity': driver.vehicleCapacity,
        'cargoType': driver.cargoType,
        'lastMaintenance': driver.lastMaintenance,
        'deliveryType': driver.deliveryType,
        'vehicleImages': imageMultipartFileList,
      });
      final response = await DioHelper.postMultipartData(
        url: 'driver',
        data: formData,
        token: token,
      );
      emit(AddDriverSuccess(driver));
      print('✅ تم رفع الإعلان: ${response.data}');
    } catch (e) {
      final errorMessage = handleDioError(e);
      if (e is DioException && e.response != null) {
        print('🧨 SERVER ERROR BODY: ${e.response?.data}');
      }
      emit(AddDriverError(errorMessage));
      print("❌ Error creating post: $e");
    }
  }

  Future<void> fetchDeliveryData() async {
    emit(DeliveryLoading());
    try {
      final token = CacheHelper.getData('token');
      final response = await DioHelper.getData(
        url: 'driver/filter-option', // عدل URL هنا
        token: token,
      );

      deliveryData = DeliveryData.fromJson(response.data['data']);
      emit(DeliverySuccess(deliveryData!));
    } catch (e) {
      final errorMessage = handleDioError(e);
      emit(DeliveryError(errorMessage));
    }
  }
}

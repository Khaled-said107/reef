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

  DriversResponseModel? driverModel;

  late DeliveryData? deliveryData;
  DriversResponseModel? allDeliveryData;

  Future<void> featchDrivers({Map<String, dynamic>? filters}) async {
    emit(DriverLoading());
    print('drivers count: ${driverModel?.drivers.length}');

    try {
      final token = CacheHelper.getData('token');

      final response = await DioHelper.getData(
        url: 'driver',
        token: token,
        query: filters,
      );
      if (response.statusCode == 403) {
        // ❌ اليوزر مش متفعل، متعملش emit خالص
        return;
      }
      final data = response.data;
      print("✅ Full API response: $data");

      if (data != null &&
          data['data'] != null &&
          data['data']['drivers'] != null) {
        driverModel = DriversResponseModel.fromJson(data);
        allDeliveryData = driverModel;
        emit(DriverSuccess(driverModel));
      } else {
        driverModel = DriversResponseModel(drivers: []);
        emit(DriverError('الرد لا يحتوي على بيانات السائقين'));
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 403) {
        emit(DriverError(
            "انشر اعلان اولا ليس لديك صلاحية للوصول إلى البيانات."));
      } else {
        emit(DriverError("حدث خطأ: ${e.message}"));
      }
    }
  }

  void searchDrivers(String query) {
    if (allDeliveryData == null) return;

    if (query.isEmpty) {
      driverModel = allDeliveryData;
    } else {
      final filtered = allDeliveryData!.drivers.where((driver) {
        final name = driver.title.toLowerCase();
        final address = driver.user?.address.toLowerCase() ?? '';
        return name.contains(query.toLowerCase()) ||
            address.contains(query.toLowerCase());
      }).toList();

      driverModel = DriversResponseModel(
        status: allDeliveryData!.status,
        results: filtered.length,
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
      if (response.statusCode == 403) {
        // ❌ اليوزر مش متفعل، متعملش emit خالص
        return;
      }
      deliveryData = DeliveryData.fromJson(response.data['data']);
      emit(DeliverySuccess(deliveryData!));
    } catch (e) {
      final errorMessage = handleDioError(e);
      emit(DeliveryError(errorMessage));
    }
  }
}

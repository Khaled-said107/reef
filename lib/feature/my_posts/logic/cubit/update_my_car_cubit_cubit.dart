import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:reef/core/helpers/cach_helper.dart';
import 'package:reef/feature/my_posts/data/Model/MyCar_Modle.dart';
import 'package:reef/feature/my_posts/logic/cubit/update_my_car_cubit_state.dart';

import '../../../../core/network/dio_helper.dart';
import '../../../truck/data/DeliveryData.dart';

class MyCarCubit extends Cubit<MyCarState> {
  MyCarCubit() : super(MyCarInitial());

  static MyCarCubit get(context) => BlocProvider.of(context);

  late MyCarModel carModel;

  Future<void> getMyCar() async {
    emit(MyCarLoding());

    try {
      final response = await DioHelper.getData(
        url: 'driver/my-vehicle',
        token: CacheHelper.getData('token'),
      );

      carModel = MyCarModel.fromJson(response.data);
      emit(MyCarSucsses(carModel));
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        emit(NoCarData()); // بدل Error
      } else {
        emit(MyCarError("حدث خطأ: ${e.message}"));
      }
    }
  }
}

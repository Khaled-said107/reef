import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:meta/meta.dart';
import 'package:reef/core/helpers/cach_helper.dart';
import 'package:reef/core/helpers/error_handle.dart';
import 'package:reef/core/network/dio_helper.dart';
import 'package:reef/feature/payment/data/payment_model.dart';

part 'payment_state.dart';

class PaymentCubit extends Cubit<PaymentState> {
  PaymentCubit() : super(PaymentInitial());

  Future<void> PostPayment({required File img, required String token}) async {
    emit(PaymentLoding());
    CacheHelper.getData('token');
    try {
      final response = await DioHelper.postDataPayment(
        url: 'subscription/upload',
        img: img,
        token: token,
      );
      emit(PaymentPost(PaymentModel.fromJson(response.data)));
    } catch (e) {
      final errorMessage = handleDioError(e);
      emit(PaymentError(errorMessage));

      print("❌ Dio Error Message: $errorMessage");
    }
  }
}

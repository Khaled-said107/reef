import 'dart:convert';
import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reef/core/helpers/cach_helper.dart';
import 'package:reef/core/helpers/error_handle.dart';
import 'package:reef/core/network/dio_helper.dart';
import 'package:reef/feature/auth/data/model/auth_model.dart';
import 'package:reef/feature/auth/logic/auth_cubit/auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitial());

  static AuthCubit get(context) => BlocProvider.of(context);

  // Method to register a new user
  AuthModel? registerModel;
  void register({
    required String name,
    required String email,
    required String phone,
    required String password,
    required String confirmPassword,
    required String address,
    required String area,
    required String role,
  }) async {
    emit(AuthLoading());

    try {
      final value = await DioHelper.postData(
        url: 'auth/register',
        data: {
          'name': name,
          'email': email,
          'phone': phone,
          'password': password,
          'confirmPassword': confirmPassword,
          'address': address,
          'area': area,
          'role': role,
        },
      );

      print('data Register : ${jsonEncode(value.data)}');

      registerModel = AuthModel.fromJson(value.data);
      print('Parsed status: ${registerModel?.status}');
      print('Parsed token: ${registerModel?.data.token}');

      emit(AuthSuccess(model: registerModel!));
    } catch (error) {
      print('❌ Dio Error: $error');

      final message = handleDioError(error);
      emit(AuthError(message));
    }
  }

  AuthModel? loginModel;

  void login({required String email, required String password}) async {
    emit(AuthLoading());
    DioHelper.postData(
      url: 'auth/login',
      data: {'email': email, 'password': password},
    ).then((value) {
      if (value != null) {
        print('data login : ${jsonEncode(value.data)}');
        loginModel = AuthModel.fromJson(value.data);
        print('Parsed status: ${loginModel?.status}');
        print('Parsed token: ${loginModel?.data.token}');
        emit(AuthSuccess(model: loginModel!));
      } else {
        emit(AuthError('حدثت مشكله'));
      }
    }).catchError((error) {
      print(error.toString());

      final message = handleDioError(error);
      emit(AuthError(message));
    });

    // try {
    //   // Response response = await DioHelper.postData(
    //   //   url: 'auth/login',
    //   //   data: {'email': email, 'password': password},
    //   // );
    //   // print('login response: ${response.data}');
    //   // final loginModel = AuthModel.fromJson(response.data);
    //   // emit(AuthSuccess(model: loginModel));
    //   // final token = response.data['data']['token'];
    //   //await CacheHelper.saveData(key: 'token', value: token.toString());
    // } catch (e) {
    //   final errorMessage = ErrorHandler.getErrorMessage(e);
    //   emit(AuthError(errorMessage));
    //   print("❌ Dio Error Message: $errorMessage");
    //   print(e);
    // }
  }

  void forgetPassword({required String email}) async {
    emit(AuthLoading());
    try {
      Response response = await DioHelper.patchData(
        url: 'auth/forget-password',
        data: {'email': email},
      );

      print("📩 Response Message: ${response.data['message']}");
      emit(AuthSuccessMessage(message: response.data['message']));
      await CacheHelper.saveData(key: 'email', value: email);
    } catch (e) {
      print(e.toString());
      final errorMessage = handleDioError(e);
      emit(AuthError(errorMessage));
      print("❌ Dio Error Message: $errorMessage");
      print(e);
    }
  }

  void verfiyOtp({required String otp}) async {
    emit(AuthLoading());
    DioHelper.postData(
      url: 'auth/verify-otp',
      data: {'otp': otp, 'email': CacheHelper.getData('email')},
    ).then((value) {
      if (value != null) {
        print("🔍 OTP Verification Response: ${value.data}");
        emit(VerifyTokenSuccess(value.data.data['message']));
      } else {
        emit(AuthError('erorrrrrr'));
      }
    }).catchError((error) {
      print(error.toString());

      final message = handleDioError(error); // ✨ ده السطر المهم
      emit(AuthError(message));
    });
    // try {
    //   // Response response = await DioHelper.postData(
    //   //   url: 'auth/verify-otp',
    //   //   data: {'otp': otp, 'email': CacheHelper.getData('email')},
    //   // );
    //   // print("🔍 OTP Verification Response: ${response.data}");
    //   // emit(VerifyTokenSuccess(response.data['message']));
    // } catch (e) {
    //   final errorMessage = ErrorHandler.getErrorMessage(e);
    //   emit(VerifyTokenError(errorMessage));
    //   print("❌ Dio Error Message: $errorMessage");
    // }
  }

  void resetPassword({
    required String password,
    required String confirmPassword,
  }) async {
    emit(ResetPasswordLoading());
    try {
      Response response = await DioHelper.patchData(
        url: 'auth/reset-password',
        data: {
          'password': password,
          'confirmPassword': confirmPassword,
          'email': CacheHelper.getData('email'),
        },
      );
      print("🔄 Password Reset Response: ${response.data}");
      emit(ResetPasswordSuccess(response.data['message']));
    } catch (e) {
      final errorMessage = handleDioError(e);
      emit(ResetPasswordError(errorMessage));
      print("❌ Dio Error Message: $errorMessage");
    }
  }
}

import 'package:reef/feature/auth/data/model/auth_model.dart';

abstract class AuthState {}

// الحالة الابتدائية قبل أي فعل
class AuthInitial extends AuthState {}

// حالة التحميل (بتظهر أثناء انتظار نتيجة الAPI)
class AuthLoading extends AuthState {}

// حالة النجاح للـ login أو register وتحمل موديل البيانات
class AuthSuccess extends AuthState {
  final AuthModel model;

  AuthSuccess({required this.model});
}

// حالة الخطأ وتحمل رسالة الخطأ
class AuthError extends AuthState {
  final String error;

  AuthError(this.error);
}

class AuthErrorMessage extends AuthState {
  final AuthModel model;

  AuthErrorMessage({required this.model});
}


class AuthSuccessMessage extends AuthState {
  final String message;
  AuthSuccessMessage({required this.message});
}
// VerifyToken
class VerifyTokenLoading extends AuthState {}
class VerifyTokenSuccess extends AuthState {
  final String message;
  VerifyTokenSuccess(this.message);
}
class VerifyTokenError extends AuthState {
  final String error;
  VerifyTokenError(this.error);
}
// ResetPassword
class ResetPasswordLoading extends AuthState {}
class ResetPasswordSuccess extends AuthState {
  final String message;
  ResetPasswordSuccess(this.message);
}
class ResetPasswordError extends AuthState {
  final String error;
  ResetPasswordError(this.error);
}
// ChangePassword
class ChangePasswordLoading extends AuthState {}
class ChangePasswordSuccess extends AuthState {
  final String message;
  ChangePasswordSuccess(this.message);
}
class ChangePasswordError extends AuthState {
  final String error;
  ChangePasswordError(this.error);
}

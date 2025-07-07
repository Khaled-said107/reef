part of 'profile_cubit.dart';

@immutable
sealed class ProfileState {}

final class ProfileInitial extends ProfileState {}

/// عند بدء تحميل بيانات البروفايل
final class ProfileLoading extends ProfileState {}

/// تم تحميل البيانات بنجاح
final class ProfileSuccess extends ProfileState {
  final GetUserModel user;
  ProfileSuccess(this.user);
}

/// أثناء حفظ بيانات البروفايل
final class ProfileSaving extends ProfileState {}



/// عند عدم وجود بيانات محفوظة
final class ProfileNotFound extends ProfileState {}

/// عند حدوث خطأ
final class ProfileError extends ProfileState {
  final String message;
  ProfileError(this.message);
}

/// عند مسح البيانات (مثلاً وقت تسجيل الخروج)
final class ProfileCleared extends ProfileState {}

final class UpdateProfileLoading extends ProfileState {}
final class UpdateProfileSuccess extends ProfileState {
  final UpdateProfileModel updateProfileModel;
  UpdateProfileSuccess(this.updateProfileModel);
}
final class UpdateProfileError extends ProfileState {
  final String message;
  UpdateProfileError(this.message);
}
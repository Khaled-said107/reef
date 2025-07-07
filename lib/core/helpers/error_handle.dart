import 'package:dio/dio.dart';

String handleDioError(dynamic error) {
  if (error is DioException) {
    final response = error.response;

    if (response != null) {
      final data = response.data;
      if (data is Map && data.containsKey('message')) {
        final msg = data['message'];

        // هنا نحول الرسالة من إنجليزي لعربي حسب الحالة
        if (msg == 'Invalid token, access denied') {
          return 'انتهت صلاحية الجلسة. قم بتسجيل الدخول مجددًا';
        } else if (msg == 'Email or phone already exists') {
          return 'البريد الإلكتروني او رقم الهاتف مستخدمين بالفعل';
        } else if (msg == 'Incorrect email or password') {
          return 'البريد الإلكتروني أو كلمة المرور غير صحيحة';
        } else if (msg ==
            'Password must be at least 6 characters and include a letter, a number, and a special character') {
          return 'كلمة المرور قصيره وضغيف اكتب اقل حاجه 6 حروف ويكون فيهم رموز وكروف كبيره';
        } else if (msg == 'Email must be a valid email') {
          return 'البريد الإلكتروني مكتوب بصيغه خاطئه';
        } else if (msg == 'Confirm password must match password') {
          return 'تأكيد كلمة المرور مختلفه عن كلمة المرور الاصليه';
        } else if (msg == 'Invalid credentials') {
          return 'البيانات الي دخلتها مش صحيحه اتاكد من البريد الالكتروني وكلمة المرور';
        } else if (msg ==
            'Your subscription has expired. Please renew to continue') {
          return 'انت مش مشترك او اشتراكك انتهي روح علي صفحة الملف الشخصي وادخل علي تجديد الاشتراك واشترك اشتراك شهري';
        } else {
          return msg; // الرسالة نفسها إن ما كانش فيه ترجمة
        }
      }
    }

    // لو مفيش رسالة واضحة من السيرفر
    if (error.type == DioExceptionType.connectionTimeout ||
        error.type == DioExceptionType.sendTimeout ||
        error.type == DioExceptionType.receiveTimeout) {
      return 'انقطع الاتصال بالخادم. حاول لاحقًا.';
    }

    if (error.type == DioExceptionType.badCertificate) {
      return 'شهادة الخادم غير صالحة';
    }

    if (error.type == DioExceptionType.connectionError) {
      return 'فشل الاتصال بالإنترنت';
    }

    if (error.type == DioExceptionType.unknown) {
      return 'حدث خطأ غير متوقع';
    }
  }

  // لو الخطأ مش Dio
  return 'حدث خطأ غير متوقع';
}

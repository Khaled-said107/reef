import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:reef/core/widgets/app_text.dart';

class SigninGoogle extends StatelessWidget {
  const SigninGoogle({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
    
      height: 50.h,
      decoration: BoxDecoration(
        color: Color(0xFFEFEAD8),
        borderRadius: BorderRadius.circular(8.r),
        
      ),
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/google.png',
              width: 20.w,
              height: 20.h,
            ),
            Gap(15.w),
            AppText(textAlign: TextAlign.center, text: 'سجّل الدخول باستخدام جوجل', fontsize: 15.sp, color: const Color.fromARGB(255, 0, 0, 0)),
          ],
        ),
      ),
    );
  }
}


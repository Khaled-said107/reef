import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:reef/core/constants/app_colors.dart';
import 'package:reef/core/helpers/extensions.dart';
import 'package:reef/core/routing/routes.dart';
import 'package:reef/core/widgets/app_text.dart';
import 'package:reef/core/widgets/custom_button.dart';

class ConfirmPasswordScreen extends StatelessWidget {
  const ConfirmPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding:  EdgeInsets.symmetric(
            horizontal: 20.w,
          
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/check.png',
                width: 150.w,
                height: 150.h,
              ),
              Gap(40.h),
              AppText(text: 'تم تعيين كلمة المرور بنجاح', fontsize: 16.sp, fontWeight: FontWeight.w700),
              Gap(15.h),
              AppText( textAlign: TextAlign.center, text: 'يمكنك الآن تسجيل الدخول إلى حسابك بكلمة\n المرور الجديدة', fontsize: 13.sp,color: AppColors.textGrey, fontWeight: FontWeight.w700),
              Gap(50.h),
           CustomButton(text: 'تسجيل الدخول الآن', onPressed: (){
            context.pushReplacementNamed(Routes.login);
           })
            ],
          
          ),
        )
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:reef/core/constants/app_colors.dart';
import 'package:reef/core/helpers/extensions.dart';
import 'package:reef/core/routing/routes.dart';
import 'package:reef/core/widgets/app_text.dart';
import 'package:reef/core/widgets/custom_button.dart';

class ConfirmPaymentScreen extends StatelessWidget {
  const ConfirmPaymentScreen({super.key});

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
              AppText(text: 'تم إرسال الإيصال بنجاح', fontsize: 16.sp, fontWeight: FontWeight.w700),
              Gap(15.h),
              AppText( textAlign: TextAlign.center, text: 'جاري مراجعة طلبك، وسيتم تفعيل الاشتراك \nخلال وقت قصير', fontsize: 13.sp,color: AppColors.textGrey, fontWeight: FontWeight.w700),
              Gap(70.h),
           CustomButton(text: 'العودة للأعلان', onPressed: (){
            context.pushReplacementNamed(Routes.product);
           })
            ],
          
          ),
        )
      ),
    );
  }
}
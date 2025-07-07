import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:reef/core/constants/app_colors.dart';
import 'package:reef/core/helpers/extensions.dart';
import 'package:reef/core/routing/routes.dart';
import 'package:reef/core/widgets/app_text.dart';
import 'package:reef/feature/payment/ui/screens/send_payment_img_screen.dart';
import 'package:reef/feature/payment/ui/widgets/dash_border.dart';
import 'package:reef/feature/payment/ui/widgets/options_widget.dart';

class PaymentScreen extends StatelessWidget {
  const PaymentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: ListView(
        children: [
          _logoAndIcon(context),
          _textAndSubText(),
          Gap(50.h),
          _options(),
          Gap(70.h),
          _subscribeCard(context)
        ],
      )),
    );
  }

  Padding _subscribeCard(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 50.w),
      child: DashedBorder(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(5.r),
        strokeWidth: 3.w,
        dashWidth: 4.w,
        dashSpace: 3.w,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 40.w, vertical: 10.h),
          height: 180.h,
          width: 295.w,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5.r),
              color: Color(0xffF0F4ED)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AppText(
                text: 'اشترك بـ 45 جنيه شهريًا',
                fontsize: 16.sp,
                fontWeight: FontWeight.w700,
              ),
              Gap(12.h),
              AppText(
                text: 'واستمتع بكامل مزايا التطبيق لمدة شهر كامل',
                fontsize: 12.sp,
                fontWeight: FontWeight.w500,
                textAlign: TextAlign.center,
              ),
              Gap(15.h),
              InkWell(
                onTap: () {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => SendPaymentImgScreen()));
                },
                child: Container(
                  width: double.infinity,
                  height: 32.h,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.r),
                      color: AppColors.primary),
                  child: Center(
                    child: AppText(
                      text: 'اشترك الأن',
                      color: AppColors.white,
                      fontsize: 13.sp,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Column _options() {
    return Column(
      children: [
        OptionsWidget(text: 'إمكانية التواصل مع جميع المعلنين'),
        Gap(35.h),
        OptionsWidget(text: 'نشر عدد غير محدود من الإعلانات'),
        Gap(35.h),
        OptionsWidget(text: 'يمكن استرداد الأموال خلال أول 7 أيام'),
      ],
    );
  }

  Column _textAndSubText() {
    return Column(
      children: [
        Center(
            child: AppText(
          text: 'التواصل ونشر الإعلانات متاح للمشتركين',
          fontsize: 16.sp,
          fontWeight: FontWeight.w500,
        )),
        Gap(10.h),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 15.w),
          child: Center(
              child: AppText(
            text:
                'للاستفادة من التواصل مع البائعين أو نشر الإعلانات، يرجى الاشتراك في باقة شهرية',
            fontsize: 12.sp,
            fontWeight: FontWeight.w500,
            color: Color(0xff7c7c7c),
            textAlign: TextAlign.center,
          )),
        ),
      ],
    );
  }

  Padding _logoAndIcon(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(),
          Image.asset(
            'assets/images/logo.png',
            height: 105.h,
            width: 105.w,
          ),
          InkWell(
              onTap: () {
                context.pop();
              },
              child: SvgPicture.asset(
                'assets/images/backIcon.svg',
                height: 20.h,
                width: 20.w,
              ))
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:reef/core/constants/app_colors.dart';
import 'package:reef/core/widgets/app_text.dart';
import 'package:reef/feature/onboarding/data/onboarding_model.dart';

List<OnboardingModel> onboardingData = [
  OnboardingModel(
      title: 'أهلاً بيك في ريف',
      description:
          'اول منصه عربيه لبيع وشراء المحاصيل والمواشي وكل ما يخص الريف بسهوله وامان ',
      imagePath: 'assets/images/onb1.png'),
  OnboardingModel(
      title: 'بيع واشتري من ناس زيك',
      description:
          'اعرض منتجاتك الزراعية أو مواشيك، أو دور علي اللي محتاجه من جيرانك وأهل الريف.',
      imagePath: 'assets/images/onb2.png'),
  OnboardingModel(
      title: 'توصلك لحد باب بيتك',
      description: 'تواصل مباشر مع البايع أو اطلب التوصيل، وكل ده من موبايلك.',
      imagePath: 'assets/images/onb3.png'),
];

class ObboardingWidget extends StatelessWidget {
  const ObboardingWidget(
      {super.key, required this.controller, this.onPageChanged});
  final PageController controller;
  final Function(int)? onPageChanged;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 420.h,
      child: PageView.builder(
          onPageChanged: onPageChanged,
          controller: controller,
          itemCount: onboardingData.length,
          itemBuilder: (context, index) {
            return Column(
              children: [
                Image.asset(
                  onboardingData[index].imagePath,
                ),
                Gap(20.h),
                AppText(
                    text: onboardingData[index].title,
                    textAlign: TextAlign.center,
                    fontsize: 18.sp,
                    color: AppColors.black,
                    fontWeight: FontWeight.bold),
                Gap(15.h),
                AppText(
                    text: onboardingData[index].description,
                    textAlign: TextAlign.center,
                    fontsize: 14.sp,
                    color: AppColors.textGrey,
                    fontWeight: FontWeight.w400),
              ],
            );
          }),
    );
  }
}

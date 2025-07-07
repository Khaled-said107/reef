import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:reef/core/constants/app_colors.dart';
import 'package:reef/core/helpers/extensions.dart';
import 'package:reef/core/routing/routes.dart';
import 'package:reef/core/widgets/custom_button.dart';
import 'package:reef/feature/onboarding/logic/isVisited_func.dart';
import 'package:reef/feature/onboarding/ui/widgets/customIndicator.dart';
import 'package:reef/feature/onboarding/ui/widgets/obboarding_widget.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController controller = PageController();
  int currentPage = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: Padding(
      padding: EdgeInsets.symmetric(
        vertical: 50.h,
        horizontal: 30.w,
      ),
      child: ListView(
        children: [
          Gap(10.h),
          ObboardingWidget(
            controller: controller,
            onPageChanged: (index) {
              setState(() {
                currentPage = index;
              });
            },
          ),
          Center(child: Customindicator(controller: controller)),
          Gap(20.h),
          currentPage == onboardingData.length - 1
              ? CustomButton(
                  text: 'ابدا رحلتك في الريف',
                  onPressed: () {
                    finishOnBoarding(context);
                    //context.pushNamed(Routes.register);
                  },
                )
              : Row(
                  children: [
                    CustomButton(
                      text: 'التالي',
                      onPressed: () {
                        controller.nextPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeIn,
                        );
                      },
                      width: 120.w,
                      bgColor: AppColors.primary,
                    ),
                    Spacer(),
                    CustomButton(
                      text: 'تخطي',
                      onPressed: () {
                        finishOnBoarding(context);
                        context.pushNamed(Routes.register);
                      },
                      width: 120.w,
                      bgColor: AppColors.bgColor,
                      textColor: AppColors.black,
                    ),
                  ],
                )
        ],
      ),
    )));
  }
}

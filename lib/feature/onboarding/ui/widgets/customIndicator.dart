import 'package:flutter/material.dart';
import 'package:reef/core/constants/app_colors.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class Customindicator extends StatelessWidget {
  const Customindicator({super.key, required this.controller});
  final PageController controller;

  @override
  Widget build(BuildContext context) {
    return SmoothPageIndicator(controller: controller,
     count: 3,
     effect: const ExpandingDotsEffect(
        dotHeight: 5,
        dotWidth: 5,
        spacing: 10,
      
        dotColor: AppColors.primary,
      activeDotColor: AppColors.primary
     ),
      );
  }
}
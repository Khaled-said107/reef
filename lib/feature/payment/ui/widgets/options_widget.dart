import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:reef/core/constants/app_colors.dart';
import 'package:reef/core/widgets/app_text.dart';

class OptionsWidget extends StatelessWidget {
  const OptionsWidget({super.key, required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 15.w,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          AppText(
            text: text,
            color: AppColors.black,
            fontWeight: FontWeight.w500,
            fontsize: 15.sp,
          ),
          Gap(10.h),
          Image.asset(
            'assets/images/mark.png',
            width: 25.w,
            height: 25.h,
          ),
        ],
      ),
    );
  }
}

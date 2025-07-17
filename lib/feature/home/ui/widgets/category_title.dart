import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:reef/core/constants/app_colors.dart';
import 'package:reef/core/widgets/app_text.dart';

class CategoryTitle extends StatelessWidget {
  const CategoryTitle({super.key, required this.text, this.ontap, this.more});
  final String text;
  final Function()? ontap;
  final String? more;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 15.w),
      child: Row(
        children: [
          InkWell(
            onTap: ontap,
            child: AppText(
              text: more ?? 'المزيد',
              color: AppColors.primary,
              fontWeight: FontWeight.w700,
            ),
          ),
          Spacer(),
          AppText(
            text: text,
            color: AppColors.black,
            fontWeight: FontWeight.w500,
            fontsize: 18.sp,
          ),
          Gap(10.h),
          Image.asset('assets/images/mark.png', width: 25.w, height: 25.h),
        ],
      ),
    );
  }
}

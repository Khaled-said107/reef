import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:reef/core/constants/app_colors.dart';
import 'package:reef/core/widgets/app_text.dart';

class PostsManage extends StatelessWidget {
  const PostsManage({
    super.key,
    required this.img,
    required this.text,
    required this.num,
  });
  final String img;
  final String text;
  final String num;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 7.h),
      width: 102.w,
      // height: 90.h,
      decoration: BoxDecoration(
        color: Color(0xffF0F4ED),
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Center(
        child: Column(
          children: [
            Image.asset(img, width: 20.w, height: 20.h),
            Gap(5.h),
            AppText(
              text: text,
              fontsize: 10.sp,
              fontWeight: FontWeight.w500,
              textAlign: TextAlign.center,
            ),
            Divider(color: Color(0xff6A994E).withOpacity(0.3), thickness: 1.h),
            AppText(
              text: num,
              color: AppColors.primary,
              fontsize: 14.sp,
              fontWeight: FontWeight.w500,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

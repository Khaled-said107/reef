import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:reef/core/widgets/app_text.dart';

class PostRich extends StatelessWidget {
  const PostRich({
    super.key,
    required this.img,
    required this.text,
    this.onTap,
    this.color,
  });
  final String img;
  final String text;
  final VoidCallback? onTap;
  final Color? color;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          Image.asset(img, width: 13.w, height: 13.h),
          Gap(3.h),
          AppText(text: text, fontsize: 10.sp, color: color),
          Gap(5.h),
        ],
      ),
    );
  }
}

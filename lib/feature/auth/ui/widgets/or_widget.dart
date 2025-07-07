import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:reef/core/widgets/app_text.dart';

class or extends StatelessWidget {
  const or({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Divider(
            color: Colors.grey.shade300,
            height: 1.h,
            thickness: 1.h,
          ),
        ),
        Gap(5.w),
        AppText(text: 'أو', fontsize: 15.sp, color: Colors.grey.shade300),
        Gap(5.w),
        Expanded(
          child: Divider(
            color: Colors.grey.shade300,
            height: 1.h,
            thickness: 1.h,
          ),
        ),
      ]
      ,
    );
  }
}
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

import 'app_text.dart';

class header extends StatelessWidget {
  const header({super.key, required this.name,  this.icon});
final String name;
final IconData? icon;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Image.asset('assets/images/logo.png', width: 60.w),
        Row(
          children: [
            AppText(
              text: name,
              fontWeight: FontWeight.w500,
              fontsize: 16.sp,
            ),
            Gap(5.h),
            GestureDetector(
              onTap: (){
                Navigator.pop(context);
              },
                child: Icon(icon))
          ],
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:reef/core/constants/app_colors.dart';
import 'package:reef/core/helpers/extensions.dart';
import 'package:reef/core/routing/routes.dart';

class TextFooter extends StatelessWidget {
  const TextFooter({
    super.key,
    required this.text1,
    required this.text2,
    required this.onPressed,
  });
  final VoidCallback onPressed;
  final String text1;
  final String text2;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        InkWell(
          onTap: onPressed,
          child: Text(text1,
              style: TextStyle(
                fontSize: 13.sp,
                fontWeight: FontWeight.w800,
                fontFamily: 'Tajawal',
                color: AppColors.primary,
              )),
        ),
        Text(text2,
            style: TextStyle(
              fontSize: 13.sp,
              fontWeight: FontWeight.w500,
              fontFamily: 'Tajawal',
              color: AppColors.textGrey,
            )),
      ],
    );
  }
}

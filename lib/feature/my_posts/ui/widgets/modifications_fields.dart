import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:reef/core/widgets/app_text.dart';
import 'package:reef/core/widgets/custom_feild.dart';

class ModificationsFields extends StatelessWidget {
  const ModificationsFields({
    super.key,
    required this.title,
    required this.hint,
    this.controller,
  });
  final String title;
  final TextEditingController? controller;
  final String hint;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Gap(12.h),
        AppText(text: title, fontsize: 13.sp, color: Color(0xff7c7c7c)),
        Gap(8.h),
        CustomFeild(hintText: hint, obscureText: false, controller: controller),
      ],
    );
  }
}

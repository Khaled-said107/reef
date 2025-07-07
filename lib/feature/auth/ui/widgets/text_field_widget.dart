import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:reef/core/widgets/app_text.dart';
import 'package:reef/core/widgets/custom_feild.dart';

class TextFieldWidget extends StatelessWidget {
  const TextFieldWidget({super.key, required this.text, required this.hintText, required this.star, this.validator, this.icon, this.obscureText, this.controller});
  final String text;
  final String star;
 final String hintText;
  final Widget? icon;
  final bool? obscureText;
  final TextEditingController? controller;

  final String? Function(String?)? validator;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            AppText(text: star, fontsize: 18.sp, color: Colors.red,),
            Gap(5.w),
            AppText(text: text, fontsize: 15.sp,),
          ],
        ),
        Gap(1.h),
        CustomFeild(
          controller: controller,
          icon: icon,
          obscureText: obscureText ?? false,
          hintText: hintText, validator: validator, )
      ],
    );
  }
}
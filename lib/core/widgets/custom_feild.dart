import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:reef/core/constants/app_colors.dart';

class CustomFeild extends StatelessWidget {
  CustomFeild({
    super.key,
    required this.hintText,
    this.validator,
    this.obscureText,
    this.icon,
    this.controller,
  });

  final String hintText;
  final String? Function(String?)? validator;
  final bool? obscureText;
  final Widget? icon;
  final TextEditingController? controller;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      textDirection: TextDirection.rtl,
      obscureText: obscureText ?? false,
      validator: validator,
      decoration: InputDecoration(
        prefixIcon: icon,
        filled: true,
        fillColor: AppColors.bgColor,
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            color: AppColors.primary,
            width: 1,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.r),
          borderSide: BorderSide(
            color: const Color.fromARGB(255, 194, 194, 194),
            width: 1,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.r),
          borderSide: BorderSide(
            color: Colors.red,
            width: 1,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.r),
          borderSide: BorderSide(
            color: Colors.red,
            width: 1,
          ),
        ),
        hintText: hintText,
        hintTextDirection: TextDirection.rtl,
        hintStyle: TextStyle(
          color: Colors.grey,
          fontFamily: 'Tajawal',
          fontSize: 12.sp,
        ),
        contentPadding: EdgeInsets.symmetric(vertical: 3.h, horizontal: 10.w),
      ),
    );
  }
}

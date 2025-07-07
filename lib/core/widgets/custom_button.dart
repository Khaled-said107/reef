import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:reef/core/constants/app_colors.dart';

class CustomButton extends StatelessWidget {
   CustomButton({super.key, required this.text, required this.onPressed, this.textColor, this.bgColor, this.width, this.height, this.fontsize});
  final String text;
  final VoidCallback onPressed;
  final Color ?textColor;
  final Color ?bgColor;
  final double? width;
  final double? height; 
  final double? fontsize; 


  @override
  Widget build(BuildContext context) {
    return Container(
      width: width ?? double.infinity,
      height: height?? 50.h,
      child: ElevatedButton(
        onPressed: onPressed,
         child: Text(
          text,
          style:  TextStyle(
            fontFamily: 'Tajawal',
            fontWeight: FontWeight.w500,
            fontSize:  fontsize?? 16.sp,
            color: textColor ?? AppColors.white,
          ),),
          style: ElevatedButton.styleFrom(
            backgroundColor: bgColor?? AppColors.primary,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            shape: RoundedRectangleBorder(
              side: BorderSide(
                color: AppColors.primary,
                width: 1,
              ),
              borderRadius: BorderRadius.circular(8.r),
              
            ),
          )),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:reef/core/constants/app_colors.dart';
import 'package:reef/core/widgets/app_text.dart';

class LogoAndTexts extends StatelessWidget {
  const LogoAndTexts({
    super.key, required this.text, required this.desc,
  });
  final String text;
  final String desc;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
       
        Image.asset(
          'assets/images/logo.png',
          width: 106.w,
          height: 106.h,
        ),
                  Center(child: AppText(text: text,fontsize: 16.sp,fontWeight:  FontWeight.w700,)),
                   Gap(3.h),
                  AppText(text: desc,fontsize: 13.sp,color: AppColors.textGrey, textAlign: TextAlign.center,),
                  Gap(12.h),
                 
                
              
      ],
    );
  }
}

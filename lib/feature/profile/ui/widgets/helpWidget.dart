import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:reef/core/widgets/app_text.dart';

import '../../../../core/constants/app_colors.dart';

class Helpwidget extends StatelessWidget {
   Helpwidget({super.key , required this.img,required this.name});
  final String img;
  final String name ;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 99.w,
      height: 92.h,
      decoration: BoxDecoration(
        color: Color(0xFFF3EFE1),
        border:Border.all(color: AppColors.primary),
        borderRadius: BorderRadius.circular(5)
      ),
      child: Center(
        child: Column(
          children: [
            Gap(10.h),
           Image(image: AssetImage(img),height: 30,width: 30,),
            Gap(20.h),
            AppText(text: name,color: Colors.black,fontsize: 11.sp,)
          ],
        ),
      ),

    ) ;
  }
}

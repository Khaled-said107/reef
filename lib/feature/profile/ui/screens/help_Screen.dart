import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:reef/core/constants/app_colors.dart';
import 'package:reef/core/widgets/app_text.dart';
import 'package:reef/core/widgets/header.dart';

import '../widgets/helpWidget.dart';

class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Column(
            children: [
              header(name: "الدعم و المساعده",icon: Icons.navigate_next,),
              Gap(10.h),
              Image(image: AssetImage('assets/images/helpIcon.png')),
              Gap(50.h),
              AppText(text: "كيف يمكننا مساعدتك ؟"),
              Gap(3.h),
              AppText(text: "نحن هنا لمساعدتك . تواصل معنا في اي وقت",color: AppColors.textGrey,),
              Gap(40.h),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Helpwidget(img:'assets/images/bxs_chat.png' ,name:"أرسل ايمال" ,),
                  Gap(15.w),
                  Helpwidget(img: 'assets/images/whats.png',name: 'ابدا المحادثه ',),
                  Gap(15.w),
                  Helpwidget(img:'assets/images/callUs.png' ,name:'اتصل بنا ' ,),

                ],
              )

            ],
          )

      ),
    );
  }
}

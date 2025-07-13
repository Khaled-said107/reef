import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:reef/core/constants/app_colors.dart';
import 'package:reef/core/widgets/app_text.dart';
import 'package:reef/core/widgets/header.dart';
import 'package:url_launcher/url_launcher.dart';
import '../widgets/helpWidget.dart';

class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Column(
        children: [
          header(
            name: "الدعم و المساعده",
            icon: Icons.navigate_next,
          ),
          Gap(10.h),
          Image(image: AssetImage('assets/images/helpIcon.png')),
          Gap(50.h),
          AppText(text: "كيف يمكننا مساعدتك ؟"),
          Gap(3.h),
          AppText(
            text: "نحن هنا لمساعدتك . تواصل معنا في اي وقت",
            color: AppColors.textGrey,
          ),
          Gap(50.h),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () {
                  _launchURL();
                },
                child: Helpwidget(
                  img: 'assets/images/whats.png',
                  name: 'ابدا المحادثه ',
                ),
              ),
              Gap(30.w),
              GestureDetector(
                onTap: () {
                  _callPhoneNumber();
                },
                child: Helpwidget(
                  img: 'assets/images/callUs.png',
                  name: 'اتصل بنا ',
                ),
              ),
            ],
          )
        ],
      )),
    );
  }

  final String phone = '01091944770';
  Future<void> _callPhoneNumber() async {
    final Uri url = Uri(scheme: 'tel', path: phone);
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw 'لا يمكن فتح تطبيق الهاتف';
    }
  }

  void _launchURL() async {
    final Uri uri = Uri.parse('https://wa.me/+2$phone');
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw 'Could not launch $phone';
    }
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:reef/core/constants/app_colors.dart';

import '../../../../core/widgets/app_text.dart';

class Favwidget extends StatelessWidget {
  const Favwidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.all(15.0),
          child: Container(
          //  height: 127.h,
            decoration: BoxDecoration(
              color: const Color(0xffFFFEF8),
              border: Border.all(color: const Color(0xffEFEAD8)),
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Directionality(
              textDirection: TextDirection.rtl,
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(10.r),
                      bottomRight: Radius.circular(10.r),
                    ),
                    child: Image.asset(
                      'assets/images/sub1.png',
                      height: 127.h,
                      width: 123.w,
                      fit: BoxFit.fill,
                    ),
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                            8.w,
                            12.h,
                            12.w,
                            12.h,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // اسم وسعر
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  AppText(
                                    text: 'بقرة فريزيان حلوب',
                                    fontsize: 11.sp,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  AppText(
                                    text: '١٨٠٠ جنيه',
                                    fontsize: 13.sp,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ],
                              ),
                              Gap(6.h),

                              // وصف
                              AppText(
                                text:
                                    'بقرة صحية عمرها سنتين ونصف. بتنتج حوالي 12 لتر حليب يوميًا',
                                fontsize: 7.sp,
                                fontWeight: FontWeight.w500,
                                color: const Color(0xff7c7c7c),
                              ),
                              Gap(20.h),

                              // عنوان
                              AppText(
                                text: 'العنوان: المنوفية - الشهداء',
                                fontsize: 6.sp,
                                fontWeight: FontWeight.w700,
                                color: const Color(0xff6A994E),
                              ),
                            ],
                          ),
                        ),

                        const Divider(
                          color: Color(0xffEFEAD8),
                          thickness: 1,
                          height: 1, // يمنع وجود فراغ تحت الخط
                        ),

                        // تفاصيل أخيرة
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                            8.w,
                            8.h,
                            12.w,
                            4.h,
                          ),
                          child: Row(
                            children: [
                              AppText(
                                text: 'ياسر أحمد علي - منذ ٧ أيام',
                                fontsize: 6.sp,
                                color: const Color(0xff7c7c7c),
                              ),
                              const Spacer(),
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 8.w,
                                  vertical: 4.h,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(0xff6A994E),
                                  borderRadius: BorderRadius.circular(5.r),
                                ),
                                child: AppText(
                                  text: 'عرض التفاصيل',
                                  color: Colors.white,
                                  fontsize: 7.sp,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: CircleAvatar(
                radius: 15.r,
                child: Image(image: AssetImage('assets/images/Vector.png')),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

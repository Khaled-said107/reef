import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:reef/core/constants/app_colors.dart';
import 'package:reef/core/widgets/app_text.dart';

class SubCategorycard extends StatelessWidget {
  const SubCategorycard({
    super.key,
    required this.image,
    required this.price,
    required this.title,
    required this.name,
    required this.date,
    required this.address,
    required this.desc,
    this.onTap,
  });
  final String image;
  final String price;
  final String title;
  final String name;
  final String date;
  final String address;
  final String desc;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.only(
          right: 5.w,
          left: 5.w,
          top: 10.h,
        ),
        //  height: 255.h,
        width: 210.w,
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: Color(0xffEFEAD8), width: 0.5.w),
            borderRadius: BorderRadius.circular(8.r),
            color: Color(0xffFFFEF8),
          ),
          // sheight: 100.h,
          child: Column(
            children: [
              Container(
                width: double.infinity,
                height: 80.h,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(8.r),
                    topRight: Radius.circular(8.r),
                  ), // اختياري: زاوية دوران
                  image: DecorationImage(
                    image: NetworkImage(image),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                  right: 8.w,
                  left: 8.w,
                  top: 5.h,
                  bottom: 9.h,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        AppText(
                          text: title,
                          fontsize: 12.sp,
                          fontWeight: FontWeight.w500,
                        ),
                        Spacer(),
                        AppText(
                          text: ' ${price}',
                          fontsize: 11.sp,
                          fontWeight: FontWeight.w700,
                        ),
                      ],
                    ),
                    Gap(5.h),
                    AppText(
                      textAlign: TextAlign.end,
                      text: desc,
                      fontsize: 8.sp,
                      fontWeight: FontWeight.w500,
                      maxLines: 1,
                    ),
                  ],
                ),
              ),
              Divider(color: Color(0xffEFEAD8), thickness: .5),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.w),
                child: Row(
                  children: [
                    AppText(
                      text: 'العنوان:${address}',
                      fontsize: 7.sp,
                      color: AppColors.primary,
                      fontWeight: FontWeight.w700,
                    ),
                    Spacer(),
                    AppText(
                      text: '  ${name} - ${date}  ',
                      fontsize: 7.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

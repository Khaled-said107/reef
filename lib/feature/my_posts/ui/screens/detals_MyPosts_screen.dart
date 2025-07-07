import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:reef/core/helpers/extensions.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/routing/routes.dart';
import '../../../../core/widgets/Img_In_Detalse.dart';
import '../../../../core/widgets/app_text.dart';
import '../../data/Model/MyPost_Model.dart';

class DetalsMyPosts extends StatelessWidget {
  final Post post;
  DetalsMyPosts({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 5.h),
          child: ListView(
            children: [
              _header(context),
              _image(),
              Gap(10.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    _titleAndPrice(),
                    Gap(10.h),
                    _desc(),
                    Gap(20.h),
                    _availableQuantity(),
                    Gap(15.w),
                    _dateAndAddress(),
                    Gap(10.w),
                    _theTable(),
                    Gap(10.w),
                    _buyerAndRating(),
                    Gap(20.w),
                    _buttons(context, post.phone),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _callPhoneNumber(String phoneNumber) async {
    final Uri url = Uri.parse('tel:$phoneNumber');

    if (await canLaunchUrl(url)) {
      final bool launched =
          await launchUrl(url, mode: LaunchMode.externalApplication);
      if (!launched) {
        throw 'فشل في فتح تطبيق الاتصال';
      }
    } else {
      throw 'لا يمكن فتح تطبيق الهاتف';
    }
  }

  void _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw 'Could not launch $url';
    }
  }

  Widget _image() {
    return SizedBox(
      height: 240.h,
      width: double.infinity,
      child: PageView.builder(
        itemCount: post.images.length, //widget.img.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => ImgInDetalse(
                    imgs: post.images
                        .map((e) => 'http://82.29.172.199:8001$e')
                        .toList(),
                    imgIndex: index),
              ));
            },
            child: Image.network(
              'http://82.29.172.199:8001${post.images[index]}',
              fit: BoxFit.cover,
            ),
          );
        },
      ),
    );
  }

  Row _buttons(BuildContext context, String phone) {
    return Row(
      children: [
        Expanded(
          child: InkWell(
            onTap: () {
              _launchURL('https://wa.me/+2$phone');
            },
            child: Container(
              width: double.infinity,
              height: 38.h,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.r),
                color: AppColors.primary,
              ),
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/images/whatsapp.png',
                      width: 20.w,
                      height: 20.h,
                    ),
                    Gap(20.w),
                    AppText(
                      text: 'راسل البائع  ',
                      color: AppColors.white,
                      fontsize: 13.sp,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        Gap(20.w),
        Expanded(
          child: GestureDetector(
            onTap: () {
              _callPhoneNumber(phone);
            },
            child: Container(
              width: double.infinity,
              height: 38.h,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.r),
                color: AppColors.primary,
              ),
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/images/phone.png',
                      width: 20.w,
                      height: 20.h,
                    ),
                    Gap(20.w),
                    AppText(
                      text: 'اتصل بالبائع',
                      color: AppColors.white,
                      fontsize: 13.sp,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Row _buyerAndRating() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        RatingBarIndicator(
          rating: 4,
          itemBuilder: (context, index) =>
              Icon(Icons.star, color: Colors.amber),
          itemCount: 5,
          itemSize: 15.0,
          direction: Axis.horizontal,
        ),
        SizedBox(width: 8),
        AppText(
          text: "اسم البائع:   ${post.name ?? 'غير محدد'}",
          fontsize: 12.sp,
        ),
        Gap(7.w),
        Image.asset(
          'assets/images/check-circle.png',
          width: 14.w,
          height: 14.h,
        ),
      ],
    );
  }

  Directionality _theTable() {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
        decoration: BoxDecoration(
          color: Color(0xffF0F4ED),
          borderRadius: BorderRadius.circular(10.r),
          border: Border.all(color: Color(0xffE1EADB)),
        ),
        child: Table(
          border: TableBorder(
            horizontalInside: BorderSide(color: Color(0xffE1EADB), width: 1),
            verticalInside: BorderSide(color: Color(0xffE1EADB), width: 1),
          ),
          columnWidths: const {0: FlexColumnWidth(1), 1: FlexColumnWidth(1)},
          children: [
            _buildTableRow("الحالة", post.sellType ?? "غير محدد"),
            _buildTableRow("طريقة البيع", post.sellType ?? "غير محدد"),
            _buildTableRow("طريقة التوصيل", "استلام من المزرعة"),
          ],
        ),
      ),
    );
  }

  Row _dateAndAddress() {
    return Row(
      children: [
        AppText(
          text: 'تاريخ النشر:  ${post.createdAt ?? ''}',
          color: Color(0xff7C7C7C),
          fontsize: 8.sp,
        ),
        Spacer(),
        AppText(
          text: 'العنوان: ${post.address ?? 'غير محدد'}',
          color: AppColors.primary,
          fontsize: 12.sp,
        ),
        Gap(5.w),
        Image.asset('assets/images/map.png', width: 12, height: 14.h),
      ],
    );
  }

  Container _availableQuantity() {
    return Container(
      width: 180.w,
      height: 36.h,
      decoration: BoxDecoration(
        color: Color(0xffF0F4ED),
        border: Border.all(color: Color(0xffE1EADB), width: 1.w),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Center(
        child: AppText(
          text: 'الكمية المتوفرة:  ${post.quantity}',
          fontsize: 13.sp,
        ),
      ),
    );
  }

  AppText _desc() {
    return AppText(
      textAlign: TextAlign.right,
      text: post.description,
      color: Color(0xff7C7C7C),
      fontWeight: FontWeight.w500,
      fontsize: 11.sp,
    );
  }

  Row _titleAndPrice() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            AppText(
              text: 'للكيلو/',
              color: AppColors.primary,
              fontWeight: FontWeight.w500,
              fontsize: 11.sp,
            ),
            AppText(
              text: '${post.price} جنيه',
              color: Color(0xff3A3A3A),
              fontWeight: FontWeight.w700,
              fontsize: 21.sp,
            ),
          ],
        ),
        AppText(
          text: post.name,
          color: Color(0xff3A3A3A),
          fontWeight: FontWeight.w700,
          fontsize: 16.sp,
        ),
      ],
    );
  }

  TableRow _buildTableRow(String title, String value) {
    return TableRow(
      children: [
        Padding(
          padding: EdgeInsets.all(10.w),
          child: AppText(text: title, fontWeight: FontWeight.w500),
        ),
        Padding(
          padding: EdgeInsets.all(10.w),
          child: AppText(text: value, fontWeight: FontWeight.w400),
        ),
      ],
    );
  }

  Padding _header(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 20.h),
      child: Row(
        children: [
          Spacer(),
          AppText(text: post.name, fontsize: 16.sp),
          Gap(20.w),
          GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: SvgPicture.asset('assets/images/backIcon.svg')),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:reef/core/constants/app_colors.dart';
import 'package:reef/core/helpers/extensions.dart';
import 'package:reef/core/routing/routes.dart';
import 'package:reef/core/widgets/app_text.dart';

import '../../data/DriversResponseModel.dart';

class PostCard extends StatefulWidget {
  const PostCard({super.key, required this.drivers, this.onBackFromDetails});
  final DriverModel drivers;
  final VoidCallback? onBackFromDetails;

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        await context.pushNamed(Routes.truckDetailsScreen,
            arguments: widget.drivers);
        widget.onBackFromDetails?.call();
      },
      child: Container(
        //  height: 127.h,
        decoration: BoxDecoration(
          color: const Color(0xffFFFEF8),
          border: Border.all(color: const Color(0xffEFEAD8)),
          borderRadius: BorderRadius.circular(10.r),
        ),
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: Row(children: [_itemImage(), _itemContent()]),
        ),
      ),
    );
  }

  Widget _itemImage() {
    return ClipRRect(
      borderRadius: BorderRadius.only(
        topRight: Radius.circular(10.r),
        bottomRight: Radius.circular(10.r),
      ),
      child: Image.network(
        widget.drivers.vehicleImages.isNotEmpty == true
            ? 'http://82.29.172.199:8001${widget.drivers.vehicleImages.first}'
            : 'https://via.placeholder.com/123x127',
        height: 127.h,
        width: 123.w,
        fit: BoxFit.cover,
      ),
    );
  }

  Widget _itemContent() {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsetsDirectional.fromSTEB(8.w, 12.h, 12.w, 12.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText(
                  text: widget.drivers.title ?? '',
                  fontsize: 13.sp,
                  fontWeight: FontWeight.w500,
                ),
                Gap(6.h),

                // وصف
                AppText(
                  text: widget.drivers.description ?? '',
                  fontsize: 7.sp,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xff7c7c7c),
                ),
                Gap(20.h),

                // عنوان
                AppText(
                  text:
                      'العنوان: ${widget.drivers.user.address ?? '-'} - ${widget.drivers.user.area ?? '-'}',
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
            padding: EdgeInsetsDirectional.fromSTEB(8.w, 8.h, 12.w, 4.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    AppText(
                      text: widget.drivers.user.name ?? '',
                      fontsize: 7.sp,
                      color: const Color(0xff7c7c7c),
                    ),
                    RatingBarIndicator(
                      rating: 4,
                      itemBuilder: (context, index) =>
                          Icon(Icons.star, color: Colors.amber),
                      itemCount: 5,
                      itemSize: 8.0,
                      direction: Axis.horizontal,
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
                // AppText(
                //   text: 'الخبرة 5 سنوات',
                //   fontsize: 6.sp,
                //   color: AppColors.primary,
                // ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

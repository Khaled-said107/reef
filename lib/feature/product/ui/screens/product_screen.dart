import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:reef/core/constants/app_colors.dart';
import 'package:reef/core/helpers/extensions.dart';
import 'package:reef/core/routing/routes.dart';
import 'package:reef/core/widgets/app_text.dart';
import 'package:reef/core/widgets/headar.dart';
import 'package:reef/feature/categories/data/post_model.dart';
import 'package:reef/feature/categories/logic/cubit/category_cubit.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/widgets/Img_In_Detalse.dart';

class ProductScreen extends StatefulWidget {
  const ProductScreen({super.key, required this.postId});

  final String postId;

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  PostModel? post;

  @override
  void initState() {
    super.initState();
    context.read<CategoryCubit>().getSinglePost(widget.postId);
  }

  String formatText(String text, int maxWordsPerLine) {
    final words = text.split(' ');
    if (words.length <= maxWordsPerLine) return text;

    final firstLine = words.take(maxWordsPerLine).join(' ');
    final rest = words.skip(maxWordsPerLine).join(' ');
    return '$firstLine\n$rest';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocBuilder<CategoryCubit, CategoryState>(
          builder: (context, state) {
            if (state is CategoryLoading || state is SinglePostLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is SinglePostSuccess) {
              post = state.post;
              return _buildContent();
            } else if (state is SinglePostError) {
              return Center(
                  child: AppText(
                text: state.message == 'Post is not accepted'
                    ? 'لم يتم قبول هذا المنشور من قبل المسؤولين'
                    : state.message ==
                            'Your subscription has expired. Please renew to continue.'
                        ? 'يجب الاشتراك في التطبيق من صفحة الملف الشخصي'
                        : 'حدث خط ${state.message}',
              ));
            } else {
              return const SizedBox();
            }
          },
        ),
      ),
    );
  }

  Widget _buildContent() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5.h),
      child: ListView(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 7.w),
            child: header(
              title: post!.name!,
              icon: Icons.arrow_forward_ios,
            ),
          ),
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
                _buttons(context, post!.phone!, post!.phone!),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ✅ باقي الدوال تحت زي ما هي بالظبط
  // ✅ بس هنعدل كل استخدام لـ post عشان نتأكد إنها مش null

  Row _buttons(BuildContext context, String whatsapp, String phone) {
    return Row(
      children: [
        Expanded(
          child: InkWell(
            ///whatsapp
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
                      text: 'راسل البائع',
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

  Widget _image() {
    return SizedBox(
      height: 240.h,
      width: double.infinity,
      child: PageView.builder(
        itemCount: post?.images.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => ImgInDetalse(
                    imgs: post!.images
                        .map((e) => 'http://82.29.172.199:8001$e')
                        .toList(),
                    imgIndex: index),
              ));
            },
            child: Image.network(
              post!.images.isNotEmpty
                  ? 'http://82.29.172.199:8001${post!.images[index]}'
                  : 'assets/images/default_product_image.png',
              height: 240.h,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          );
        },
      ),
    );
  }

  Future<void> _callPhoneNumber(String phoneNumber) async {
    final Uri url = Uri(scheme: 'tel', path: phoneNumber);
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
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
          text: "اسم البائع:   ${post!.userName ?? 'غير محدد'}",
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
            _buildTableRow("الحالة", post!.condition ?? "غير محدد"),
            _buildTableRow("طريقة البيع", post!.sellType ?? "غير محدد"),
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
          text:
              'تاريخ النشر:  ${post!.createdAt?.toString().split("T").first ?? ''}',
          color: Color(0xff7C7C7C),
          fontsize: 8.sp,
        ),
        Spacer(),
        AppText(
          text: 'العنوان: ${post!.address ?? 'غير محدد'}',
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
          text: 'الكمية المتوفرة:  ${post!.quantity}',
          fontsize: 13.sp,
        ),
      ),
    );
  }

  AppText _desc() {
    return AppText(
      textAlign: TextAlign.right,
      text: post!.description!,
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
              text: '${post!.price} جنيه',
              color: Color(0xff3A3A3A),
              fontWeight: FontWeight.w700,
              fontsize: 21.sp,
            ),
          ],
        ),
        AppText(
          text: formatText(post!.name!, 5), // 5 كلمات في السطر الأول
          color: Color(0xff3A3A3A),
          fontWeight: FontWeight.w700,
          fontsize: 16.sp,
          textAlign: TextAlign.right,
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

  Padding _header() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 20.h),
      child: Row(
        children: [
          Image.asset('assets/images/logo.png'),
          Spacer(),
          GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Row(
              children: [
                AppText(text: post!.name!, fontsize: 16.sp),
                Gap(20.w),
                SvgPicture.asset('assets/images/backIcon.svg')
              ],
            ),
          ),
        ],
      ),
    );
  }
}

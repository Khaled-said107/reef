import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:reef/core/constants/app_colors.dart';
import 'package:reef/core/widgets/app_text.dart';
import 'package:reef/feature/my_posts/data/Model/MyCar_Modle.dart';
import 'package:reef/feature/my_posts/ui/screens/UpdateMyCarPage.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/widgets/Img_In_Detalse.dart';
import '../../../../core/widgets/headar.dart';

class MyCarWidget extends StatelessWidget {
  final MyCarModel MycarModl;
  const MyCarWidget({super.key, required this.MycarModl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: SafeArea(child: _buildContent(context)));
  }

  Widget _buildContent(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5.h),
      child: ListView(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 15.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  onTap: () {
                    showPostOptionsBottomSheet(context, MycarModl);
                  },
                  child: Icon(Icons.more_vert, size: 18.sp),
                ),
                Row(
                  children: [
                    RatingBarIndicator(
                      rating: 4,
                      itemBuilder: (context, index) =>
                          Icon(Icons.star, color: Colors.amber),
                      itemCount: 5,
                      itemSize: 10.0,
                      direction: Axis.horizontal,
                    ),
                    Gap(10.w),
                    AppText(
                      text: MycarModl.userName.toString(),
                      fontWeight: FontWeight.w500,
                      fontsize: 16.sp,
                    ),
                    Gap(7.w),
                    CircleAvatar(
                        backgroundColor: AppColors.bgColor,
                        radius: 22.r,
                        backgroundImage: NetworkImage(
                            'http://82.29.172.199:8001${MycarModl.userPhoto}'))
                  ],
                ),
              ],
            ),
          ),
          Gap(10.h),
          _image(),
          Gap(10.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                AppText(
                  text: MycarModl.title.toString(),
                  color: Color(0xff3A3A3A),
                  fontWeight: FontWeight.w700,
                  fontsize: 16.sp,
                ),
                Gap(10.h),
                _desc(MycarModl),
                Gap(20.h),
                _availableQuantity(),
                Gap(15.w),
                _dateAndAddress(MycarModl),
                Gap(10.w),
                _theTable(MycarModl),
                Gap(20.w),
                _buttons(context, MycarModl.userPhoto.toString()),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ✅ باقي الدوال تحت زي ما هي بالظبط
  // Image _image() => Image.network(
  //       driver.vehicleImages.isNotEmpty == true
  //           ? 'http://82.29.172.199:8001${driver.vehicleImages.first}'
  //           : 'https://via.placeholder.com/123x127',
  //       height: 240.h,
  //       width: double.infinity,
  //       fit: BoxFit.fill,
  //     );

  Widget _image() {
    return SizedBox(
      height: 240.h,
      width: double.infinity,
      child: PageView.builder(
        itemCount: MycarModl.vehicleImages?.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => ImgInDetalse(
                    imgs: MycarModl.vehicleImages!
                        .map((e) => 'http://82.29.172.199:8001$e')
                        .toList(),
                    imgIndex: index),
              ));
            },
            child: Image.network(
              MycarModl.vehicleImages!.isNotEmpty
                  ? 'http://82.29.172.199:8001${MycarModl.vehicleImages?[index]}'
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

  //  Image.network(
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
                      text: 'راسل السائق  ',
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
                      text: 'اتصل بالسائق',
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

void showPostOptionsBottomSheet(BuildContext context, MyCarModel mycarModel) {
  showModalBottomSheet(
    context: context,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    backgroundColor: Colors.white,
    builder: (_) => Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey.shade400,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 20),
          _buildOptionItem('edit', "تعديل", () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => UpdateMyCarScreen(
                    myCarmodel: mycarModel,
                  ),
                ));
            // TODO: Navigate to edit screen
          }),
          const SizedBox(height: 10),
        ],
      ),
    ),
  );
}

Widget _buildOptionItem(String icon, String title, VoidCallback onTap) {
  return ListTile(
    onTap: onTap,
    contentPadding: EdgeInsets.zero,
    leading: Image.asset('assets/images/$icon.png', width: 20.w, height: 20.h),
    title: Text(
      title,
      style: TextStyle(fontWeight: FontWeight.w500, fontFamily: 'tajawal'),
      textAlign: TextAlign.right,
    ),
  );
}

Directionality _theTable(MyCarModel car) {
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
          _buildTableRow("نوع الحمولة", car.cargoType ?? '-'),
          _buildTableRow("آخر صيانة", car.lastMaintenance ?? '-'),
          _buildTableRow("التوصيل", car.deliveryType ?? '-'),
          _buildTableRow("نوع العربية", car.vehicleType ?? '-'),
        ],
      ),
    ),
  );
}

Row _dateAndAddress(MyCarModel car) {
  return Row(
    children: [
      AppText(
        text: 'تاريخ النشر:  ${car.time?.split('T').first}',
        color: Color(0xff7C7C7C),
        fontsize: 8.sp,
      ),
      Spacer(),
      AppText(
        text: 'العنوان: ${car.UserAdrres}',
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
    child: Center(child: AppText(text: 'حمولة العربية: 2 طن', fontsize: 13.sp)),
  );
}

AppText _desc(MyCarModel car) {
  return AppText(
    textAlign: TextAlign.right,
    text: car.description.toString(),
    color: Color(0xff7C7C7C),
    fontWeight: FontWeight.w500,
    fontsize: 11.sp,
    //maxLine: 10,
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
        child: AppText(
          text: value,
          fontWeight: FontWeight.w400,
          fontsize: 11.sp,
        ),
      ),
    ],
  );
}

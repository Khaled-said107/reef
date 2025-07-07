import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:reef/core/constants/app_colors.dart';
import 'package:reef/core/helpers/cach_helper.dart';

class CustomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomNavBar(
      {Key? key, required this.currentIndex, required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var role = CacheHelper.getData('role');
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.bottomCenter,
      children: [
        // Bottom Navigation Bar
        BottomNavigationBar(
          backgroundColor: const Color(0xFFEFEAD8),
          selectedLabelStyle: const TextStyle(fontFamily: 'Tajawal'),
          unselectedLabelStyle: const TextStyle(fontFamily: 'Tajawal'),
          currentIndex: currentIndex,
          onTap: onTap,
          selectedItemColor: AppColors.primary,
          unselectedItemColor: Colors.grey,
          type: BottomNavigationBarType.fixed,
          selectedFontSize: 10.sp,
          unselectedFontSize: 10.sp,
          items: [
            BottomNavigationBarItem(
              icon: Padding(
                padding: EdgeInsets.only(bottom: 5.h),
                child: SvgPicture.asset('assets/images/user.svg'),
              ),
              activeIcon: Padding(
                padding: EdgeInsets.only(bottom: 5.h),
                child: SvgPicture.asset('assets/images/profileActive.svg'),
              ),
              label: "الملف الشخصي",
            ),
            BottomNavigationBarItem(
              icon: Padding(
                padding: EdgeInsets.only(bottom: 5.h),
                child: SvgPicture.asset('assets/images/myPosts.svg'),
              ),
              activeIcon: Padding(
                padding: EdgeInsets.only(bottom: 5.h),
                child: SvgPicture.asset('assets/images/myPostsActive.svg'),
              ),
              label: "إعلاناتي",
            ),
            // Placeholder (هيفضل فاضي)
            BottomNavigationBarItem(
              icon: Padding(
                padding: EdgeInsets.only(bottom: 18.h),
                child: SizedBox.shrink(),
              ),
              label: "إضافة إعلان",
            ),
            BottomNavigationBarItem(
                icon: Padding(
                  padding: EdgeInsets.only(bottom: 5.h),
                  child: SvgPicture.asset('assets/images/categories.svg'),
                ),
                activeIcon: Padding(
                  padding: EdgeInsets.only(bottom: 5.h),
                  child: SvgPicture.asset('assets/images/categoriesActive.svg'),
                ),
                label: role == 'driver' ? "السيارات" : "الأقسام"),
            BottomNavigationBarItem(
              icon: Padding(
                padding: EdgeInsets.only(bottom: 5.h),
                child: SvgPicture.asset('assets/images/home.svg'),
              ),
              activeIcon: Padding(
                padding: EdgeInsets.only(bottom: 5.h),
                child: SvgPicture.asset('assets/images/homeActive.svg'),
              ),
              label: "الرئيسية",
            ),
          ],
        ),

        // الزرار اللي في النص
        Positioned(
          bottom: 29, // المسافة من تحت
          child: GestureDetector(
            onTap: () => onTap(2), // عشان لما تدوس عليه يروح للتاب التالت
            child: CircleAvatar(
              backgroundColor: AppColors.primary,
              radius: 30.r,
              child: SvgPicture.asset(
                'assets/images/add.svg',
                height: 24.h,
                width: 24.w,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

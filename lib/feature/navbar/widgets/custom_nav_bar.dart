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
                label: role == 'driver' ? "سيارتي" : "اعلاناتي"),

            // Placeholder (هيفضل فاضي)
            BottomNavigationBarItem(
              icon: SizedBox(
                height: 15.h, // نفس ارتفاع الدائرة
                child: SizedBox(height: 12.h),
              ),
              label: '',
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
            //     label: role == 'driver' ? "السيارات" : "الأقسام"
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
          bottom: 18.h,
          child: GestureDetector(
            onTap: () => onTap(2),
            child: Container(
              width: 60.w,
              height: 60.w,
              decoration: BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 6,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Center(
                child: SvgPicture.asset(
                  'assets/images/add.svg',
                  height: 24.h,
                  width: 24.w,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

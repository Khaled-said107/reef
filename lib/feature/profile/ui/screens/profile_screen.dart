import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:reef/core/constants/app_colors.dart';
import 'package:reef/core/helpers/cach_helper.dart';
import 'package:reef/core/helpers/extensions.dart';
import 'package:reef/core/routing/routes.dart';
import 'package:reef/core/widgets/app_text.dart';
import 'package:reef/core/widgets/custom_button.dart';
import 'package:reef/feature/auth/ui/widgets/text_field_widget.dart';
import 'package:reef/feature/profile/logic/cubit/profile_cubit.dart';
import 'package:reef/feature/profile/ui/screens/update_profile_screen.dart';
import 'package:reef/feature/profile/ui/widgets/posts_manage.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();
    ProfileCubit.get(context).getUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(vertical: 30.h, horizontal: 16.w),
        child: BlocConsumer<ProfileCubit, ProfileState>(
          listener: (context, state) {
            if (state is ProfileError) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text("خطأ: ${state.message}")));
            }
          },
          builder: (context, state) {
            if (state is ProfileLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is ProfileSuccess) {
              var cubit = ProfileCubit.get(context).getUserModel?.data;
              final user = cubit?.user;
              return user != null
                  ? ListView(
                      children: [
                        // صورة البروفايل
                        Center(
                          child: Stack(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: const Color.fromARGB(
                                        255, 206, 206, 206),
                                    width: 1.w,
                                  ),
                                ),
                                child: CircleAvatar(
                                  backgroundColor: AppColors.bgColor,
                                  radius: 60.r,
                                  backgroundImage: user.profilePhoto != null &&
                                          user.profilePhoto!.trim().isNotEmpty
                                      ? NetworkImage(
                                          user.profilePhoto!.startsWith('http')
                                              ? user.profilePhoto!.trim()
                                              : 'http://82.29.172.199:8001${user.profilePhoto!.trim()}',
                                        )
                                      : null,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Gap(10.h),

                        // اسم المستخدم
                        AppText(
                          text: user.name,
                          fontsize: 19.sp,
                          fontWeight: FontWeight.w600,
                          textAlign: TextAlign.center,
                        ),
                        Gap(5.h),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        UpdateProfileScreen()));
                          },
                          child: Column(
                            children: [
                              AppText(
                                text: 'تعديل الملف الشخصي',
                                color: AppColors.primary,
                                fontsize: 10.sp,
                                fontWeight: FontWeight.w600,
                              ),
                              Divider(
                                endIndent: 113.w,
                                indent: 113.w,
                                color: AppColors.primary,
                              )
                            ],
                          ),
                        ),
                        Gap(5.h),
                        // الحقول
                        _profileFields(
                          user.email,
                          user.phone,
                          user.address,
                          user.area,
                        ),
                        Gap(10.h),

                        AppText(
                          text: 'إدارة الإعلانات',
                          fontsize: 15.sp,
                          fontWeight: FontWeight.w500,
                          textAlign: TextAlign.end,
                          color: Color(0xff7c7c7c),
                        ),
                        Gap(10.h),

                        // إدارة البوستات
                        Row(
                          children: [
                            PostsManage(
                              img: 'assets/images/postManage1.png',
                              num: cubit!.postStats.lessThanWeek.toString(),
                              text: 'النشطة',
                            ),
                            Spacer(),
                            PostsManage(
                              img: 'assets/images/postManage2.png',
                              num: cubit.postStats.olderThanWeek.toString(),
                              text: 'المنتهية',
                            ),
                            Spacer(),
                            PostsManage(
                              img: 'assets/images/postManage3.png',
                              num: cubit.postStats.notAccepted.toString(),
                              text: 'قيد المراجعة',
                            ),
                          ],
                        ),
                        Gap(30.h),

                        // الاشتراك
                        user.subscriptionEndDate == null
                            ? SizedBox()
                            : _subscriptionWidget(
                                context,
                                user.subscriptionEndDate ??
                                    'No subscription date'),

                        Gap(25.h),

                        // زر تسجيل الخروج
                        CustomButton(
                          text: 'تسجيل الخروج',
                          onPressed: () async {
                            await CacheHelper.removeData('token');
                            context.pushNamedAndRemoveUntil(
                              Routes.login,
                              predicate: (route) => false,
                            );
                          },
                        ),
                        Gap(5.h),
                      ],
                    )
                  : Center(child: CircularProgressIndicator());
            }

            return const Center(child: Text("لا يوجد بيانات"));
          },
        ),
      ),
    );
  }

  // الحقول اللي بتظهر بيانات المستخدم
  Column _profileFields(
    String email,
    String phone,
    String address,
    String area,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildItem('البريد الإلكتروني', email),
        Gap(10.h),
        buildItem('رقم الهاتف', phone),
        Gap(10.h),
        buildItem('العنوان', address),
        Gap(10.h),
        buildItem('الحي / المنطقة', area),
        Gap(30.h),
      ],
    );
  }

  // ويدجت الاشتراك
  Widget _subscriptionWidget(BuildContext context, String date) {
    return Container(
      padding: EdgeInsets.only(
        right: 10.w,
        left: 20.w,
        top: 15.h,
        bottom: 10.h,
      ),
      height: 70.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: AppColors.primary, width: 1.w),
      ),
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
              onTap: () {
                context.pushNamed(Routes.paymentScreen);
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: const Color(0xff6A994E),
                  borderRadius: BorderRadius.circular(5.r),
                ),
                child: AppText(
                  text: ' تجديد الاشتراك',
                  color: Colors.white,
                  fontsize: 10.sp,
                ),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: ' مشترك حتى ',
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontFamily: 'Tajawal',
                          fontWeight: FontWeight.w500,
                          color: AppColors.black,
                        ),
                      ),
                      TextSpan(
                        text: date.split('T').first,
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontFamily: 'Tajawal',
                          fontWeight: FontWeight.w500,
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                ),
                Gap(3.h),
                InkWell(
                  onTap: () => context.pushNamed(Routes.paymentScreen),
                  child: AppText(
                    text: 'اعرف المزيد عن الأشتراك',
                    fontsize: 10.sp,
                    fontWeight: FontWeight.w800,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget buildItem(String title, String text) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            AppText(
              text: '',
              fontsize: 18.sp,
              color: Colors.red,
            ),
            Gap(5.w),
            AppText(
              text: title,
              fontsize: 15.sp,
            ),
          ],
        ),
        Gap(1.h),
        Container(
          width: double.infinity,
          height: 45,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: Colors.grey,
              width: 1,
            ),
          ),
          child: Center(
              child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(text),
              SizedBox(
                width: 10,
              ),
            ],
          )),
        ),
      ],
    );
  }
}

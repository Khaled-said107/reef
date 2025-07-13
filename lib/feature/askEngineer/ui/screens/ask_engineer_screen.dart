import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:reef/core/constants/app_colors.dart';
import 'package:reef/core/helpers/cach_helper.dart';
import 'package:reef/core/helpers/extensions.dart';
import 'package:reef/core/routing/routes.dart';
import 'package:reef/core/widgets/app_text.dart';
import 'package:reef/feature/askEngineer/data/get_all_ads_model.dart';
import 'package:reef/feature/askEngineer/data/get_enginner_model.dart';
import 'package:reef/feature/askEngineer/ui/widgets/image_view.dart';
import 'package:reef/feature/askEngineer/ui/widgets/post_rich_widget.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../logic/cubit/ask_engineer_cubit.dart';
import '../../logic/cubit/ask_engineer_state.dart';
import '../widgets/Comment_engineer_Widget.dart';

class AskEngineerScreen extends StatefulWidget {
  const AskEngineerScreen({super.key});

  @override
  State<AskEngineerScreen> createState() => _AskEngineerScreenState();
}

class _AskEngineerScreenState extends State<AskEngineerScreen> {
  // bool isLiked = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    ASkEngineerCubit.get(context).getEngineer();
    ASkEngineerCubit.get(context).getAllAds();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ASkEngineerCubit, AskEngineerState>(
      listener: (context, state) {
        if (state is SuccessChangeLikeState) {
          ASkEngineerCubit.get(context).getAllAds();
        }
      },
      builder: (context, state) {
        var users = ASkEngineerCubit.get(context).getEngineerModel?.users;
        var engineer = (users != null && users.isNotEmpty) ? users[0] : null;
        var allAds = ASkEngineerCubit.get(context).getAllAdsModel?.ads;
        return Scaffold(
          body: SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(16.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    _header(),
                    SizedBox(height: 12.h),

                    engineer != null
                        ? _engineerInfo(engineer)
                        : Center(child: CircularProgressIndicator()),

                    SizedBox(height: 16.h),
                    // Buttons
                    engineer != null
                        ? _buttons(context, engineer.phone!, engineer.phone!)
                        : Center(child: CircularProgressIndicator()),

                    SizedBox(height: 20.h),
                    Align(
                      alignment: Alignment.centerRight,
                      child: AppText(
                        text: 'آخر أخبار الزراعة من المهندس',
                        fontWeight: FontWeight.w500,
                        fontsize: 16.sp,
                      ),
                    ),
                    Gap(15.h),

                    allAds != null
                        ? ListView.separated(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemBuilder: (BuildContext context, int index) {
                              return postDetails(allAds[index], state);
                            },
                            separatorBuilder:
                                (BuildContext context, int index) {
                              return Gap(10.h);
                            },
                            itemCount: allAds.length,
                          )
                        : Center(child: CircularProgressIndicator()),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget postDetails(AdModel ad, AskEngineerState state) {
    return StatefulBuilder(
      builder: (context, setLocalState) {
        bool isLiked = ad.likedByCurrentUser;
        var likeCount = ad.likesCount;
        return Container(
          //  height: 325.h,
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 10.w,
                  vertical: 10.h,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        AppText(
                          text: ad.createdAt.split('T').first,
                          fontsize: 12.sp,
                          color: Color(0xFFc7c7c7),
                        ),

                        // InkWell(
                        //   onTap: () {
                        //     showPostOptionsBottomSheet(context);
                        //   },
                        //   child: Icon(Icons.more_vert, size: 18.sp),
                        // ),
                      ],
                    ),
                    Gap(5.h),
                    AppText(
                      text: ad.title,
                      fontsize: 11.sp,
                      fontWeight: FontWeight.w700,
                      textAlign: TextAlign.right,
                    ),
                    Gap(5.h),
                    AppText(
                      text: ad.description,
                      fontsize: 11.sp,
                      textAlign: TextAlign.right,
                      color: Color(0xFF7C7C7C),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ImageViewerScreen(
                        imageUrl: ad.images[0].isNotEmpty
                            ? 'http://82.29.172.199:8001${ad.images[0]}'
                            : '', // هنفحصه في الشاشة نفسها
                      ),
                    ),
                  );
                },
                child: Container(
                  width: double.infinity,
                  height: 150.h,
                  child: Image.network(
                    ad.images[0].isNotEmpty
                        ? 'http://82.29.172.199:8001${ad.images[0]}'
                        : 'http://82.29.172.199:8001/assets/images/default_product_image.png',
                    height: 127.h,
                    width: 123.w,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                        Image.asset('assets/images/default_product_image.png'),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                  right: 10.w,
                  left: 10.w,
                  top: 7.h,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    AppText(
                      text: '${ad.commentsCount} تعليقات',
                      fontsize: 10.sp,
                      color: Color(0xFFc7c7c7),
                    ),
                    AppText(
                      text: ' ${likeCount} إعجاب',
                      fontsize: 10.sp,
                      color: Color(0xFFc7c7c7),
                    ),
                  ],
                ),
              ),
              Divider(
                color: Color(0xFFc7c7c7).withOpacity(0.5),
                thickness: .7.h,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  PostRich(
                    img: 'assets/images/comment.png',
                    text: 'تعليق',
                    onTap: () {
                      showModalBottomSheet(
                        //  isScrollControlled: true,
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.vertical(top: Radius.circular(20)),
                        ),
                        context: context,
                        builder: (context) {
                          return CommentEngineerWidget(
                            adsId: ad.id,
                          );
                        },
                      );
                    },
                  ),
                  state is LoadingChangeLikeState
                      ? SizedBox(
                          width: 20.0,
                          height: 20.0,
                          child: CircularProgressIndicator(
                            color: Colors.green,
                            strokeWidth: 2.0,
                          ),
                        )
                      : PostRich(
                          img: isLiked
                              ? 'assets/images/activeLike.png'
                              : 'assets/images/like.png',
                          text: 'إعجاب',
                          color: isLiked ? Colors.green : Color(0xFFc7c7c7),
                          onTap: () {
                            setLocalState(() {
                              isLiked = !isLiked;
                              likeCount += isLiked ? 1 : -1;
                            });
                            ASkEngineerCubit.get(context)
                                .ChangeLike(adsId: ad.id);
                          },
                        ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Row _engineerInfo(UserModel user) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            AppText(
              text: user.name!,
              fontWeight: FontWeight.w500,
              fontsize: 16.sp,
            ),
            AppText(
              text: ' استشارات زراعية، محاصيل، مكافحة الآفات',
              fontWeight: FontWeight.w500,
              fontsize: 9.sp,
              color: Color(0xFFc7c7c7),
            ),
          ],
        ),
        Gap(12.w),
        CircleAvatar(
          backgroundColor: AppColors.bgColor,
          radius: 30.r,
          backgroundImage:
              user.profilePhoto != null && user.profilePhoto!.trim().isNotEmpty
                  ? NetworkImage(
                      user.profilePhoto!.startsWith('http')
                          ? user.profilePhoto!.trim()
                          : 'http://82.29.172.199:8001${user.profilePhoto!.trim()}',
                    )
                  : null,
        ),
      ],
    );
  }

  Row _header() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Image.asset('assets/images/logo.png', width: 60.w),
        AppText(
          text: 'استشير مهندس زراعي',
          fontWeight: FontWeight.w500,
          fontsize: 16.sp,
        ),
      ],
    );
  }

  Widget _buttons(BuildContext context, String whatsapp, String phone) {
    var role = CacheHelper.getData('role');
    return role == 'engineer'
        ? GestureDetector(
            onTap: () {
              context.pushNamed(Routes.engAddPost);
            },
            child: Container(
              width: double.infinity,
              height: 38.h,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.r),
                color: AppColors.primary,
              ),
              child: Center(
                child: AppText(
                  text: 'إضافة بوست',
                  color: AppColors.white,
                  fontsize: 13.sp,
                ),
              ),
            ),
          )
        : Row(
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
                            text: 'راسل المهندس  ',
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
                            text: 'اتصل بالمهندس',
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

  void showPostOptionsBottomSheet(BuildContext context) {
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
            _buildOptionItem('visable', "إخفاء / إظهار", () {
              Navigator.pop(context);
              // TODO: Add toggle visibility logic
            }),
            _buildOptionItem('edit', "تعديل", () {
              Navigator.pop(context);
              // TODO: Navigate to edit screen
            }),
            _buildOptionItem("delete", "حذف", () {
              Navigator.pop(context);
              // TODO: Confirm and delete
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
      leading: Image.asset(
        'assets/images/$icon.png',
        width: 20.w,
        height: 20.h,
      ),
      title: Text(
        title,
        style: TextStyle(fontWeight: FontWeight.w500, fontFamily: 'tajawal'),
        textAlign: TextAlign.right,
      ),
    );
  }
}

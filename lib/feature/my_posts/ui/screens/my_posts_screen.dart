import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:lottie/lottie.dart';
import 'package:reef/core/constants/app_colors.dart';
import 'package:reef/core/helpers/cach_helper.dart';
import 'package:reef/core/widgets/app_text.dart';
import 'package:reef/feature/my_posts/logic/MyPost_cubit/my_post_cubit.dart';
import 'package:reef/feature/my_posts/ui/screens/detals_MyPosts_screen.dart';
import 'package:reef/feature/my_posts/ui/widgets/post_card_widget.dart';

import '../../../askEngineer/data/get_all_ads_model.dart';
import '../../../askEngineer/logic/cubit/ask_engineer_cubit.dart';
import '../../../askEngineer/logic/cubit/ask_engineer_state.dart';

class MyPostsScreen extends StatefulWidget {
  const MyPostsScreen({super.key});

  @override
  State<MyPostsScreen> createState() => _MyPostsScreenState();
}

class _MyPostsScreenState extends State<MyPostsScreen> {
  @override
  void initState() {
    MyPostCubit.get(context).getMyPosts();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var role = CacheHelper.getData('role');
    return role == 'engineer'
        ? BlocConsumer<ASkEngineerCubit, AskEngineerState>(
            listener: (context, state) {
              if (state is SuccessChangeLikeState) {
                ASkEngineerCubit.get(context).getAllAds();
              }
            },
            builder: (context, state) {
              var users = ASkEngineerCubit.get(context).getEngineerModel?.users;
              var engineer = users?[0];
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
                                  itemBuilder:
                                      (BuildContext context, int index) {
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
          )
        : Scaffold(
            body: BlocConsumer<MyPostCubit, MyPostState>(
            listener: (context, state) {},
            builder: (context, state) {
              if (state is LoadingGetMyPostsState) {
                return CircularProgressIndicator();
              } else if (state is SuccessGetMyPostsState) {
                final cubit = MyPostCubit.get(context).myPostModel;
                var posts = cubit?.posts;
                return SafeArea(
                  child: Padding(
                    padding:
                        EdgeInsets.symmetric(vertical: 7.h, horizontal: 18.w),
                    child: Column(
                      children: [
                        _header(),
                        posts != null
                            ? Expanded(
                                child: ListView.separated(
                                    itemBuilder: (context, index) {
                                      return GestureDetector(
                                        onTap: () {},
                                        child: PostCard(
                                          post: posts[index],
                                        ),
                                      );
                                    },
                                    separatorBuilder: (context, index) {
                                      return Gap(10.h);
                                    },
                                    itemCount: posts.length),
                              )
                            : Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    height: 500,
                                  ),
                                  Center(child: CircularProgressIndicator()),
                                ],
                              )
                      ],
                    ),
                  ),
                );
              } else {
                return Center(
                    child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    LottieBuilder.asset(
                      'assets/images/empty.json',
                      height: 250,
                      width: 250,
                    ),
                    Gap(7.h),
                    AppText(
                      text: 'قائمة اعلانتك فاضيه \nانشر اعلان وهيظهرلك هنا',
                      fontWeight: FontWeight.bold,
                      fontsize: 18,
                      textAlign: TextAlign.center,
                    )
                  ],
                ));
              }
            },
          ));
  }
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
                horizontal: 5.w,
                vertical: 5.h,
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
            Container(
              width: double.infinity,
              height: 150.h,
              child: Image.network(
                ad.images[0].isNotEmpty
                    ? 'http://82.29.172.199:8001${ad.images[0]}'
                    : 'assets/images/default_product_image.png',
                height: 127.h,
                width: 123.w,
                fit: BoxFit.fill,
              ),
            ),
          ],
        ),
      );
    },
  );
}

Padding _header() {
  return Padding(
    padding: EdgeInsets.symmetric(
        // vertical: 3.h,
        horizontal: 8.w),
    child: Row(
      children: [
        Image.asset(
          'assets/images/logo.png',
          height: 60.h,
          width: 60.w,
        ),
        const Spacer(),
        AppText(
          text: "إعلاناتي",
          fontsize: 17.sp,
          fontWeight: FontWeight.w500,
        ),
        Gap(10.w),
      ],
    ),
  );
}

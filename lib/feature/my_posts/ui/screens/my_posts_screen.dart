import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:lottie/lottie.dart';
import 'package:reef/core/constants/app_colors.dart';
import 'package:reef/core/helpers/cach_helper.dart';
import 'package:reef/core/helpers/extensions.dart';
import 'package:reef/core/routing/routes.dart';
import 'package:reef/core/widgets/app_text.dart';
import 'package:reef/feature/askEngineer/ui/screens/update_eng_post_screen.dart';
import 'package:reef/feature/askEngineer/ui/widgets/Comment_engineer_Widget.dart';
import 'package:reef/feature/askEngineer/ui/widgets/image_view.dart';
import 'package:reef/feature/askEngineer/ui/widgets/post_rich_widget.dart';
import 'package:reef/feature/categories/data/post_model.dart';
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
    ASkEngineerCubit.get(context).getEngineer();
    ASkEngineerCubit.get(context).getAllAds();
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
                      InkWell(
                        onTap: () {
                          showPostOptionsBottomSheet(context, ad);
                        },
                        child: Icon(Icons.more_vert, size: 18.sp),
                      ),
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
                  Text(
                    ad.description,
                    style: TextStyle(
                      fontSize: 11.sp,
                      color: Color(0xFF7C7C7C),
                      fontFamily: 'tajawal',
                    ),
                    textAlign: TextAlign.right,
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

void showPostOptionsBottomSheet(BuildContext context, AdModel ad) {
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
                builder: (context) => UpdateEngPostScreen(
                  id: ad.id,
                  title: ad.title,
                  description: ad.description,
                  imageUrl: ad.images.isNotEmpty ? ad.images[0] : null,
                ),
              ),
            ).then((value) {
              if (value == true) {
                // هنا تعمل get للبيانات من جديد
                ASkEngineerCubit.get(context).getAllAds();
              }
            });
          }),
          _buildOptionItem("delete", "حذف", () {
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: Text("تأكيد الحذف"),
                content: Text("هل أنت متأكد من حذف هذا الإعلان؟"),
                actions: [
                  TextButton(
                    child: Text("إلغاء"),
                    onPressed: () => Navigator.pop(context),
                  ),
                  TextButton(
                    child: Text("حذف"),
                    onPressed: () {
                      Navigator.pop(context); // قفل الديالوج
                      ASkEngineerCubit.get(context).deleteAd(ad.id, context);
                    },
                  ),
                ],
              ),
            );
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

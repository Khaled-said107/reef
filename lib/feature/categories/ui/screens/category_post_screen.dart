import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:reef/core/helpers/extensions.dart';
import 'package:reef/core/routing/routes.dart';
import 'package:reef/core/widgets/app_text.dart';
import 'package:reef/feature/categories/data/post_model.dart';
import 'package:reef/feature/categories/logic/cubit/category_cubit.dart';

class CategoryPostScreen extends StatelessWidget {
  const CategoryPostScreen({
    super.key,
    required this.categoryId,
    required this.categoryName,
  });

  final String categoryId;
  final String categoryName;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CategoryCubit()..getPostsByCategory(categoryId),
      child: SafeArea(
        child: Scaffold(
          body: Column(
            children: [
              _header(context),
              Expanded(
                child: BlocBuilder<CategoryCubit, CategoryState>(
                  builder: (context, state) {
                    if (state is CategoryPostsLoading) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (state is CategoryPostsSuccess) {
                      return ListView.separated(
                        padding: EdgeInsets.all(16.w),
                        itemBuilder: (context, index) {
                          final post = state.posts[index];
                          return GestureDetector(
                              onTap: () {
                                context.pushNamed(
                                  Routes.product,
                                  arguments: post.id, // نعدي ID فقط مش الموديل
                                );
                              },
                              child: _subCategoryCard(context, post));
                        },
                        separatorBuilder: (context, index) => Gap(10.h),
                        itemCount: state.posts.length,
                      );
                    } else if (state is CategoryError) {
                      return Center(
                        child: AppText(
                          text: state.error,
                          fontsize: 14.sp,
                          color: Colors.red,
                        ),
                      );
                    } else {
                      return const Center(child: Text('No posts available'));
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Padding _header(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 7.h, horizontal: 15.w),
      child: Row(
        children: [
          Image.asset('assets/images/logo.png', height: 60.h, width: 60.w),
          const Spacer(),
          GestureDetector(
            onTap: () {
              context.pop();
            },
            child: Row(
              children: [
                AppText(
                  text: categoryName,
                  fontsize: 17.sp,
                  fontWeight: FontWeight.w500,
                ),
                Gap(10.w),
                SvgPicture.asset('assets/images/backIcon.svg'),
                Gap(10.w),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _subCategoryCard(BuildContext context, PostModel post) {
    return Container(
      height: 115.h,
      decoration: BoxDecoration(
        color: const Color(0xffFFFEF8),
        border: Border.all(color: const Color(0xffEFEAD8)),
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Row(
          children: [
            _itemImage(post.images.first),
            _itemContent(post, context),
          ],
        ),
      ),
    );
  }

  Widget _itemImage(String imageUrl) {
    return ClipRRect(
      borderRadius: BorderRadius.only(
        topRight: Radius.circular(10.r),
        bottomRight: Radius.circular(10.r),
      ),
      child: Image.network(
        'http://82.29.172.199:8001$imageUrl',
        height: 127.h,
        width: 123.w,
        fit: BoxFit.fill,
      ),
    );
  }

  Widget _itemContent(PostModel post, BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Padding(
            padding: EdgeInsetsDirectional.fromSTEB(8.w, 12.h, 12.w, 12.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    AppText(
                      text: post.name!,
                      fontsize: 13.sp,
                      fontWeight: FontWeight.w500,
                      maxWords: 3,
                    ),
                    AppText(
                      text: '${post.price} جنيه',
                      fontsize: 13.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ],
                ),
                Gap(6.h),

                // وصف
                AppText(
                  text: post.description!.isNotEmpty
                      ? post.description!
                      : 'لا يوجد وصف متاح',
                  fontsize: 8.sp,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xff7c7c7c),
                  maxLines: 1,
                ),
                Gap(20.h),

                // عنوان
                AppText(
                  text: 'العنوان: ${post.address ?? 'غير محدد'}',
                  fontsize: 8.sp,
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
            child: Row(
              children: [
                AppText(
                  text: '${post.userName}',
                  fontsize: 8.sp,
                  color: const Color(0xff7c7c7c),
                  maxWords: 3,
                ),

                const Spacer(),
                AppText(
                  text: '${post.createdAt!.split('T').first}',
                  fontsize: 7.sp,
                  color: const Color(0xff7c7c7c),
                ),
                // InkWell(
                //   onTap: () {
                //     // Navigate to post details screen
                //     context.pushNamed(Routes.product, arguments: post);
                //   },
                //   child: Container(
                //     padding: EdgeInsets.symmetric(
                //       horizontal: 8.w,
                //       vertical: 4.h,
                //     ),
                //     decoration: BoxDecoration(
                //       color: const Color(0xff6A994E),
                //       borderRadius: BorderRadius.circular(5.r),
                //     ),
                //     child: AppText(
                //       text: 'عرض التفاصيل',
                //       color: Colors.white,
                //       fontsize: 7.sp,
                //     ),
                //   ),
                // ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:reef/core/helpers/extensions.dart';
import 'package:reef/core/widgets/app_text.dart';

import '../../../product/ui/screens/product_screen.dart';
import '../../data/get_all_posts_model.dart';
import '../../logic/cubit/get_all_posts_cubit/get_all_posts_cubit.dart';
import '../../logic/cubit/get_all_posts_cubit/get_all_posts_state.dart';

class SubCategoryScreen extends StatefulWidget {
  final String name;
  final String subCategoryId;
  const SubCategoryScreen(
      {super.key, required this.name, required this.subCategoryId});

  @override
  State<SubCategoryScreen> createState() => _SubCategoryScreenState();
}

class _SubCategoryScreenState extends State<SubCategoryScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    GetAllPostsCubit.get(context).getAllPost(widget.subCategoryId);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<GetAllPostsCubit, GetAllPostsState>(
      listener: (context, state) {},
      builder: (context, state) {
        var posts = GetAllPostsCubit.get(context).getAllPostModel?.posts;
        return SafeArea(
          child: Scaffold(
            body: Column(
              children: [
                _header(context),
                posts!.isEmpty
                    ? Center(
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.w),
                          child: Container(
                            height: 100.h,
                            width: double.infinity,
                            alignment: Alignment.center,
                            child: AppText(
                              text:
                                  'لم يعرض أحد منتجات للبيع في هذا الصنف حتى الآن',
                            ),
                          ),
                        ),
                      )
                    : state is SinglePostSuccess
                        ? Expanded(
                            child: ListView.separated(
                              padding: EdgeInsets.all(16.w),
                              itemBuilder: (context, index) =>
                                  _subCategoryCard(context, posts[index]),
                              separatorBuilder: (context, index) => Gap(10.h),
                              itemCount: posts!.length,
                            ),
                          )
                        : Center(
                            child: CircularProgressIndicator(),
                          ),
              ],
            ),
          ),
        );
      },
    );
  }

  Padding _header(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: 7.h,
        horizontal: 15.w,
      ),
      child: Row(
        children: [
          Image.asset(
            'assets/images/logo.png',
            height: 60.h,
            width: 60.w,
          ),
          const Spacer(),
          GestureDetector(
            onTap: () {
              context.pop();
            },
            child: Row(
              children: [
                AppText(
                  text: '${widget.name}',
                  fontsize: 17.sp,
                  fontWeight: FontWeight.w500,
                ),
                Gap(10.w),
                SvgPicture.asset('assets/images/backIcon.svg'),
              ],
            ),
          ),
          Gap(10.w),
        ],
      ),
    );
  }

  Widget _subCategoryCard(BuildContext context, PostModel post) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ProductScreen(
                      postId: post.id!,
                    )));
      },
      child: Container(
        height: 127.h,
        decoration: BoxDecoration(
          color: const Color(0xffFFFEF8),
          border: Border.all(color: const Color(0xffEFEAD8)),
          borderRadius: BorderRadius.circular(10.r),
        ),
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: Row(
            children: [
              _itemImage(post.images[0]),
              _itemContent(post),
            ],
          ),
        ),
      ),
    );
  }

  Widget _itemImage(String image) {
    return ClipRRect(
      borderRadius: BorderRadius.only(
        topRight: Radius.circular(10.r),
        bottomRight: Radius.circular(10.r),
      ),
      child: Image.network(
        image.isNotEmpty
            ? 'http://82.29.172.199:8001${image}'
            : 'assets/images/default_product_image.png',
        height: 127.h,
        width: 123.w,
        fit: BoxFit.fill,
      ),
    );
  }

  Widget _itemContent(PostModel post) {
    return Expanded(
      child: Column(
        children: [
          Padding(
            padding: EdgeInsetsDirectional.fromSTEB(8.w, 12.h, 12.w, 12.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // اسم وسعر
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    AppText(
                      text: post.name!,
                      fontsize: 11.sp,
                      fontWeight: FontWeight.w500,
                    ),
                    AppText(
                      text: post.price.toString(),
                      fontsize: 13.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ],
                ),
                Gap(6.h),

                // وصف
                AppText(
                  text: post.description!,
                  fontsize: 7.sp,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xff7c7c7c),
                ),
                Gap(20.h),

                // عنوان
                AppText(
                  text: post.address!,
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
            child: Row(
              children: [
                AppText(
                  text: '${post.user?.name} - منذ ٧ أيام',
                  fontsize: 6.sp,
                  color: const Color(0xff7c7c7c),
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
          ),
        ],
      ),
    );
  }
}

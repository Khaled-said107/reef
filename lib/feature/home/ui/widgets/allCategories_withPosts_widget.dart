import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:reef/core/constants/app_colors.dart';
import 'package:reef/core/helpers/extensions.dart';
import 'package:reef/core/routing/routes.dart';
import 'package:reef/core/widgets/app_text.dart';
import 'package:reef/feature/categories/logic/cubit/category_cubit.dart';
import 'package:reef/feature/home/ui/widgets/category_title.dart';
import 'package:reef/feature/home/ui/widgets/sub_cartegory_card.dart';
import 'package:reef/feature/categories/data/post_model.dart';

class AllCategoriesWithPostsWidget extends StatefulWidget {
  const AllCategoriesWithPostsWidget({super.key, this.onBackFromDetails});
  final VoidCallback? onBackFromDetails;

  @override
  State<AllCategoriesWithPostsWidget> createState() =>
      _AllCategoriesWithPostsWidgetState();
}

class _AllCategoriesWithPostsWidgetState
    extends State<AllCategoriesWithPostsWidget> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CategoryCubit, CategoryState>(
      builder: (context, state) {
        if (state is CategoryLoading || state is CategoryWithPostsLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is CategoryCombinedSuccess) {
          final categoriesWithPosts = state.categoriesWithPosts;

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: categoriesWithPosts.map((category) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Gap(20.h),
                    CategoryTitle(
                      text: category.name,
                      ontap: () {
                        context.pushNamed(
                          '/categoryPostScreen',
                          arguments: {
                            'categoryId': category.id,
                            'categoryName': category.name,
                          },
                        );
                      },
                    ),
                    category.posts.isEmpty
                        ? Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16.w),
                            child: Container(
                              height: 100.h,
                              width: double.infinity,
                              alignment: Alignment.center,
                              child: AppText(
                                color: AppColors.textGrey,
                                text:
                                    'لم يعرض أحد منتجات للبيع في هذا الصنف حتى الآن',
                              ),
                            ),
                          )
                        : SizedBox(
                            height: 170.h,
                            width: double.infinity,
                            child: Directionality(
                              textDirection: TextDirection.rtl,
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 7.w),
                                child: ListView.separated(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: category.posts.length,
                                  separatorBuilder: (_, __) =>
                                      SizedBox(width: 10.w),
                                  itemBuilder: (context, index) {
                                    final post = category.posts[index];
                                    final userName =
                                        post.user.name ?? 'مستخدم غير معروف';
                                    print(
                                      '✅ POST RAW JSON: ${category.posts[index]}',
                                    );
                                    return SubCategorycard(
                                      image: post.images.isNotEmpty
                                          ? 'http://82.29.172.199:8001${post.images.first}'
                                          : 'https://via.placeholder.com/150',
                                      price: post.price != null
                                          ? '${post.price} EGP'
                                          : '',
                                      title: post.name ?? '',
                                      name: userName ?? '',
                                      date: post.createdAt?.split('T').first ??
                                          '',
                                      address: post.address ?? '',
                                      desc: post.description ?? '',
                                      onTap: () async {
                                        context.pushNamed(
                                          Routes.product,
                                          arguments:
                                              post.id, // نعدي ID فقط مش الموديل
                                        );
                                        widget.onBackFromDetails?.call();
                                      },
                                    );
                                  },
                                ),
                              ),
                            ),
                          ),
                    const SizedBox(height: 20),
                  ],
                );
              }).toList(),
            ),
          );
        } else if (state is CategoryError || state is CategoryWithPostsError) {
          return Center(
            child: Text(
              "حصل خطأ: ${state is CategoryError ? state.error : (state as CategoryWithPostsError).error}",
            ),
          );
        }

        return const SizedBox.shrink();
      },
    );
  }
}

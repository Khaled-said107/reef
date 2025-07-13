import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:reef/core/constants/app_colors.dart';
import 'package:reef/core/helpers/extensions.dart';
import 'package:reef/core/routing/routes.dart';
import 'package:reef/core/widgets/app_text.dart';
import 'package:reef/feature/categories/data/category_model.dart';
import 'package:reef/feature/categories/logic/cubit/category_cubit.dart';

class CategoyWidget extends StatefulWidget {
  const CategoyWidget({super.key});

  @override
  State<CategoyWidget> createState() => _CategoyWidgetState();
}

class _CategoyWidgetState extends State<CategoyWidget> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.watch<CategoryCubit>();
    return Container(
      margin: EdgeInsets.only(left: 30.w, right: 15.w, top: 10.h),
      height: 150.h,
      child: BlocConsumer<CategoryCubit, CategoryState>(
        listener: (context, state) {
          if (state is CategoryError) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.error)));
          }
        },
        builder: (context, state) {
          if (state is CategoryLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (state is CategoryCombinedSuccess) {
            final categories = state.categories;
            return Directionality(
              textDirection: TextDirection.rtl,
              child: categories.length <= 4
                  ? LayoutBuilder(
                      builder: (context, constraints) {
                        double totalWidth = categories.length * 60.w +
                            (categories.length - 1) * 25.w;
                        return Align(
                          alignment: Alignment.center,
                          child: SizedBox(
                            width: totalWidth,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children:
                                  List.generate(categories.length, (index) {
                                return _buildCategoryItem(categories[index]);
                              }),
                            ),
                          ),
                        );
                      },
                    )
                  : Center(
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: categories.length,
                        itemBuilder: (context, index) {
                          return _buildCategoryItem(categories[index]);
                        },
                        separatorBuilder: (BuildContext context, int index) {
                          return Gap(25.w);
                        },
                      ),
                    ),
            );
          }
          return Center(
            child: AppText(
              text: 'لا توجد فئات متاحة',
              color: AppColors.black,
              fontsize: 16.sp,
              fontWeight: FontWeight.w500,
            ),
          );
        },
      ),
    );
  }

  Widget _buildCategoryItem(CategoryModel category) {
    return Row(
      children: [
        Gap(15.w),
        GestureDetector(
          onTap: () {
            context.pushNamed(Routes.categories);
          },
          child: Stack(
            children: [
              Container(
                margin: EdgeInsets.only(top: 45.w),
                padding: EdgeInsets.only(top: 35.h),
                decoration: BoxDecoration(
                  color: Color(0xFFEFEAD8),
                  borderRadius: BorderRadius.circular(10.r),
                ),
                height: 75.h,
                width: 60.w,
                child: Center(
                  child: AppText(
                    textAlign: TextAlign.center,
                    text: category.name,
                    color: AppColors.black,
                    fontWeight: FontWeight.w500,
                    fontsize: 12.sp,
                  ),
                ),
              ),
              Positioned(
                top: 10.h,
                child: CircleAvatar(
                  radius: 30.r,
                  backgroundImage: NetworkImage(
                    'http://82.29.172.199:8001${category.image}',
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

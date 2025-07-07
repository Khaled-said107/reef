import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:reef/core/helpers/extensions.dart';
import 'package:reef/core/routing/routes.dart';
import 'package:reef/core/widgets/app_text.dart';
import 'package:reef/feature/categories/logic/cubit/category_cubit.dart';
import 'package:reef/feature/categories/ui/screens/sub_category_screen.dart';

List<String> categoriesList = [
  "مواشي وحيوانات",
  "محاصيل زراعية",
  "مستلزمات الزراعة",
  "منتجات ريفية",
  "منتجات عضوية",
  "معدات وأدوات",
];

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key});

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  int? isExpandedIndex;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(children: [Gap(20.h), _header(), _category_item()]),
      ),
    );
  }

  Expanded _category_item() {
    return Expanded(
      child: Container(
        height: double.infinity,
        child: BlocBuilder<CategoryCubit, CategoryState>(
          builder: (context, state) {
            final cubit = context.read<CategoryCubit>();
            final categories = cubit.categories;
            return ListView.separated(
              itemBuilder: (context, index) {
                final category = categories[index];
                bool isExpanded = isExpandedIndex == index;
                final subCats = cubit.subCategoriesMap[category.id] ?? [];
                return Column(
                  children: [
                    InkWell(
                      onTap: () {
                        setState(() {
                          if (isExpanded) {
                            isExpandedIndex = null;
                          } else {
                            isExpandedIndex = index;
                            print('🔵 Pressed categoryId: ${category.id}');
                            if (!cubit.subCategoriesMap.containsKey(
                              category.id,
                            )) {
                              cubit.getSubCategories(category.id);
                            }
                          }
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.r),
                          color: Color(0xFFE1EADB),
                        ),
                        margin: EdgeInsets.symmetric(
                          vertical: 7.h,
                          horizontal: 15.w,
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 20.w),
                        height: 70.h,
                        width: double.infinity,
                        child: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              isExpandedIndex == index
                                  ? SvgPicture.asset('assets/images/dropUp.svg')
                                  : SvgPicture.asset(
                                    'assets/images/dropdown.svg',
                                  ),
                              AppText(
                                fontsize: 16.sp,
                                fontWeight: FontWeight.w500,
                                text: category.name,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    if (isExpanded)
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 15.w,
                          vertical: 15.h,
                        ),
                        child:
                            state is SubCategoriesLoading
                                ? Center(child: CircularProgressIndicator())
                                : SizedBox(
                                  height: (subCats.length*50).h,
                                  child: ListView.separated(
                                    itemBuilder: (context, index) {
                                      final subCategory = subCats[index];
                                      return InkWell(
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context)=>SubCategoryScreen(
                                                    name: subCategory.name,
                                                    subCategoryId: subCategory.id
                                                  )
                                              ));
                                          // context.pushNamed(
                                          //   Routes.subCategories,
                                          // );
                                        },
                                        child: AppText(
                                          textAlign: TextAlign.end,
                                          text: subCategory.name,
                                        ),
                                      );
                                    },
                                    separatorBuilder: (context, index) {
                                      return Padding(
                                        padding: EdgeInsets.symmetric(
                                          vertical: 7.h,
                                        ),
                                        child: Divider(
                                          color: Color(0xffEFEAD8),
                                        ),
                                      );
                                    },
                                    itemCount: subCats.length,
                                  ),
                                ),
                      ),
                  ],
                );
              },
              separatorBuilder: (context, index) {
                return Gap(3.h);
              },
              itemCount: categories.length,
            );
          },
        ),
      ),
    );
  }

  Padding _header() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 7.h, horizontal: 15.w),
      child: Row(
        children: [
          Image.asset('assets/images/logo.png', height: 60.h, width: 60.w),
          const Spacer(),
          AppText(
            text: "الاقسام",
            fontsize: 17.sp,
            fontWeight: FontWeight.w500,
          ),
          Gap(10.w),
          // SvgPicture.asset('assets/images/backIcon.svg'),
        ],
      ),
    );
  }
}

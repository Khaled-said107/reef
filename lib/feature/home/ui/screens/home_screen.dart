import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:reef/core/constants/app_colors.dart';
import 'package:reef/core/helpers/cach_helper.dart';
import 'package:reef/core/helpers/extensions.dart';
import 'package:reef/core/routing/routes.dart';
import 'package:reef/core/widgets/app_text.dart';
import 'package:reef/feature/categories/logic/cubit/category_cubit.dart';
import 'package:reef/feature/home/ui/widgets/allCategories_withPosts_widget.dart';
import 'package:reef/feature/home/ui/widgets/category_title.dart';
import 'package:reef/feature/home/ui/widgets/category_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

TextEditingController _searchController = TextEditingController();
bool isSearching = false;
final address = CacheHelper.getData('address');

class _HomeScreenState extends State<HomeScreen> {
  var role = CacheHelper.getData('role');
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final cubit = CategoryCubit.get(context);
      cubit.getCategories();
      cubit.fetchCategoriesWithPosts();
      _showAlertOnce();
    });
  }

  Future<void> _showAlertOnce() async {
    final prefs = await SharedPreferences.getInstance();
    final shown = prefs.getBool('ShowOnce') ?? false;

    if (!shown) {
      final role = CacheHelper.getData('role');

      if (role == 'user') {
        await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Row(
              children: [
                InkWell(
                  onTap: () => context.pop(),
                  child: AppText(
                    text: 'x',
                    fontsize: 28.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const Spacer(),
                Image.asset(
                  'assets/images/logo.png',
                  width: 50.w,
                  height: 50.h,
                ),
              ],
            ),
            content: AppText(
              fontsize: 12.sp,
              fontWeight: FontWeight.w500,
              textAlign: TextAlign.center,
              maxLines: 5,
              text:
                  'تهانينا! بصفتك من أول ٢٥٠ عميل على تطبيق ريف، عندك فرصة تحصل على ٣ شهور اشتراك مجانًا! كل اللي عليك تنشر إعلان وترفع صورتين بس، الحق مكانك!',
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.r),
            ),
            backgroundColor: const Color(0xFFF0F4ED),
            actions: [
              Center(
                child: InkWell(
                  onTap: () {
                    context.pop();
                    context.pushNamed(Routes.createPost);
                  },
                  child: Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
                    decoration: BoxDecoration(
                      color: const Color(0xff6A994E),
                      borderRadius: BorderRadius.circular(5.r),
                    ),
                    child: AppText(
                      text: 'انشر إعلانك الآن',
                      color: Colors.white,
                      fontsize: 12.sp,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      } else if (role == 'driver') {
        await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            backgroundColor: const Color(0xFFF0F4ED),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.r),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.directions_car, size: 60, color: Colors.grey),
                SizedBox(height: 10.h),
                AppText(
                  text: "🚗 لسه ما ضفتش عربية",
                  fontsize: 16.sp,
                  fontWeight: FontWeight.bold,
                ),
                SizedBox(height: 10.h),
                AppText(
                  text: "ضيف عربية عشان تبدأ شغلك 💪",
                  fontsize: 12.sp,
                  color: Colors.grey,
                ),
                SizedBox(height: 20.h),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                  ),
                  onPressed: () {
                    context.pop();
                    context.pushNamed(Routes.addCar);
                  },
                  child: AppText(
                    text: "ضيف عربية",
                    color: Colors.white,
                    fontsize: 12.sp,
                  ),
                ),
              ],
            ),
          ),
        );
      }

      // Mark it as shown
      await prefs.setBool('ShowOnce', true);
    }
  }

  @override
  void dispose() {
    // _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var role = CacheHelper.getData('role');
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 10.h),
          child: ListView(
            children: [
              _header(address),
              _search_bar(),
              if (!isSearching) ...[
                Gap(40.h),
                CategoryTitle(
                  text: 'كل ما تحتاجه من ريف',
                  ontap: () {
                    context.pushNamed(Routes.categories);
                  },
                ),
                CategoyWidget(),
                Gap(15.h),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 20.h),
                  color: const Color(0xffEFEAD8),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Spacer(),
                          AppText(
                            text: 'خدمات ريف',
                            color: AppColors.black,
                            fontWeight: FontWeight.w500,
                            fontsize: 18.sp,
                          ),
                          Gap(10.h),
                          Image.asset('assets/images/mark.png',
                              width: 25.w, height: 25.h),
                        ],
                      ),
                      Gap(10.h),
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 15.w),
                        height: 140.h,
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius: BorderRadius.circular(5.r),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 1,
                              child: Container(
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(5.r),
                                          bottomLeft: Radius.circular(5.r)),
                                      image: DecorationImage(
                                          image: AssetImage(
                                            'assets/images/engCard.jpg',
                                          ),
                                          fit: BoxFit.cover))),
                            ),
                            Expanded(
                              flex: 1,
                              child: GestureDetector(
                                onTap: () {
                                  context
                                      .pushNamed(role == 'engineer'
                                          ? Routes.engAddPost
                                          : Routes.askEngineerScreen)
                                      .then((_) {
                                    setState(() {
                                      _searchController.clear();
                                      isSearching = false;
                                    });
                                  });
                                  ;
                                },
                                child: Padding(
                                  padding: EdgeInsets.only(
                                    right: 12.w,
                                    left: 10.w,
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      AppText(
                                        text: role == 'engineer'
                                            ? 'مهندس زراعي'
                                            : 'استشر مهندس زراعي',
                                        fontsize: 15.sp,
                                        textAlign: TextAlign.end,
                                        fontWeight: FontWeight.w500,
                                      ),
                                      Gap(5.h),
                                      Flexible(
                                        child: AppText(
                                          text: role == 'engineer'
                                              ? 'اختصر وقتك.. تحكم في خدماتك وأضف بوست جديد '
                                              : 'نصايح زراعية يومية من مهندس \nمتخصص اسأله وتفاعل مع محتواه بسهولة',
                                          fontsize: 7.sp,
                                          textAlign: TextAlign.end,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      Gap(20.h),
                                      Container(
                                        padding: EdgeInsets.only(left: 4),
                                        width: 139.w,
                                        height: 24.h,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                            8.r,
                                          ),
                                          color: AppColors.primary,
                                        ),
                                        child: Center(
                                          child: AppText(
                                            text: role == 'engineer'
                                                ? 'اضافة بوست'
                                                : 'ابدأ الآن',
                                            color: AppColors.white,
                                            fontsize: 10.sp,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 20.h,
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 15.w),
                        height: 140.h,
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius: BorderRadius.circular(5.r),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 1,
                              child: Container(
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(5.r),
                                          bottomLeft: Radius.circular(5.r)),
                                      image: DecorationImage(
                                          image: AssetImage(
                                            'assets/images/driverCard.jpg',
                                          ),
                                          fit: BoxFit.cover))),
                            ),
                            Expanded(
                              flex: 1,
                              child: GestureDetector(
                                onTap: () {
                                  context
                                      .pushNamed(role == "driver"
                                          ? Routes.addCar
                                          : Routes.trucksScreen)
                                      .then((_) {
                                    setState(() {
                                      _searchController.clear();
                                      isSearching = false;
                                    });
                                  });
                                  ;
                                },
                                child: Padding(
                                  padding: EdgeInsets.only(
                                    right: 12.w,
                                    left: 10.w,
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      AppText(
                                        text: 'عربيات ريف للنقل',
                                        fontsize: 15.sp,
                                        textAlign: TextAlign.start,
                                        fontWeight: FontWeight.w500,
                                      ),
                                      Gap(5.h),
                                      Flexible(
                                        child: AppText(
                                          text:
                                              'انشر تفاصيل عربيتك وخلي العملاء \n يتواصلوا معاك بسهولة',
                                          fontsize: 7.sp,
                                          textAlign: TextAlign.end,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      Gap(20.h),
                                      Container(
                                        width: 139.w,
                                        height: 24.h,
                                        margin: EdgeInsets.only(left: 4.w),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(8.r),
                                          color: AppColors.primary,
                                        ),
                                        child: Center(
                                          child: AppText(
                                            text: role == 'driver'
                                                ? 'اضافة بوست'
                                                : 'ابدأ الآن',
                                            color: AppColors.white,
                                            fontsize: 10.sp,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
              AllCategoriesWithPostsWidget(
                onBackFromDetails: () {
                  setState(() {
                    _searchController.clear();
                    isSearching = false;
                  });
                  final cubit = CategoryCubit.get(context);
                  if (cubit.categories.isEmpty) cubit.getCategories();
                  if (cubit.categoriesWithPosts.isEmpty)
                    cubit.fetchCategoriesWithPosts();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Padding _search_bar() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15.w),
      child: Stack(
        children: [
          Container(
            height: 35.h,
            child: TextField(
              textAlign: TextAlign.right,
              textDirection: TextDirection.rtl,
              controller: _searchController,
              onChanged: (value) {
                context.read<CategoryCubit>().searchPosts(value);
                setState(() {
                  isSearching = value.trim().isNotEmpty;
                });
              },
              style: TextStyle(
                fontSize: 14.sp,
                fontFamily: 'Tajawal',
                fontWeight: FontWeight.w400,
              ),
              decoration: InputDecoration(
                hintTextDirection: TextDirection.rtl,
                contentPadding: EdgeInsets.symmetric(horizontal: 10.w),
                hintText: 'اكتب اسم المنتج اللي بتدور عليه ',
                suffixIcon: Padding(
                  padding: EdgeInsets.only(right: 15.w),
                  child: Image.asset(
                    'assets/images/search.png',
                    width: 30.w,
                    height: 30.h,
                  ),
                ),
                suffixIconConstraints: BoxConstraints(
                  maxHeight: 30.h,
                  maxWidth: 30.w,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5.r),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Color(0xFFEFEAD8),
                hintStyle: TextStyle(
                  color: Color(0xFFB7B7B7),
                  fontSize: 14.sp,
                  fontFamily: 'Tajawal',
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Padding _header(String? address) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15.w),
      child: Row(
        children: [
          Image.asset('assets/images/logo.png', width: 55.w, height: 55.h),
          Spacer(),
          AppText(
            text: address ?? 'مصر',
            textAlign: TextAlign.right,
            fontsize: 12.sp,
          ),
          Gap(3.w),
          Image.asset('assets/images/map.png', width: 15.w, height: 15.h),
        ],
      ),
    );
  }
}

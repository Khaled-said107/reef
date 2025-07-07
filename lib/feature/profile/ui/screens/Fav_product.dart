import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:reef/core/constants/app_colors.dart';
import '../../../../core/widgets/app_text.dart';
import '../widgets/FavWidget.dart';

class FavProduct extends StatefulWidget {
  const FavProduct({super.key});

  @override
  State<FavProduct> createState() => _FavProductState();
}

class _FavProductState extends State<FavProduct> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3, // عدد التابات
      child: Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              SizedBox(height: 10.h),

              /// App Bar
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      child: AppText(
                        text: 'حذف الكل ',
                        color: AppColors.primary,
                      ),
                      onTap: () {
                        // TODO: Add delete all action
                      },
                    ),
                    Row(
                      children: [
                        AppText(text: "المفضلة"),
                        Gap(10.w),
                        Icon(Icons.navigate_next),
                      ],
                    ),
                  ],
                ),
              ),

              SizedBox(height: 20.h),

              /// TabBar
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                ),
                child: TabBar(
                  labelColor: AppColors.primary,
                  unselectedLabelColor: Colors.grey,
                  indicatorColor: AppColors.primary,
                  indicatorWeight: 2.5,
                  labelStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 15.sp),
                  tabs: const [
                    Tab(text: "الإعلانات"),
                    Tab(text: "العربيات"),
                    Tab(text: "البوستات"),
                  ],
                ),
              ),

              /// TabBarView
              Expanded(
                child: TabBarView(
                  children: [

                    Center(
                      child:ListView.separated(itemBuilder: (context, index) =>Favwidget(),
                          separatorBuilder: (context, index) => Gap(15.h),
                          itemCount: 10)
                    ),
                    Center(child:Text('cars') ),

                     Center(child: Text('adds')),

                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

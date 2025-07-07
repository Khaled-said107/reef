import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:reef/core/constants/app_colors.dart';
import 'package:reef/core/widgets/app_text.dart';
import 'package:reef/core/widgets/header.dart';
import 'package:reef/feature/truck/ui/widget/PostCard.dart';

import '../../logic/dreiver_cubit.dart';
import '../../logic/dreiver_state.dart';

class TrucksScreen extends StatefulWidget {
  const TrucksScreen({super.key});

  @override
  State<TrucksScreen> createState() => _TrucksScreenState();
}

class _TrucksScreenState extends State<TrucksScreen> {
  String? selectedGovernorate;
  String? selectedAddress;
  String? selectedCar;
  String? selectedWight;
  String? selectedDriver;
  String? selectedDiliveryType;
  TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _initData(); // نادى على ميثود تانية
  }

  void _initData() async {
    final cubit = DriverCubit.get(context);
    await cubit.fetchDeliveryData(); // استنى لحد ما تخلص
    cubit.featchDrivers(); // بعدين نفذ دي
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocConsumer<DriverCubit, DriverState>(
          listener: (context, state) {
            if (state is DriverError) {}
          },
          builder: (context, state) {
            // var cubit = DriverCubit.get(context).driverModel;
            // var drivers = cubit!.drivers;

            //  final drivers = cubit.;
            if (state is DriverLoading) {
              return Center(child: CircularProgressIndicator());
            } else if (state is DriverError) {
              return Center(
                  child: AppText(
                text: state.message == 'Post is not accepted'
                    ? 'لم يتم قبول هذا المنشور من قبل المسؤولين'
                    : state.message ==
                            'Your subscription has expired. Please renew to continue.'
                        ? 'يجب الاشتراك في التطبيق من صفحة الملف الشخصي'
                        : 'حدث خط ${state.message}',
              ));
            } else if (state is DriverSuccess) {
              var drivers = state.drivers?.drivers ?? [];
              return SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 10.w,
                    vertical: 5.h,
                  ),
                  child: Column(
                    children: [
                      header(name: 'عربيات النقل', icon: Icons.navigate_next),
                      Gap(10.h),
                      _search_bar(context),
                      Gap(10.h),
                      ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        padding: EdgeInsets.symmetric(vertical: 10.h),
                        itemBuilder: (context, index) {
                          // final driver = cubit;
                          return PostCard(
                            drivers: drivers[index],
                            onBackFromDetails: () {
                              print("رجعت من صفحة التفاصيل");
                              final cubit = DriverCubit.get(context);
                              selectedGovernorate = null;
                              selectedAddress = null;
                              selectedCar = null;
                              selectedWight = null;
                              selectedDriver = null;
                              selectedDiliveryType = null;

                              _searchController.clear(); // امسح السيرش
                              cubit
                                  .featchDrivers(); // رجّع كل الداتا من غير فلترة
                              setState(() {});
                            },
                          );
                        },
                        separatorBuilder: (context, index) => Gap(10.h),
                        itemCount: drivers.length,
                      ),
                    ],
                  ),
                ),
              );
            } else {
              return Center(child: Text(''));
            }
          },
        ),
      ),
    );
  }

  Stack _search_bar(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: 35.h,
          child: TextField(
            onChanged: (value) {
              context.read<DriverCubit>().searchDrivers(value);
            },
            controller: _searchController,
            textAlign: TextAlign.right,
            textDirection: TextDirection.rtl,
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
        Container(
          height: 35.h,
          width: 38.w,
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(5.r),
          ),
          child: IconButton(
            onPressed: () {
              showPostOptionsBottomSheet(context);
            },
            icon: Image.asset(
              'assets/images/filter.png',
              width: 20.w,
              height: 20.h,
            ),
          ),
        ),
      ],
    );
  }

  Widget _dropDown({
    required String? value,
    required void Function(String?) onChanged,
    required String hint,
    required List<DropdownMenuItem<String>> items,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15.w),
      height: 40.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.r),
        color: const Color(0xffF3EFE1),
      ),
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: DropdownButton<String>(
          isExpanded: true,
          value: value,
          icon: SvgPicture.asset('assets/images/dropdown.svg'),
          underline: const SizedBox(),
          hint: AppText(text: hint, fontsize: 12.sp, color: Color(0xff7c7c7c)),
          items: items,
          onChanged: onChanged,
        ),
      ),
    );
  }

  void showPostOptionsBottomSheet(BuildContext context) {
    final cubit = DriverCubit.get(context);
    final deliveryData = cubit.deliveryData;

    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      backgroundColor: Colors.white,
      builder: (_) {
        if (deliveryData == null) {
          return const Center(child: Text("لا توجد بيانات"));
        }

        return StatefulBuilder(
          builder: (BuildContext context, setState) {
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 40.w,
                    height: 4.h,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade400,
                      borderRadius: BorderRadius.circular(2.r),
                    ),
                  ),
                  Gap(15.h),
                  Align(
                    alignment: Alignment.topRight,
                    child: AppText(
                      text: 'ترتيب علي حسب',
                      fontsize: 16.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: _dropDown(
                              value: selectedAddress,
                              onChanged: (val) {
                                setState(() {
                                  selectedAddress = val;
                                });
                              },
                              hint: 'المنطقة',
                              items: deliveryData.areas
                                  .map(
                                    (area) => DropdownMenuItem(
                                      value: area,
                                      child: Text(area),
                                    ),
                                  )
                                  .toList(),
                            ),
                          ),
                          Gap(40.h),
                          const Expanded(
                            child: SizedBox(),
                          ), // تقدر تضيف المحافظة هنا
                        ],
                      ),
                      Gap(15.h),
                      Row(
                        children: [
                          Expanded(
                            child: _dropDown(
                              value: selectedCar,
                              onChanged: (val) {
                                setState(() {
                                  selectedCar = val;
                                });
                              },
                              hint: 'نوع الحمولة',
                              items: deliveryData.cargoTypes
                                  .map(
                                    (type) => DropdownMenuItem(
                                      value: type,
                                      child: Text(type),
                                    ),
                                  )
                                  .toList(),
                            ),
                          ),
                          Gap(40.h),
                          Expanded(
                            child: _dropDown(
                              value: selectedWight,
                              onChanged: (val) {
                                setState(() {
                                  selectedWight = val;
                                });
                              },
                              hint: 'نوع العربية',
                              items: deliveryData.vehicleTypes
                                  .map(
                                    (type) => DropdownMenuItem(
                                      value: type,
                                      child: Text(type),
                                    ),
                                  )
                                  .toList(),
                            ),
                          ),
                        ],
                      ),
                      Gap(15.h),
                      Row(
                        children: [
                          Expanded(
                            child: _dropDown(
                              value: selectedDriver,
                              onChanged: (val) {
                                setState(() {
                                  selectedDriver = val;
                                });
                              },
                              hint: 'نوع التوصيل',
                              items: deliveryData.deliveryTypes
                                  .map(
                                    (type) => DropdownMenuItem(
                                      value: type,
                                      child: Text(type),
                                    ),
                                  )
                                  .toList(),
                            ),
                          ),
                          Gap(40.h),
                          Expanded(
                            child: _dropDown(
                              value: selectedDiliveryType,
                              onChanged: (val) {
                                setState(() {
                                  selectedDiliveryType = val;
                                });
                              },
                              hint: 'اسم السائق',
                              items: deliveryData.drivers
                                  .map(
                                    (driver) => DropdownMenuItem(
                                      value: driver.id,
                                      child: Text(driver.name),
                                    ),
                                  )
                                  .toList(),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Gap(20.h),
                  InkWell(
                    onTap: () {
                      final cubit = DriverCubit.get(context);
                      final filters = {
                        if (selectedDriver != null &&
                            selectedDriver!.isNotEmpty)
                          'deliveryType': selectedDriver,
                        if (selectedWight != null && selectedWight!.isNotEmpty)
                          'vehicleType': selectedWight,
                        if (selectedCar != null && selectedCar!.isNotEmpty)
                          'cargoType': selectedCar,
                        if (selectedAddress != null &&
                            selectedAddress!.isNotEmpty)
                          'area': selectedAddress,
                        if (selectedDiliveryType != null &&
                            selectedDiliveryType!.isNotEmpty)
                          'driverName': selectedDiliveryType,
                      };

                      cubit.featchDrivers(filters: filters);
                      Navigator.pop(context); // تقفل البوتوم شيت بعد البحث
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 60.w,
                        vertical: 10.h,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xff6A994E),
                        borderRadius: BorderRadius.circular(5.r),
                      ),
                      child: AppText(
                        text: 'بحث',
                        color: Colors.white,
                        fontsize: 15.sp,
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}

import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:image_picker/image_picker.dart';
import 'package:reef/core/helpers/cach_helper.dart';
import 'package:reef/core/widgets/custom_feild.dart';
import 'package:reef/core/widgets/header.dart';
import 'package:reef/core/widgets/show_toast.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/app_text.dart';
import '../../../navbar/logic/navbar.dart';
import '../../data/CarModel.dart';
import '../../logic/dreiver_cubit.dart';
import '../../logic/dreiver_state.dart';

class AddCarScreen extends StatefulWidget {
  const AddCarScreen({super.key});

  @override
  State<AddCarScreen> createState() => _AddCarScreenState();
}

class _AddCarScreenState extends State<AddCarScreen> {
  List<File> selectedImages = [];
  final ImagePicker picker = ImagePicker();

  // باقي الـ controllers اللي ناقصين
  final TextEditingController TitelController = TextEditingController();
  final TextEditingController DetalsController = TextEditingController();
  final TextEditingController carTypeController = TextEditingController();
  final TextEditingController capacityController = TextEditingController();
  final TextEditingController cargoTypeController = TextEditingController();
  final TextEditingController lastMaintenanceController =
  TextEditingController();

  String? dlivary;

  Future<void> pickImages() async {
    final pickedFiles = await picker.pickMultiImage(imageQuality: 75);
    if (pickedFiles != null && pickedFiles.isNotEmpty) {
      setState(() {
        selectedImages = pickedFiles.map((e) => File(e.path)).toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<DriverCubit,DriverState>(
      listener: (context,state){
        if(state is AddDriverSuccess){
          Navigator.push(context, MaterialPageRoute(builder: (context)=>NavbarWidget(
            role: CacheHelper.getData('role')!,
          )));
        }
        if(state is AddDriverError){
          showToast(message: 'يوجد لديك عربه بالفعل!', color: Colors.red);
        }
      },
      builder: (context,state){
        return Scaffold(
          body: SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(minHeight: constraints.maxHeight),
                    child: IntrinsicHeight(
                      child: Padding(
                        padding: EdgeInsets.only(
                          right: 10.w,
                          left: 10.w,
                          top: 10.w,
                          bottom: 35.w,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            header(
                              name: "أضف تفاصيل العربية",
                              icon: Icons.navigate_next,
                            ),
                            Gap(15.h),
                            // Row(
                            //   mainAxisAlignment: MainAxisAlignment.end,
                            //   children: [
                            //     Column(
                            //       crossAxisAlignment: CrossAxisAlignment.end,
                            //       children: [
                            //         AppText(
                            //           text: 'م. أحمد علي',
                            //           fontWeight: FontWeight.w500,
                            //           fontsize: 16.sp,
                            //         ),
                            //         AppText(
                            //           text: 'خبرة 5 سنوات',
                            //           fontWeight: FontWeight.w500,
                            //           fontsize: 12.sp,
                            //           color: Color(0xFFc7c7c7),
                            //         ),
                            //       ],
                            //     ),
                            //     Gap(12.w),
                            //     CircleAvatar(
                            //       backgroundColor: AppColors.bgColor,
                            //       radius: 32.r,
                            //       backgroundImage: AssetImage(
                            //         'assets/images/avatar.png',
                            //       ),
                            //     ),
                            //   ],
                            // ),
                            Gap(25.h),
                            AppText(text: 'عنوان البوست', textAlign: TextAlign.end),
                            CustomFeild(
                              obscureText: false,
                              hintText: "اكتب عنوان البوست هنا",
                              controller: TitelController,
                              validator: (v) {
                                if (v == null || v.isEmpty) {
                                  return "هذا العنوان لا يمكن ان يكون فارغ ";
                                }
                              },
                            ),
                            Gap(15.h),
                            AppText(text: "محتوى البوست", textAlign: TextAlign.end),
                            CustomFeild(
                              obscureText: false,
                              hintText: "اكتب محتوى البوست هنا",
                              controller: DetalsController,
                              validator: (v) {
                                if (v == null || v.isEmpty) {
                                  return "هذا المحتوى لا يمكن ان يكون فارغ ";
                                }
                              },
                            ),
                            Gap(25.h),
                            Row(
                              children: [
                                Gap(15.w),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      AppText(
                                        text: 'حمولة العربية ',
                                        textAlign: TextAlign.end,
                                      ),
                                      Gap(5.h),
                                      CustomFeild(
                                        obscureText: false,
                                        hintText: "مثال: (2طن/كجم)",
                                        controller: capacityController,
                                        validator: (v) {
                                          if (v == null || v.isEmpty) {
                                            return "هذا العنوان لا يمكن ان يكون فارغ ";
                                          }
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                                Gap(15.h),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      AppText(
                                        text: 'نوع العربية ',
                                        textAlign: TextAlign.end,
                                      ),
                                      Gap(5.h),
                                      CustomFeild(
                                        obscureText: false,
                                        hintText: "اختر نوع العربية",
                                        controller: carTypeController,
                                        validator: (v) {
                                          if (v == null || v.isEmpty) {
                                            return "هذا النوع لا يمكن ان يكون فارغ ";
                                          }
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            Gap(15.h),
                            Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      AppText(
                                        text: 'اخر صيانة',
                                        textAlign: TextAlign.end,
                                      ),
                                      Gap(5.h),
                                      CustomFeild(
                                        obscureText: false,
                                        hintText: "مثال: قبل شهرين",
                                        controller: lastMaintenanceController,
                                        validator: (v) {
                                          if (v == null || v.isEmpty) {
                                            return "هذا العنوان لا يمكن ان يكون فارغ ";
                                          }
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                                Gap(15.w),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      AppText(
                                        text: 'نوع الحمولة ',
                                        textAlign: TextAlign.end,
                                      ),
                                      Gap(5.h),
                                      CustomFeild(
                                        obscureText: false,
                                        hintText: "مثال: محاصيل زراعية ",
                                        controller: cargoTypeController,
                                        validator: (v) {
                                          if (v == null || v.isEmpty) {
                                            return "هذا العنوان لا يمكن ان يكون فارغ ";
                                          }
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            Gap(25.h),
                            _dropDown(
                              value: dlivary,
                              onChanged: (val) {
                                setState(() {
                                  dlivary = val;
                                });
                              },
                              hint: 'التوصيل',
                              items: const [
                                DropdownMenuItem(
                                  value: 'داخل المحافظة',
                                  child: Text(
                                    'داخل المحافظة',
                                    textAlign: TextAlign.end,
                                  ),
                                ),
                                DropdownMenuItem(
                                  value: 'خارج المحافظة',
                                  child: Text(
                                    'خارج المحافظة',
                                    textAlign: TextAlign.end,
                                  ),
                                ),
                              ],
                            ),

                            Gap(25.h),
                            DottedBorder(
                              color: AppColors.primary,
                              strokeWidth: 2,
                              dashPattern: [6, 4],
                              borderType: BorderType.RRect,
                              radius: Radius.circular(12),
                              child: Container(
                                width: 400.w,
                                padding: EdgeInsets.symmetric(vertical: 16),
                                color: Colors.white,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    selectedImages.isNotEmpty
                                        ? Wrap(
                                      spacing: 8,
                                      runSpacing: 8,
                                      children:
                                      selectedImages
                                          .map(
                                            (img) => ClipRRect(
                                          borderRadius:
                                          BorderRadius.circular(8),
                                          child: Image.file(
                                            img,
                                            width: 60,
                                            height: 60,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      )
                                          .toList(),
                                    )
                                        : Image.asset(
                                      'assets/images/blankImg.png',
                                      height: 60,
                                      width: 60,
                                    ),
                                    Gap(8.h),
                                    AppText(text: "اضافة صورة", fontsize: 15.sp),
                                    Gap(4.h),
                                    AppText(
                                      text: "(اختياري) يفضل صورة توضيحية",
                                      color: Colors.black38,
                                      fontsize: 9.sp,
                                    ),
                                    Gap(20.h),
                                    GestureDetector(
                                      onTap: pickImages,
                                      child: Container(
                                        width: 120.w,
                                        height: 30.h,
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          border: Border.all(
                                            color: AppColors.primary,
                                          ),
                                          borderRadius: BorderRadius.circular(10.r),
                                        ),
                                        child: AppText(
                                          text: 'اختيار صورة',
                                          fontsize: 12.sp,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),

                            Gap(35.h),
                            InkWell(
                              onTap: () {
                                final driver = CarModel(
                                  title: TitelController.text,
                                  description: DetalsController.text,
                                  vehicleType: carTypeController.text,
                                  vehicleCapacity: capacityController.text,
                                  cargoType: cargoTypeController.text,
                                  lastMaintenance: lastMaintenanceController.text,
                                  deliveryType: dlivary ?? '',
                                  vehicleImages: [],
                                );
                                print('title: ${driver.title}');
                                print('description: ${driver.description}');
                                print('vehicleType: ${driver.vehicleType}');
                                print('vehicleCapacity: ${driver.vehicleCapacity}');
                                print('cargoType: ${driver.cargoType}');
                                print('lastMaintenance: ${driver.lastMaintenance}');
                                print('deliveryType: ${driver.deliveryType}');
                                print(
                                  'vehicleImages count: ${selectedImages.length}',
                                );
                                if (selectedImages.isEmpty) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        "يجب اختيار صورة واحدة على الأقل",
                                      ),
                                    ),
                                  );
                                  return;
                                }

                                DriverCubit.get(
                                  context,
                                ).postCarWithImage(driver, selectedImages);
                              },
                              child: Container(
                                width: 350.w,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: AppColors.primary,
                                  borderRadius: BorderRadius.circular(7),
                                ),
                                child: Center(
                                  child: AppText(
                                    text: state is AddDriverLoading?"....يتم نشر البوست": "نشر البوست",
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },


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
}
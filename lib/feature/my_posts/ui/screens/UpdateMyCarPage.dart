import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:image_picker/image_picker.dart';
import 'package:reef/core/helpers/cach_helper.dart';
import 'package:reef/core/helpers/extensions.dart';
import 'package:reef/core/widgets/custom_feild.dart';
import 'package:reef/core/widgets/header.dart';
import 'package:reef/core/widgets/show_toast.dart';
import 'package:reef/feature/my_posts/data/Model/MyCar_Modle.dart';

import 'package:reef/feature/my_posts/logic/UpdateMyCarCubit/cubit/up_date_my_car_cubit.dart';
import 'package:reef/feature/my_posts/logic/UpdateMyCarCubit/cubit/up_date_my_car_state.dart';
import 'package:reef/feature/my_posts/logic/cubit/update_my_car_cubit_cubit.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/app_text.dart';
import '../../../navbar/logic/navbar.dart';

// كل الـ imports زي ما هي

class UpdateMyCarScreen extends StatefulWidget {
  final MyCarModel myCarmodel;
  const UpdateMyCarScreen({super.key, required this.myCarmodel});

  @override
  State<UpdateMyCarScreen> createState() => _AddCarScreenState();
}

class _AddCarScreenState extends State<UpdateMyCarScreen> {
  List<File> selectedImages = [];
  final ImagePicker picker = ImagePicker();
  List<String> oldImages = [];

  final TextEditingController TitelController = TextEditingController();
  final TextEditingController DetalsController = TextEditingController();
  final TextEditingController carTypeController = TextEditingController();
  final TextEditingController capacityController = TextEditingController();
  final TextEditingController cargoTypeController = TextEditingController();
  final TextEditingController lastMaintenanceController =
      TextEditingController();
  String? dlivary;
  final token = CacheHelper.getData('token');

  Future<void> pickImages() async {
    final pickedFiles = await picker.pickMultiImage(imageQuality: 75);
    if (pickedFiles != null && pickedFiles.isNotEmpty) {
      setState(() {
        selectedImages.addAll(pickedFiles.map((e) => File(e.path)).toList());
      });
    }
  }

  @override
  void initState() {
    super.initState();
    TitelController.text = widget.myCarmodel.title ?? '';
    DetalsController.text = widget.myCarmodel.description ?? '';
    carTypeController.text = widget.myCarmodel.vehicleType ?? '';
    capacityController.text = widget.myCarmodel.vehicleCapacity ?? '';
    cargoTypeController.text = widget.myCarmodel.cargoType ?? '';
    lastMaintenanceController.text = widget.myCarmodel.lastMaintenance ?? '';
    dlivary = widget.myCarmodel.deliveryType;
    oldImages = widget.myCarmodel.vehicleImages ?? [];
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<UpdateMyCarCubit, UpdateMyCarState>(
      listener: (context, state) {
        if (state is UpdateMyCarSucsses) {
          context.pop();
          MyCarCubit.get(context).getMyCar();
        }
        if (state is UpdateMyCarError) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(state.error)));
        }
      },
      builder: (context, state) {
        return Scaffold(
          body: SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints:
                        BoxConstraints(minHeight: constraints.maxHeight),
                    child: IntrinsicHeight(
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 10.w, vertical: 10.w),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            header(
                              name: "عدل تفاصيل العربية",
                              icon: Icons.navigate_next,
                            ),
                            Gap(25.h),
                            AppText(
                                text: 'عنوان البوست', textAlign: TextAlign.end),
                            CustomFeild(
                              obscureText: false,
                              hintText: "اكتب عنوان البوست هنا",
                              controller: TitelController,
                              validator: (v) => v == null || v.isEmpty
                                  ? "هذا العنوان لا يمكن ان يكون فارغ"
                                  : null,
                            ),
                            Gap(15.h),
                            AppText(
                                text: "محتوى البوست", textAlign: TextAlign.end),
                            CustomFeild(
                              obscureText: false,
                              hintText: "اكتب محتوى البوست هنا",
                              controller: DetalsController,
                              validator: (v) => v == null || v.isEmpty
                                  ? "هذا المحتوى لا يمكن ان يكون فارغ"
                                  : null,
                            ),
                            Gap(25.h),
                            Row(
                              children: [
                                Gap(15.w),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      AppText(text: 'حمولة العربية'),
                                      Gap(5.h),
                                      CustomFeild(
                                        obscureText: false,
                                        hintText: "مثال: (2طن/كجم)",
                                        controller: capacityController,
                                        validator: (v) => v == null || v.isEmpty
                                            ? "لا يمكن أن يكون فارغ"
                                            : null,
                                      ),
                                    ],
                                  ),
                                ),
                                Gap(15.h),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      AppText(text: 'نوع العربية'),
                                      Gap(5.h),
                                      CustomFeild(
                                        obscureText: false,
                                        hintText: "اختر نوع العربية",
                                        controller: carTypeController,
                                        validator: (v) => v == null || v.isEmpty
                                            ? "لا يمكن أن يكون فارغ"
                                            : null,
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
                                      AppText(text: 'اخر صيانة'),
                                      Gap(5.h),
                                      CustomFeild(
                                        obscureText: false,
                                        hintText: "مثال: قبل شهرين",
                                        controller: lastMaintenanceController,
                                        validator: (v) => v == null || v.isEmpty
                                            ? "لا يمكن أن يكون فارغ"
                                            : null,
                                      ),
                                    ],
                                  ),
                                ),
                                Gap(15.w),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      AppText(text: 'نوع الحمولة'),
                                      Gap(5.h),
                                      CustomFeild(
                                        obscureText: false,
                                        hintText: "مثال: محاصيل زراعية",
                                        controller: cargoTypeController,
                                        validator: (v) => v == null || v.isEmpty
                                            ? "لا يمكن أن يكون فارغ"
                                            : null,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            Gap(25.h),
                            _dropDown(
                              value: dlivary,
                              onChanged: (val) => setState(() => dlivary = val),
                              hint: 'التوصيل',
                              items: const [
                                DropdownMenuItem(
                                    value: 'داخل المحافظة',
                                    child: Text('داخل المحافظة')),
                                DropdownMenuItem(
                                    value: 'خارج المحافظة',
                                    child: Text('خارج المحافظة')),
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
                                    (selectedImages.isNotEmpty ||
                                            oldImages.isNotEmpty)
                                        ? Wrap(
                                            spacing: 8,
                                            runSpacing: 8,
                                            children: [
                                              ...oldImages.map((e) => Stack(
                                                    children: [
                                                      ClipRRect(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8),
                                                        child: Image.network(
                                                          'http://82.29.172.199:8001$e',
                                                          width: 60,
                                                          height: 60,
                                                          fit: BoxFit.cover,
                                                        ),
                                                      ),
                                                      Positioned(
                                                        top: 0,
                                                        right: 0,
                                                        child: GestureDetector(
                                                          onTap: () => setState(
                                                              () => oldImages
                                                                  .remove(e)),
                                                          child: CircleAvatar(
                                                            radius: 10,
                                                            backgroundColor:
                                                                Colors.red,
                                                            child: Icon(
                                                                Icons.close,
                                                                size: 12,
                                                                color: Colors
                                                                    .white),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  )),
                                              ...selectedImages.map((file) =>
                                                  Stack(
                                                    children: [
                                                      ClipRRect(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8),
                                                        child: Image.file(
                                                          file,
                                                          width: 60,
                                                          height: 60,
                                                          fit: BoxFit.cover,
                                                        ),
                                                      ),
                                                      Positioned(
                                                        top: 0,
                                                        right: 0,
                                                        child: GestureDetector(
                                                          onTap: () {
                                                            setState(() =>
                                                                selectedImages
                                                                    .remove(
                                                                        file));
                                                          },
                                                          child: CircleAvatar(
                                                            radius: 10,
                                                            backgroundColor:
                                                                Colors.red,
                                                            child: Icon(
                                                                Icons.close,
                                                                size: 12,
                                                                color: Colors
                                                                    .white),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  )),
                                            ],
                                          )
                                        : Image.asset(
                                            'assets/images/blankImg.png',
                                            height: 60,
                                            width: 60,
                                          ),
                                    Gap(8.h),
                                    AppText(
                                        text: "اضافة صورة", fontsize: 15.sp),
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
                                              color: AppColors.primary),
                                          borderRadius:
                                              BorderRadius.circular(10.r),
                                        ),
                                        child: AppText(
                                            text: 'اختيار صورة',
                                            fontsize: 12.sp),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Gap(35.h),
                            InkWell(
                              onTap: () {
                                if (listEquals(selectedImages, oldImages)) {
                                  showToast(
                                    message: 'الصوره موجوده بالفعل',
                                    color: Colors.red,
                                    msg: 'الصوره موجوده بالفعل',
                                    state: null,
                                  );
                                } else {
                                  UpdateMyCarCubit.get(context).updateCar(
                                    title: TitelController.text,
                                    description: DetalsController.text,
                                    vehicleType: carTypeController.text,
                                    vehicleCapacity: capacityController.text,
                                    cargoType: cargoTypeController.text,
                                    lastMaintenance:
                                        lastMaintenanceController.text,
                                    deliveryType: dlivary ?? '',
                                    vehicleImages: selectedImages ?? [],
                                    oldImages: oldImages ?? [],
                                  );
                                }

                                print(TitelController.text);
                                print(DetalsController.text);
                                print(carTypeController.text);
                                print(lastMaintenanceController.text);
                                print(TitelController.text);
                                print("deliveryType: $dlivary");
                                print("vehicleImages: $selectedImages");
                                print("oldImages: $oldImages");
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
                                    text: state is UpdateMyCarLoding
                                        ? "....يتم تعديل البوست"
                                        : "تم تعديل البوست",
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

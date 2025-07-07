import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:image_picker/image_picker.dart';
import 'package:reef/core/constants/app_colors.dart';
import 'package:reef/core/helpers/cach_helper.dart';
import 'package:reef/core/helpers/extensions.dart';
import 'package:reef/core/routing/routes.dart';
import 'package:reef/core/widgets/app_text.dart';
import 'package:reef/feature/categories/logic/cubit/category_cubit.dart';
import 'package:reef/feature/create_post/data/create_post_model.dart';
import 'package:reef/feature/create_post/logic/cubit/create_post_cubit.dart';
import 'package:reef/feature/my_posts/ui/widgets/modifications_fields.dart';

import '../../../../core/routing/routes.dart';
import '../../../../core/widgets/show_toast.dart';
import '../../../navbar/logic/navbar.dart';

class CreatePostScreen extends StatefulWidget {
  const CreatePostScreen({super.key});

  @override
  State<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  List<String> priceUnits = ['للواحدة', 'للكيلو', 'للطرد', 'للكرتونة'];
  List<String> quantityUnits = ['كيلو', 'جرام', 'قطعة', 'طن', 'صندوق'];
  List<String> sellTypes = ['جملة', 'تجزئة'];
  List<String> productConditions = ['من فترة', 'حديثاً'];

  String? priceType;
  String? type3; // الوزن
  String? type4; // نوع البيع
  String? selectedValue; // الحالة

  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController quantityController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController whatsappController = TextEditingController();

  String? selectedCategoryId;
  String? selectedSubCategoryId;

  List<File> selectedImages = [];

  @override
  void initState() {
    super.initState();
    final cubit = CategoryCubit.get(context);
    cubit.getCategories();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CreatePostCubit, CreatePostState>(
      listener: (context,state){
        if(state is CreatePostFailure){
          showToast(
            message: 'ادخل باقي المعلومات ',
            color: Colors.red
          );
        }
        if(state is CreatePostSuccess){
          showToast(
              message: 'تم نشر الاعلان بنجاح',
              color: Colors.green
          );
          Navigator.push(context, MaterialPageRoute(builder: (context)=>NavbarWidget(role: CacheHelper.getData('role')!,)));
        }
      },
      builder: (context,state){
        return Scaffold(
          body: SafeArea(
            child: Column(
              children: [
                _header(context),
                _image(),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 15.h, horizontal: 15.w),
                    child: ListView(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: BlocBuilder<CategoryCubit, CategoryState>(
                                builder: (context, state) {
                                  final cubit = CategoryCubit.get(context);
                                  final subCategories =
                                      cubit.subCategoriesMap[selectedCategoryId] ??
                                          [];
                                  return _dropDown(
                                    value: selectedSubCategoryId,
                                    onChanged:
                                        (val) => setState(
                                          () => selectedSubCategoryId = val,
                                    ),
                                    hint: 'اختر الصنف ',
                                    items:
                                    subCategories.map((sub) {
                                      return DropdownMenuItem(
                                        value: sub.id,
                                        child: Text(sub.name),
                                      );
                                    }).toList(),
                                  );
                                },
                              ),
                            ),
                            Gap(20.w),
                            Expanded(
                              child: BlocBuilder<CategoryCubit, CategoryState>(
                                builder: (context, state) {
                                  final cubit = CategoryCubit.get(context);
                                  final categories = cubit.categories;
                                  return _dropDown(
                                    value: selectedCategoryId,
                                    onChanged: (val) {
                                      setState(() {
                                        selectedCategoryId = val;
                                        selectedSubCategoryId = null;
                                      });

                                      if (val != null) {
                                        CategoryCubit.get(
                                          context,
                                        ).getSubCategories(val);
                                      }
                                    },
                                    hint: 'اختر نوع المنتج',
                                    items:
                                    categories.map((category) {
                                      return DropdownMenuItem(
                                        value: category.id,
                                        child: Text(category.name),
                                      );
                                    }).toList(),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                        ModificationsFields(
                          title: 'أسم المنتج',
                          hint: 'اكتب اسم المنتج باختصار ...',
                          controller: nameController,
                        ),
                        ModificationsFields(
                          title: 'وصف المنتج',
                          hint: ' صف المنتج بالتفصيل ..',
                          controller: descriptionController,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Expanded(
                              child: _dropDown(
                                value: priceType,
                                onChanged: (val) => setState(() => priceType = val),
                                hint: 'اختر الوحدة',
                                items:
                                priceUnits.map((item) {
                                  return DropdownMenuItem<String>(
                                    value: item,
                                    child: Text(item),
                                  );
                                }).toList(),
                              ),
                            ),
                            Gap(20.w),
                            Expanded(
                              child: ModificationsFields(
                                title: 'السعر',
                                hint: 'مثل: "200" – السعر بالجنيه',
                                controller: priceController,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Expanded(
                              child: _dropDown(
                                value: type3,
                                onChanged: (val) => setState(() => type3 = val),
                                hint: 'اختر الوزن',
                                items:
                                quantityUnits.map((item) {
                                  return DropdownMenuItem<String>(
                                    value: item,
                                    child: Text(item),
                                  );
                                }).toList(),
                              ),
                            ),
                            Gap(20.w),
                            Expanded(
                              child: ModificationsFields(
                                title: ' الكميه المتوفره',
                                hint: 'اكتب الكمية',
                                controller: quantityController,
                              ),
                            ),
                          ],
                        ),
                        Gap(20.h),
                        Row(
                          children: [
                            Expanded(
                              child: _dropDown(
                                value: type4,
                                onChanged: (val) => setState(() => type4 = val),
                                hint: 'اختر نوع البيع',
                                items:
                                sellTypes.map((item) {
                                  return DropdownMenuItem<String>(
                                    value: item,
                                    child: Text(item),
                                  );
                                }).toList(),
                              ),
                            ),
                            Gap(20.w),
                            Expanded(
                              child: _dropDown(
                                value: selectedValue,
                                onChanged:
                                    (val) => setState(() => selectedValue = val),
                                hint: 'اخترالحالة',
                                items:
                                productConditions.map((item) {
                                  return DropdownMenuItem<String>(
                                    value: item,
                                    child: Text(item),
                                  );
                                }).toList(),
                              ),
                            ),
                          ],
                        ),
                        ModificationsFields(
                          title: 'العنوان',
                          hint:
                          'اكتب اسم المحافظة أو المركز، مثل: "البحيرة - دمنهور"',
                          controller: addressController,
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: ModificationsFields(
                                title: ' رقم الواتساب',
                                hint: '01XXXXXXXXX',
                                controller: whatsappController,
                              ),
                            ),
                            Gap(20.w),
                            Expanded(
                              child: ModificationsFields(
                                title: ' رقم الهاتف',
                                hint: '01XXXXXXXXX',
                                controller: phoneController,
                              ),
                            ),
                          ],
                        ),
                        Gap(20.h),
                        _buttons(),
                      ],
                    ),
                  ),
                ),
              ],
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

  Widget _image() => Stack(
    children: [
      Container(
        color: AppColors.white,
        height: 250.h,
        width: double.infinity,
        child: selectedImages.isEmpty
            ? Center(
          child: Image.asset(
            'assets/images/image.png',
            height: 106.h,
            width: 151.w,
          ),
        )
            : PageView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: selectedImages.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: EdgeInsets.only(right: 10.w),
              child: Image.file(
                selectedImages[index],
                width: 151.w,
                height: 106.h,
                fit: BoxFit.cover,
              ),
            );
          },
        ),
      ),
      Positioned(
        bottom: 10.h,
        left: 10.w,
        child: InkWell(
          onTap: pickImages,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 10.w),
            height: 35.h,
            width: 148.w,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.r),
              color: AppColors.white,
            ),
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.edit, color: AppColors.black),
                  Gap(10.w),
                  AppText(
                    text: 'إضافة صور',
                    color: AppColors.black,
                    fontsize: 13.sp,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    ],
  );

  InkWell _buttons() {
    return InkWell(
      onTap: () {
        if (selectedImages.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('يرجى اختيار صور')));
          return;
        }

        final int price = int.tryParse(priceController.text.trim()) ?? 0;
        final int quantity = int.tryParse(quantityController.text.trim()) ?? 0;
        final model = CreatePostModel(
          name: nameController.text,
          description: descriptionController.text,
          price: price,
          priceUnit: priceType ?? '',
          quantity: quantity,
          quantityUnit: type3 ?? '',
          sellType: type4 ?? '',
          condition: selectedValue ?? '',
          address: addressController.text,
          phone: phoneController.text,
          whatsapp: whatsappController.text,
          categoryId: selectedCategoryId ?? '',
          subCategoryId: selectedSubCategoryId ?? '',
          images: [],
        );

        BlocProvider.of<CreatePostCubit>(
          context,
        ).createPostWithImage(model, selectedImages !);
      },
      child: Container(
        height: 45.h,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.r),
          color: AppColors.primary,
        ),
        child: Center(
          child: AppText(
            text: 'نشر الأعلان',
            color: AppColors.white,
            fontsize: 13.sp,
          ),
        ),
      ),
    );
  }

  Padding _header(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 18.h, horizontal: 15.w),
      child: Row(
        children: [
          InkWell(
            onTap: () {
              context.pushReplacementNamed(Routes.navbar);
            },
            child: AppText(
              text: "إلغاء",
              fontsize: 14.sp,
              fontWeight: FontWeight.w700,
              color: AppColors.primary,
            ),
          ),
          Spacer(),
          AppText(
            text: "إضافة إعلان",
            fontsize: 17.sp,
            fontWeight: FontWeight.w500,
          ),
          Gap(10.w),
          InkWell(
            onTap: () {
              context.pushReplacementNamed(Routes.navbar);
            },
            child: SvgPicture.asset('assets/images/backIcon.svg'),
          ),
          Gap(10.w),
        ],
      ),
    );
  }

  Future<void> pickImages() async {
    final pickedFiles = await ImagePicker().pickMultiImage();
    if (pickedFiles.isNotEmpty) {
      setState(() {
        selectedImages  = pickedFiles.map((e) => File(e.path)).toList();
      });
    }
  }
}

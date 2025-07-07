import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:image_picker/image_picker.dart';
import 'package:reef/core/helpers/cach_helper.dart';
import 'package:reef/core/widgets/header.dart';
import 'package:reef/core/widgets/show_toast.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/app_text.dart';
import '../../../../core/widgets/custom_feild.dart';
import '../../../navbar/logic/navbar.dart';
import '../../../profile/logic/cubit/profile_cubit.dart';
import '../../logic/cubit/ask_engineer_cubit.dart';
import '../../logic/cubit/ask_engineer_state.dart';

class EngineerAddPost extends StatefulWidget {
  const EngineerAddPost({super.key});

  @override
  State<EngineerAddPost> createState() => _EngineerAddPostState();
}

class _EngineerAddPostState extends State<EngineerAddPost> {
  final TextEditingController TitelController = TextEditingController();
  final TextEditingController DetalsController = TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    ProfileCubit.get(context).getUser();
    ASkEngineerCubit.get(context).getEngineer();
  }

  File? selectedImage;
  Future<void> pickImage() async {
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );
    if (pickedFile != null) {
      setState(() {
        selectedImage = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return BlocConsumer<ASkEngineerCubit, AskEngineerState>(
              listener: (context, state) {
                if (state is SuccessCreatePostState) {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => NavbarWidget(
                                role: CacheHelper.getData('role')!,
                              )));
                  showToast(
                      message:
                          'تم ارسال الاعلان بنجاح , وسيتم قبوله في اسرع وقت',
                      color: Colors.green);
                }
                if (state is ErrorCreatePostState) {
                  showToast(message: 'ادخل باقي المعلومات', color: Colors.red);
                }
              },
              builder: (context, state) {
                var users =
                    ASkEngineerCubit.get(context).getEngineerModel?.users;
                var engineer = users?[0];

                return SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints:
                        BoxConstraints(minHeight: constraints.maxHeight),
                    child: IntrinsicHeight(
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            header(
                                name: "أضف منشور جديد",
                                icon: Icons.navigate_next),
                            Gap(15.h),
                            engineer != null
                                ? Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          AppText(
                                            text: '${engineer.name}',
                                            fontWeight: FontWeight.w500,
                                            fontsize: 16.sp,
                                          ),
                                          AppText(
                                            text:
                                                ' استشارات زراعية، محاصيل، مكافحة الآفات',
                                            fontWeight: FontWeight.w500,
                                            fontsize: 12.sp,
                                            color: Color(0xFFc7c7c7),
                                          ),
                                        ],
                                      ),
                                      Gap(12.w),
                                      CircleAvatar(
                                          backgroundColor: AppColors.bgColor,
                                          radius: 32.r,
                                          backgroundImage: engineer
                                                          .profilePhoto !=
                                                      null &&
                                                  engineer.profilePhoto!
                                                      .trim()
                                                      .isNotEmpty
                                              ? NetworkImage(
                                                  engineer.profilePhoto!
                                                          .startsWith('http')
                                                      ? engineer.profilePhoto!
                                                          .trim()
                                                      : 'http://82.29.172.199:8001${engineer.profilePhoto!.trim()}',
                                                )
                                              : null),
                                    ],
                                  )
                                : CircularProgressIndicator(),
                            Gap(25.h),
                            Padding(
                              padding: const EdgeInsets.only(left: 230),
                              child: AppText(text: 'عنوان البوست'),
                            ),
                            CustomFeild(
                                controller: TitelController,
                                validator: (v) {
                                  if (v == null || v.isEmpty) {
                                    return "هذا العنوان لا يمكن ان يكون فارغ ";
                                  }
                                },
                                hintText:
                                    " ...انخفاض درجات الحرارة يدعم زراعة الفراولة في دلتا مصر"),
                            Gap(15.h),
                            Padding(
                              padding: const EdgeInsets.only(left: 230),
                              child: AppText(text: "محتوى البوست"),
                            ),
                            Container(
                              width: 350.w,
                              height: 100.h,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(7),
                                border: Border.all(color: Colors.black26),
                              ),
                              child: TextFormField(
                                controller: DetalsController,
                                validator: (v) {
                                  if (v == null || v.isEmpty) {
                                    return "هذا المحتوى لا يمكن أن يكون فارغًا";
                                  }
                                  return null;
                                },
                                maxLines: null,
                                minLines: 6,
                                keyboardType: TextInputType.multiline,
                                textAlign:
                                    TextAlign.right, // يجعل النص يبدأ من اليمين
                                textDirection: TextDirection
                                    .rtl, // يدعم اللغات من اليمين لليسار مثل العربية
                                decoration: InputDecoration(
                                  hintText:
                                      " ...درجة الحرارة المثالية لزراعة الفراولة",
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.symmetric(
                                      horizontal: 12.w, vertical: 12.h),
                                ),
                              ),
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
                                    selectedImage != null
                                        ? Image.file(
                                            selectedImage!,
                                            height: 100.h,
                                            width: 100.w,
                                            fit: BoxFit.contain,
                                          )
                                        : Image.asset(
                                            'assets/images/blankImg.png',
                                            height: 60,
                                            width: 60,
                                          ),
                                    AppText(
                                        text: "اضافة صورة", fontsize: 15.sp),
                                    Gap(4.h),
                                    AppText(
                                      text: "(اختياري) يفضل صورة توضيحية",
                                      color: Colors.black38,
                                      fontsize: 9.sp,
                                    ),
                                    Gap(20.h),
                                    GestureDetector(
                                      onTap: () {
                                        pickImage();
                                      },
                                      child: Container(
                                        width: 120.w,
                                        height: 30.h,
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          border: Border.all(
                                              color: AppColors.primary),
                                          borderRadius:
                                              BorderRadius.circular(7),
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
                            state is LoadingCreatePostState
                                ? Center(child: CircularProgressIndicator())
                                : GestureDetector(
                                    onTap: () {
                                      ASkEngineerCubit.get(context)
                                          .createEngPost(
                                        TitelController.text,
                                        DetalsController.text,
                                        selectedImage, // الآن تقبل null عادي
                                      );
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
                                          text: "نشر البوست",
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
            );
          },
        ),
      ),
    );
  }
}

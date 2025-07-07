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

class UpdateEngPostScreen extends StatefulWidget {
  final String id;
  final String title;
  final String description;
  final String? imageUrl;
  const UpdateEngPostScreen(
      {super.key,
      required this.id,
      required this.title,
      required this.description,
      this.imageUrl});

  @override
  State<UpdateEngPostScreen> createState() => _UpdateEngPostScreenState();
}

class _UpdateEngPostScreenState extends State<UpdateEngPostScreen> {
  final TextEditingController TitelController = TextEditingController();
  final TextEditingController DetalsController = TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    TitelController.text = widget.title;
    DetalsController.text = widget.description;

    // تحميل الصورة من URL وحفظها كـ File اختياري
    if (widget.imageUrl != null && widget.imageUrl!.isNotEmpty) {
      selectedImage = File(
          widget.imageUrl!); // لو محتاج تعمل Download فعلي قولي أساعدك فيها
    }
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
                if (state is SuccessUpdatePostState) {
                  showToast(
                    message: 'تم تعديل الإعلان بنجاح',
                    color: Colors.green,
                    msg: '',
                    state: null,
                  );

                  Navigator.pop(context, true);
                }
                if (state is ErrorUpdatePostState) {
                  showToast(
                      message: 'حصل خطأ أثناء التعديل',
                      color: Colors.red,
                      msg: '',
                      state: null);
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
                                name: "تعديل المنشور ",
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
                                  hint: AppText(text: 'fdsgdshnj'),
                                  // hintText:
                                  //     " ...درجة الحرارة المثالية لزراعة الفراولة",
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
                                      print("✅ Button clicked for update");
                                      ASkEngineerCubit.get(context)
                                          .updatePostWithImage(
                                        postId: widget.id,
                                        title: TitelController.text,
                                        description: DetalsController.text,
                                        imageFile:
                                            selectedImage, // ممكن تبعت null لو المستخدم ما اختارش صورة
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
                                          text: "تعديل البوست",
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

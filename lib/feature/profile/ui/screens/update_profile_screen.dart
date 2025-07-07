import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:image_picker/image_picker.dart';
import 'package:reef/core/constants/app_colors.dart';
import 'package:reef/core/helpers/cach_helper.dart';
import 'package:reef/core/helpers/extensions.dart';
import 'package:reef/core/routing/routes.dart';
import 'package:reef/core/widgets/app_text.dart';
import 'package:reef/core/widgets/custom_button.dart';
import 'package:reef/feature/auth/ui/widgets/text_field_widget.dart';
import 'package:reef/feature/profile/logic/cubit/profile_cubit.dart';
import 'package:reef/feature/profile/ui/widgets/posts_manage.dart';

class UpdateProfileScreen extends StatefulWidget {
  const UpdateProfileScreen({super.key});

  @override
  State<UpdateProfileScreen> createState() => _UpdateProfileScreenState();
}

class _UpdateProfileScreenState extends State<UpdateProfileScreen> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final addressController = TextEditingController();
  final areaController = TextEditingController();

  @override
  void initState() {
    super.initState();
    ProfileCubit.get(context).getUser();
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
      body: Padding(
        padding: EdgeInsets.symmetric(vertical: 30.h, horizontal: 16.w),
        child: BlocConsumer<ProfileCubit, ProfileState>(
          listener: (context, state) {
            if (state is ProfileError) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text("خطأ: ${state.message}")));
            }
            if (state is UpdateProfileSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("تم تحديث الملف الشخصي بنجاح")),
              );
              ProfileCubit.get(context).getUser();
              Navigator.pop(context);
            } else if (state is UpdateProfileError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("فشل في التحديث: ${state.message}")),
              );
            }
          },
          builder: (context, state) {
            if (state is ProfileLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is ProfileSuccess) {
              var cubit = ProfileCubit.get(context).getUserModel?.data;
              final user = cubit?.user;
              return user != null
                  ? ListView(
                      children: [
                        // صورة البروفايل
                        Center(
                          child: Stack(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: const Color.fromARGB(
                                        255, 206, 206, 206),
                                    width: 1.w,
                                  ),
                                ),
                                child: CircleAvatar(
                                  backgroundColor: AppColors.bgColor,
                                  radius: 60.r,
                                  backgroundImage: selectedImage != null
                                      ? FileImage(selectedImage!)
                                      : user.profilePhoto != null &&
                                              user.profilePhoto!
                                                  .trim()
                                                  .isNotEmpty
                                          ? NetworkImage(
                                              user.profilePhoto!
                                                      .trim()
                                                      .startsWith('http')
                                                  ? user.profilePhoto!.trim()
                                                  : 'http://82.29.172.199:8001${user.profilePhoto!.trim()}',
                                            )
                                          : null,
                                ),

//http://82.29.172.199:8001${user.profilePhoto}
                              ),
                              Positioned(
                                bottom: 0,
                                left: 0,
                                child: CircleAvatar(
                                  radius: 20.r,
                                  backgroundColor: Color(0xffE1EADB),
                                  child: IconButton(
                                    icon: Icon(
                                      Icons.edit,
                                      size: 20.sp,
                                      color: Colors.black,
                                    ),
                                    onPressed: () {
                                      pickImage();
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Gap(10.h),

                        // // اسم المستخدم
                        // AppText(
                        //   text: user.name,
                        //   fontsize: 16.sp,
                        //   fontWeight: FontWeight.w500,
                        //   textAlign: TextAlign.center,
                        // ),
                        Gap(5.h),

                        // الحقول
                        _profileFields(user.email, user.phone, user.address,
                            user.area, user.name),
                        Gap(10.h),
                      ],
                    )
                  : Center(child: CircularProgressIndicator());
            }

            return const Center(
              child: CircularProgressIndicator(),
            );
          },
        ),
      ),
    );
  }

  // الحقول اللي بتظهر بيانات المستخدم
  Column _profileFields(
    String email,
    String phone,
    String address,
    String area,
    String name,
  ) {
    nameController.text = name;
    emailController.text = email;
    phoneController.text = phone;
    addressController.text = address;
    areaController.text = area;

    return Column(
      children: [
        TextFieldWidget(
          text: 'الاسم',
          controller: nameController,
          star: '',
          hintText: name,
        ),
        Gap(10.h),
        TextFieldWidget(
          text: 'البريد الإلكتروني',
          controller: emailController,
          star: '',
          hintText: email,
        ),
        Gap(10.h),
        TextFieldWidget(
          text: 'رقم الهاتف',
          controller: phoneController,
          star: '',
          hintText: phone,
        ),
        Gap(10.h),
        TextFieldWidget(
          text: 'العنوان',
          controller: addressController,
          star: '',
          hintText: address,
        ),
        Gap(10.h),
        TextFieldWidget(
            text: 'الحي / المنطقة',
            controller: areaController,
            star: '',
            hintText: area),
        Gap(30.h),
        GestureDetector(
          onTap: _submitProfileUpdate, // <-- نضيف هنا استدعاء دالة التحديث
          child: Container(
            height: 50,
            width: 100,
            padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 6.h),
            decoration: BoxDecoration(
              color: const Color(0xff6A994E),
              borderRadius: BorderRadius.circular(5.r),
            ),
            child: Center(
              child: AppText(
                text: 'حفظ',
                color: Colors.white,
                fontsize: 15.sp,
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _submitProfileUpdate() {
    final token = CacheHelper.getData('token').toString();

    context.read<ProfileCubit>().updateProfile(
          name: nameController.text.trim(),
          email: emailController.text.trim(),
          phone: phoneController.text.trim(),
          address: addressController.text.trim(),
          area: areaController.text.trim(),
          token: token,
          imageFile: selectedImage,
        );
  }
}

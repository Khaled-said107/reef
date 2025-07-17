import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:image/image.dart' as img;
import 'package:image_picker/image_picker.dart';
import 'package:reef/core/constants/app_colors.dart';
import 'package:reef/core/helpers/cach_helper.dart';
import 'package:reef/core/helpers/extensions.dart';
import 'package:reef/core/routing/routes.dart';
import 'package:reef/core/widgets/app_text.dart';
import 'package:reef/core/widgets/custom_button.dart';
import 'package:reef/feature/payment/logic/cubit/payment_cubit.dart';
import 'package:reef/feature/payment/ui/widgets/dash_border.dart';

class SendPaymentImgScreen extends StatefulWidget {
  const SendPaymentImgScreen({super.key});

  @override
  State<SendPaymentImgScreen> createState() => _SendPaymentImgScreenState();
}

class _SendPaymentImgScreenState extends State<SendPaymentImgScreen> {
  File? _img;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SafeArea(
          child: ListView(
            children: [
              _logoAndIcon(context),
              _textAndSubText(),
              Gap(40.h),
              _phoneNumber(),
              Gap(60.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 40.w),
                child: AppText(
                  text: 'من فضلك قم برفع صورة إيصال التحويل لتأكيد الاشتراك',
                  fontsize: 16.sp,
                  fontWeight: FontWeight.w500,
                  textAlign: TextAlign.center,
                ),
              ),
              Gap(40.h),
              _pickImage(),
              Gap(70.h),
              BlocConsumer<PaymentCubit, PaymentState>(
                listener: (context, state) {
                  if (state is PaymentPost) {
                    context.pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('تم الرفع بنجاح')),
                    );
                  }
                  if (state is PaymentError) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(state.error)),
                    );
                  }
                },
                builder: (context, state) {
                  if (state is PaymentLoding) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  return _button(context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Padding _button(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.w),
      child: CustomButton(
        text: 'إرسال الإيصال',
        onPressed: () {
          final token = CacheHelper.getData('token')?.toString();
          if (_img != null && token != null) {
            context.read<PaymentCubit>().PostPayment(
                  img: _img!,
                  token: token,
                );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('من فضلك اختر صورة الإيصال')),
            );
          }
        },
      ),
    );
  }

  Center _phoneNumber() => Center(
        child: AppText(
          text: '01091944770',
          fontsize: 24.sp,
          fontWeight: FontWeight.w700,
          color: AppColors.primary,
        ),
      );

  Column _textAndSubText() {
    return Column(
      children: [
        Center(
          child: AppText(
            text: 'طريقة الدفع والاشتراك',
            fontsize: 16.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
        Gap(10.h),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 15.w),
          child: Center(
            child: AppText(
              text:
                  'لإتمام الاشتراك، قم بتحويل مبلغ 45 جنيه عبر Vodafone Cash أو InstaPay إلى الرقم الموضح أدناه',
              fontsize: 12.sp,
              fontWeight: FontWeight.w500,
              color: const Color(0xff7c7c7c),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ],
    );
  }

  Padding _pickImage() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 50.w),
      child: DashedBorder(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(10.r),
        strokeWidth: 3.w,
        dashWidth: 4.w,
        dashSpace: 3.w,
        child: GestureDetector(
          onTap: () async {
            final ImagePicker picker = ImagePicker();
            final pickedImg =
                await picker.pickImage(source: ImageSource.gallery);

            if (pickedImg != null) {
              final originalFile = File(pickedImg.path);
              final bytes = await originalFile.readAsBytes();
              final decodedImage = img.decodeImage(bytes);

              if (decodedImage != null) {
                final jpgBytes = img.encodeJpg(decodedImage, quality: 90);

                final newPath =
                    '${originalFile.parent.path}/converted_image.jpg';
                final newFile = await File(newPath).writeAsBytes(jpgBytes);

                setState(() {
                  _img = newFile;
                });
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('فشل في تحويل الصورة.')),
                );
              }
            }
          },
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 40.w),
            height: 150.h,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.r),
              color: const Color.fromARGB(255, 248, 246, 242),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _img == null
                      ? Image.asset(
                          'assets/images/pickImg.png',
                          width: 110.w,
                          height: 30.h,
                        )
                      : Image.file(
                          _img!,
                          width: 100.w,
                          height: 100.h,
                          fit: BoxFit.cover,
                        ),
                  Gap(15.h),
                  AppText(
                    text: _img == null
                        ? 'رفع صورة الايصال'
                        : 'تم اختيار الصورة بنجاح',
                    fontsize: 12.sp,
                    fontWeight: FontWeight.w500,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Padding _logoAndIcon(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const SizedBox(),
          Image.asset(
            'assets/images/logo.png',
            height: 105.h,
            width: 105.w,
          ),
          InkWell(
            onTap: () {
              context.pop();
            },
            child: SvgPicture.asset(
              'assets/images/backIcon.svg',
              height: 20.h,
              width: 20.w,
            ),
          ),
        ],
      ),
    );
  }
}

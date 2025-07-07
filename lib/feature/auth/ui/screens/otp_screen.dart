import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:reef/core/constants/app_colors.dart';
import 'package:reef/core/helpers/extensions.dart';
import 'package:reef/core/routing/routes.dart';
import 'package:reef/core/widgets/app_text.dart';
import 'package:reef/core/widgets/custom_button.dart';
import 'package:reef/core/widgets/logo_and_texts.dart';
import 'package:reef/feature/auth/logic/auth_cubit/auth_cubit.dart';
import 'package:reef/feature/auth/logic/auth_cubit/auth_state.dart';
import 'package:reef/feature/auth/ui/widgets/otp_field.dart';

class OtpScreen extends StatefulWidget {
  OtpScreen({super.key});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final TextEditingController otpController = TextEditingController();

  bool isLoading = false;

  void _verifyOtp() async {
    setState(() {
      isLoading = true;
    });
    await Future.delayed(const Duration(seconds: 3));

    setState(() {
      isLoading = false;
    });
    context.pushReplacementNamed(Routes.resetPassword);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthCubit(),
      child: Scaffold(
        body: Padding(
          padding: EdgeInsets.only(left: 20.w, right: 20.w, bottom: 20.h),
          child: ListView(
            children: [
              LogoAndTexts(
                text: 'ادخل رمز اتحقق',
                desc: 'تم إرسال رمز التحقق إلى رقمك +20 10XXXXXXX',
              ),
              OtpField(textEditingController: otpController),
              Gap(30.h),
              BlocConsumer<AuthCubit, AuthState>(
                listener: (context, state) {
                  if (state is VerifyTokenSuccess) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('تم التحقق بنجاح')),
                    );
                    context.pushReplacementNamed(Routes.resetPassword);
                  } else if (state is VerifyTokenError) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(state.error)),
                    );
                  }
                },
                builder: (context, state) {
                  if (state is VerifyTokenLoading) {
                    return Center(child: CircularProgressIndicator());
                  }
                  return CustomButton(
                    text: 'تحقق الآن',
                    bgColor:
                        isLoading
                            ? AppColors.primary.withOpacity(0.3)
                            : AppColors.primary,
                    onPressed: () {
                      isLoading ? null : _verifyOtp();
                      final otp = otpController.text;
                      AuthCubit.get(context).verfiyOtp(
                        otp: otp,
                      );
                    },
                  );
                },
              ),
              Gap(10.h),
              InkWell(
                onTap: () {
                  // Resend OTP logic here
                },
                child: Center(
                  child: AppText(
                    text: 'إعادة إرسال الرمز',
                    color: AppColors.primary,
                    fontsize: 14.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

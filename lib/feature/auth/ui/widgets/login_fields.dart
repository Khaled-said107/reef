import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:reef/core/constants/app_colors.dart';
import 'package:reef/core/helpers/cach_helper.dart';
import 'package:reef/core/helpers/extensions.dart';
import 'package:reef/core/routing/routes.dart';
import 'package:reef/core/widgets/app_text.dart';
import 'package:reef/core/widgets/custom_button.dart';
import 'package:reef/core/widgets/logo_and_texts.dart';
import 'package:reef/feature/auth/logic/auth_cubit/auth_cubit.dart';
import 'package:reef/feature/auth/logic/auth_cubit/auth_state.dart';
import 'package:reef/feature/auth/ui/widgets/or_widget.dart';
import 'package:reef/feature/auth/ui/widgets/signin_google.dart';
import 'package:reef/feature/auth/ui/widgets/text_field_widget.dart';

class LoginFields extends StatefulWidget {
  LoginFields({super.key});

  @override
  State<LoginFields> createState() => _LoginFieldsState();
}

class _LoginFieldsState extends State<LoginFields> {
  bool isObscure = true;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthSuccess) {
          if (state.model.message == 'Our team will contact you.') {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('سوف يتم التواصل معك')),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('تم تسجيل الدخول بنجاح')),
            );
          }

          if (state.model.status == "success") {
            print(state.model.data.token);
            CacheHelper.saveData(key: 'token', value: state.model.data.token);
            CacheHelper.saveData(
                key: 'role', value: state.model.data.user.role!);
            context.pushNamedAndRemoveUntil(Routes.navbar,
                predicate: (Route<dynamic> route) => false);
          }
        } else if (state is AuthError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.error)),
          );
        } else {}
      },
      builder: (context, state) {
        return Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              LogoAndTexts(
                text: 'مرحبًا بعودتك',
                desc: 'يسعدنا رؤيتك مجددًا. قم بتسجيل الدخول للمتابعة',
              ),
              Gap(10.h),
              TextFieldWidget(
                controller: emailController,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'الرجاء إدخال البريد الإلكتروني';
                  }
                  return null;
                },
                text: 'البريد الالكتروني',
                hintText: 'البريد الالكتروني',
                star: '*',
              ),
              Gap(12.h),
              TextFieldWidget(
                controller: passwordController,
                obscureText: isObscure,
                icon: InkWell(
                  onTap: () {
                    setState(() {
                      isObscure = !isObscure;
                    });
                  },
                  child: isObscure
                      ? Icon(Icons.visibility_off, size: 20.sp)
                      : Icon(Icons.visibility, size: 20.sp),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'الرجاء إدخال كلمة المرور';
                  }
                  return null;
                },
                text: 'كلمة المرور',
                hintText: 'كلمة المرور',
                star: '*',
              ),
              Gap(5.h),
              InkWell(
                onTap: () {
                  context.pushNamed(Routes.forgetPassword);
                },
                child: AppText(
                  textAlign: TextAlign.end,
                  text: 'نسيت كلمة المرور؟',
                  fontsize: 15.sp,
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Gap(20.h),
              CustomButton(
                text: state is AuthLoading
                    ? 'جاري تسجيل الدخول...'
                    : 'تسجيل الدخول',
                onPressed: () {
                  if (formKey.currentState!.validate()) {
                    AuthCubit.get(context).login(
                      email: emailController.text.trim(),
                      password: passwordController.text.trim(),
                    );
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }
}

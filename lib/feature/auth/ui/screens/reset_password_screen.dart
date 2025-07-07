import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:reef/core/helpers/extensions.dart';
import 'package:reef/core/routing/routes.dart';
import 'package:reef/core/widgets/custom_button.dart';
import 'package:reef/core/widgets/logo_and_texts.dart';
import 'package:reef/feature/auth/logic/auth_cubit/auth_cubit.dart';
import 'package:reef/feature/auth/logic/auth_cubit/auth_state.dart';
import 'package:reef/feature/auth/ui/widgets/text_field_widget.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

final GlobalKey<FormState> formKey = GlobalKey<FormState>();
final TextEditingController passwordController = TextEditingController();
final TextEditingController confirmPasswordController = TextEditingController();

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  bool isObscure = true;

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
                text: 'إعادة تعيين كلمة المرور',
                desc:
                    'اكتب كلمة مرور جديدة لحسابك، وتأكد إنها قوية وسهلة تتذكرها',
              ),
              Gap(25.h),
              BlocConsumer<AuthCubit, AuthState>(
                listener: (context, state) {
                  if (state is ResetPasswordSuccess) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('تم إعادة تعيين كلمة المرور بنجاح')),
                    );
                    context.pushReplacementNamed(
                              Routes.confirmPassword,
                            );
                  } else if (state is AuthError) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(state.error)),
                    );
                  }
                },
                builder: (context, state) {

                  return Form(
                    key: formKey,
                    child: Column(
                      children: [
                        TextFieldWidget(
                          controller: passwordController,
                          obscureText: isObscure,
                          icon: InkWell(
                            onTap: () {
                              setState(() {
                                isObscure = !isObscure;
                              });
                            },
                            child:
                                isObscure
                                    ? Icon(Icons.visibility_off, size: 20.sp)
                                    : Icon(Icons.visibility, size: 20.sp),
                          ),
                          text: 'كلمة المرور الجديدة',
                          hintText: '********',
                          star: '*',
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'كلمة المرور مطلوبة';
                            }
                            if (value.length < 6) {
                              return 'يجب أن تكون كلمة المرور 6 أحرف على الأقل';
                            }
                            return null;
                          },
                        ),
                        Gap(10.h),
                        TextFieldWidget(
                          controller: confirmPasswordController,
                          obscureText: isObscure,
                          icon: InkWell(
                            onTap: () {
                              setState(() {
                                isObscure = !isObscure;
                              });
                            },
                            child:
                                isObscure
                                    ? Icon(Icons.visibility_off, size: 20.sp)
                                    : Icon(Icons.visibility, size: 20.sp),
                          ),
                          text: 'تأكيد كلمة المرور الجديدة',
                          hintText: '********',
                          star: '*',
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'تأكيد كلمة المرور مطلوب';
                            }
                            if (value != passwordController.text) {
                              return 'كلمة المرور غير متطابقة';
                            }
                            return null;
                          },
                        ),
                        Gap(30.h),
                        state is ResetPasswordLoading
                            ? Center(child: CircularProgressIndicator())
                            : CustomButton(
                          text: 'تاكيد',
                          onPressed: () {
                            if (formKey.currentState!.validate()) {
                              final password = passwordController.text;
                              final confirmPassword =
                                  confirmPasswordController.text;
                              AuthCubit.get(context).resetPassword(
                                password: password,
                                confirmPassword: confirmPassword,
                              );
                            }
                          },
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

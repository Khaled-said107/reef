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
import 'package:reef/feature/auth/ui/widgets/text_footer.dart';

class ForgetPasswordScreen extends StatelessWidget {
  ForgetPasswordScreen({super.key});
  final TextEditingController emailController = TextEditingController();
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
                text: 'هل نسيت كلمة المرور؟',
                desc: 'أدخل بريدك الألكتروني أدناه لاعادة تعيين كلمة المرور',
              ),
              Gap(25.h),
              TextFieldWidget(
                text: 'البريد الألكتروني/ رقم الهاتف',
                hintText: '01XXXXXXXXX  /  example@email.com',
                star: '*',
                controller: emailController,
              ),
              Gap(30.h),
              BlocConsumer<AuthCubit, AuthState>(
                listener: (context, state) {
                  if (state is AuthSuccessMessage) {
                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(SnackBar(content: Text(state.message)));
                    Navigator.pushNamed(context, Routes.otp);
                  } else if (state is AuthError) {
                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(SnackBar(content: Text(state.error)));
                  }
                },
                builder: (context, state) {
                  if (state is AuthLoading) {
                    return CircularProgressIndicator();
                  }
                  return CustomButton(
                    text: 'إرسال رمز التحقق',
                    onPressed: () {
                      final email = emailController.text;
                      AuthCubit.get(context).forgetPassword(email: email);
                    },
                  );
                },
              ),
              Gap(10.h),
              TextFooter(
                text1: 'سجّل الدخول',
                text2: 'هل تذكرت كلمة المرور؟  ',
                onPressed: () {
                  context.pushNamed(Routes.login);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

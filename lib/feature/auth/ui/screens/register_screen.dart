import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:reef/core/helpers/extensions.dart';
import 'package:reef/core/routing/routes.dart';
import 'package:reef/core/widgets/logo_and_texts.dart';
import 'package:reef/feature/auth/logic/auth_cubit/auth_cubit.dart';
import 'package:reef/feature/auth/ui/widgets/register_fields.dart';
import 'package:reef/feature/auth/ui/widgets/text_footer.dart';

class RegisterScreen extends StatefulWidget {
  RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (context) => AuthCubit(),
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.only(left: 20.w, right: 20.w, bottom: 20.h),
            child: Center(
              child: Form(
                key: formKey,
                child: ListView(
                  children: [
                    LogoAndTexts(
                      text: 'خطوتك الأولى لعالم ريف',
                      desc:
                          'أنشئ حسابك للبدء في بيع وشراء المنتجات الريفية بسهولة',
                    ),
                    RegisterFields(),
                    Gap(18.h),
                    Center(
                      child: TextFooter(
                        text1: 'تسجيل الدخول',
                        text2: 'هل لديك حساب بالفعل؟',
                        onPressed: () {
                          context.pushNamedAndRemoveUntil(
                            Routes.login,
                            predicate: (Route<dynamic> route) => false,
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

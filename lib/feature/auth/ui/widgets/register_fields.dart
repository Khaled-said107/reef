import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:reef/core/helpers/cach_helper.dart';
import 'package:reef/core/helpers/extensions.dart';
import 'package:reef/core/routing/routes.dart';
import 'package:reef/core/widgets/app_text.dart';
import 'package:reef/core/widgets/custom_button.dart';
import 'package:reef/feature/auth/logic/auth_cubit/auth_cubit.dart';
import 'package:reef/feature/auth/logic/auth_cubit/auth_state.dart';
import 'package:reef/feature/auth/ui/widgets/text_field_widget.dart';
import 'package:reef/feature/navbar/logic/navbar.dart';

import '../screens/login_screen.dart';

class RegisterFields extends StatefulWidget {
  RegisterFields({super.key});

  @override
  State<RegisterFields> createState() => _RegisterFieldsState();
}

class _RegisterFieldsState extends State<RegisterFields> {
  bool isObscure = true;
  bool isObscuree = true;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController areaController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  bool isUser = false;
  bool isEngineer = false;
  bool isDriver = false;

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    phoneController.dispose();
    addressController.dispose();
    areaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthSuccess) {
          final role = state.model.data.user.role ?? '';
          CacheHelper.saveData(key: 'token', value: state.model.data.token);
          print(CacheHelper.getData('token'));
          if (state.model.data.user.role != null) {
            CacheHelper.saveData(
                key: 'role', value: state.model.data.user.role!);
          } else {
            // طباعة أو معالجة الخطأ بطريقة مناسبة
            debugPrint('User role is null');
          }
          print(role);
          print("تم استلام التوكن: ${state.model.data.token}");

          if (role == 'user') {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => NavbarWidget(role: role)),
            );
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text('تم إنشاء الحساب بنجاح')));
          } else {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => NavbarWidget(role: role),
              ),
              (route) => false,
            );
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(
                content:
                    Text('تم إنشاء الحساب بنجاح , سيتم التواصل معك قريبا')));
          }

          CacheHelper.saveData(key: 'role', value: role);
        } else if (state is AuthError) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.error)));
        }
      },
      builder: (context, state) {
        return Form(
          key: formKey,
          child: Column(
            children: [
              TextFieldWidget(
                controller: nameController,
                text: 'الاسم كامل ',
                hintText: ' اكتب الاسم كامل',
                star: '*',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'الاسم مطلوب';
                  }
                  return null;
                },
              ),
              Gap(12.h),
              TextFieldWidget(
                controller: emailController,
                text: 'البريد الألكتروني',
                hintText: 'example@email.com',
                star: '*',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'البريد مطلوب';
                  }
                  return null;
                },
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
                text: ' كلمة المرور',
                hintText: '•••••••••',
                star: '*',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'كلمة المرور مطلوبة';
                  }
                  return null;
                },
              ),
              Gap(12.h),
              TextFieldWidget(
                controller: confirmPasswordController,
                obscureText: isObscuree,
                icon: InkWell(
                  onTap: () {
                    setState(() {
                      isObscuree = !isObscuree;
                    });
                  },
                  child: isObscuree
                      ? Icon(Icons.visibility_off, size: 20.sp)
                      : Icon(Icons.visibility, size: 20.sp),
                ),
                text: 'تاكيد كلمة المرور',
                hintText: '•••••••••',
                star: '*',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'كلمة المرور مطلوبة';
                  }
                  return null;
                },
              ),
              Gap(12.h),
              TextFieldWidget(
                controller: phoneController,
                text: 'رقم الهاتف',
                hintText: '01XXXXXXXXX',
                star: '*',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'رقم الهاتف مطلوب';
                  }
                  return null;
                },
              ),
              Gap(12.h),
              TextFieldWidget(
                controller: addressController,
                text: 'العنوان بالكامل',
                hintText: 'الشارع، رقم المنزل، المدينة',
                star: '*',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'العنوان مطلوب';
                  }
                  return null;
                },
              ),
              Gap(12.h),
              TextFieldWidget(
                controller: areaController,
                text: 'الحي / المنطقة',
                hintText: 'حي الزهور - مركز كفر الدوار',
                star: '*',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'الحي مطلوب';
                  }
                  return null;
                },
              ),
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      AppText(text: 'مستخدم عادي (بائع / مشتري)'),
                      Checkbox(
                        value: isUser,
                        onChanged: (value) {
                          setState(() {
                            isUser = value!;
                            if (isUser) {
                              isEngineer = false;
                              isDriver = false;
                            }
                            ;
                          });
                        },
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      AppText(text: 'مهندس زراعي'),
                      Checkbox(
                        value: isEngineer,
                        onChanged: (value) {
                          setState(() {
                            isEngineer = value!;
                            if (isEngineer) {
                              isUser = false;
                              isDriver = false;
                            }
                            ;
                          });
                        },
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      AppText(text: 'سائق نقل'),
                      Checkbox(
                        value: isDriver,
                        onChanged: (value) {
                          setState(() {
                            isDriver = value!;
                            if (isDriver) {
                              isUser = false;
                              isEngineer = false;
                            }
                          });
                        },
                      ),
                    ],
                  ),
                ],
              ),
              Gap(20.h),
              CustomButton(
                text: state is AuthLoading ? 'جاري التسجيل...' : 'إنشاء حساب',
                onPressed: () {
                  if (formKey.currentState!.validate()) {
                    String role = '';
                    if (isUser) {
                      role = 'user';
                    } else if (isEngineer) {
                      role = 'engineer';
                    } else if (isDriver) {
                      role = 'driver';
                    } else {
                      '';
                    }
                    ;
                    if (role.isEmpty) {
                      // اعمل showToast أو رسالة خطأ
                      print('يجب اختيار نوع الحساب');
                      return;
                    }
                    print(nameController.text);
                    print(emailController.text);
                    print(phoneController.text);
                    print(passwordController.text);
                    print(confirmPasswordController.text);
                    print(addressController.text);
                    print(nameController.text);
                    print(areaController.text);
                    print(role);
                    AuthCubit.get(context).register(
                      name: nameController.text,
                      email: emailController.text,
                      phone: phoneController.text,
                      password: passwordController.text,
                      confirmPassword: confirmPasswordController.text,
                      address: addressController.text,
                      area: areaController.text,
                      role: role,
                    );
                    print(role);
                  }
                  CacheHelper.saveData(
                      key: 'address', value: addressController.text);
                  print(CacheHelper.getData(
                    'address',
                  ));
                },
              ),
            ],
          ),
        );
      },
    );
  }
}

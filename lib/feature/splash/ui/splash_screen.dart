import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:reef/core/helpers/cach_helper.dart';
import 'package:reef/core/helpers/extensions.dart';
import 'package:reef/core/routing/routes.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
 
  
  @override
  void initState() { 
    super.initState();
    _checkIfOnboardingSeen();
  }
  void _checkIfOnboardingSeen() async {
  final prefs = await SharedPreferences.getInstance();
final seenOnboarding = CacheHelper.getBool('complete_onBoarding') ?? false;
  final token = CacheHelper.getData('token');

  await Future.delayed(Duration(seconds: 3)); 
  if (token != null && token.isNotEmpty) {
    // المستخدم مسجل دخول
    context.pushReplacementNamed(Routes.navbar); // روح عالهوم
  } else if (seenOnboarding) {
    context.pushReplacementNamed(Routes.login); // أو اللوجين حسب اللي عندك
  } else {
    context.pushReplacementNamed(Routes.onboarding); // أول مرة يفتح
  }
  }
  Widget build(BuildContext context) {
    return Scaffold(
     backgroundColor: Color(0xFFEFEAD8),
      body: Center(
        child: Image.asset(
          'assets/images/logo.png',
          width: 250.w,
          height: 250.h,
        ),
      ),
    );
  }
}

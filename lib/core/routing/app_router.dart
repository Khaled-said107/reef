import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reef/feature/askEngineer/ui/screens/ask_engineer_screen.dart';
import 'package:reef/feature/auth/ui/screens/confirm_password_screen.dart';
import 'package:reef/feature/auth/ui/screens/forget_password_screen.dart';
import 'package:reef/feature/auth/ui/screens/login_screen.dart';
import 'package:reef/feature/auth/ui/screens/otp_screen.dart';
import 'package:reef/feature/auth/ui/screens/register_screen.dart';
import 'package:reef/feature/auth/ui/screens/reset_password_screen.dart';
import 'package:reef/feature/categories/data/post_model.dart';
import 'package:reef/feature/categories/logic/cubit/category_cubit.dart';
import 'package:reef/feature/categories/ui/screens/categories_screen.dart';
import 'package:reef/feature/categories/ui/screens/category_post_screen.dart';
import 'package:reef/feature/categories/ui/screens/sub_category_screen.dart';
import 'package:reef/feature/create_post/ui/screens/create_post_screen.dart';
import 'package:reef/feature/home/ui/screens/home_screen.dart';
import 'package:reef/feature/my_posts/ui/screens/edit_post_screen.dart';
import 'package:reef/feature/my_posts/ui/screens/my_posts_screen.dart';
import 'package:reef/feature/navbar/logic/navbar.dart';
import 'package:reef/feature/onboarding/ui/onboarding_screen.dart';
import 'package:reef/feature/payment/ui/screens/confirm_payment_screen.dart';
import 'package:reef/feature/payment/ui/screens/payment_screen.dart';
import 'package:reef/feature/payment/ui/screens/send_payment_img_screen.dart';
import 'package:reef/feature/product/ui/screens/product_screen.dart';
import 'package:reef/feature/profile/ui/screens/profile_screen.dart';
import 'package:reef/feature/splash/ui/splash_screen.dart';
import 'package:reef/feature/truck/ui/screen/AddCarScreen.dart';
import 'package:reef/feature/truck/ui/screen/truks_screen.dart';

import '../../feature/askEngineer/ui/screens/engineer_AddPost.dart';

import '../../feature/my_posts/ui/screens/detals_MyPosts_screen.dart';
import '../../feature/profile/ui/screens/help_Screen.dart';
import '../../feature/truck/data/DriversResponseModel.dart';
import '../../feature/truck/ui/screen/TruckDetailsScreen.dart';

class AppRouter {
  Route generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => SplashScreen());
      case '/onboarding':
        return MaterialPageRoute(builder: (_) => const OnboardingScreen());
      case '/register':
        return MaterialPageRoute(builder: (_) => RegisterScreen());
      case '/login':
        return MaterialPageRoute(builder: (_) => LoginScreen());
      case '/forgetPassword':
        return MaterialPageRoute(builder: (_) => ForgetPasswordScreen());
      case '/otp':
        return MaterialPageRoute(builder: (_) => OtpScreen());
      case '/resetPassword':
        return MaterialPageRoute(builder: (_) => ResetPasswordScreen());
      case '/confirmPassword':
        return MaterialPageRoute(builder: (_) => ConfirmPasswordScreen());
      case '/navbar':
        return MaterialPageRoute(
            builder: (_) => NavbarWidget(
                  role: '',
                ));
      case '/home':
        return MaterialPageRoute(builder: (_) => HomeScreen());
      case '/categories':
        return MaterialPageRoute(builder: (_) => CategoriesScreen());
      case '/createPost':
        return MaterialPageRoute(builder: (_) => CreatePostScreen());
      case '/myPosts':
        return MaterialPageRoute(builder: (_) => MyPostsScreen());
      case '/profile':
        return MaterialPageRoute(builder: (_) => ProfileScreen());
      case '/product':
        final postId = settings.arguments as String;
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => CategoryCubit()..getSinglePost(postId),
            child: ProductScreen(postId: postId),
          ),
        );
      // case '/editPost':
      //   return MaterialPageRoute(builder: (_) => EditPostScreen());
      //
      //
      //
      //   case '/DetalsMyPosts':
      //   return MaterialPageRoute(builder: (_) => DetalsMyPosts());

      case '/HelpScreen':
        return MaterialPageRoute(builder: (_) => HelpScreen());

      case '/EngineerAddPost':
        return MaterialPageRoute(builder: (_) => EngineerAddPost());

      case '/sendPaymentImgScreen':
        return MaterialPageRoute(builder: (_) => SendPaymentImgScreen());
      case '/confirmPaymentScreen':
        return MaterialPageRoute(builder: (_) => ConfirmPaymentScreen());
      case '/paymentScreen':
        return MaterialPageRoute(builder: (_) => PaymentScreen());
      // case '/subCategories':
      //   return MaterialPageRoute(builder: (_) => SubCategoryScreen(
      //   ));
      case '/askEngineerScreen':
        return MaterialPageRoute(builder: (_) => AskEngineerScreen());
      case '/trucksScreen':
        return MaterialPageRoute(builder: (_) => TrucksScreen());
      case '/addCar':
        return MaterialPageRoute(builder: (_) => AddCarScreen());
      case '/truckDetailsScreen':
        final driver = settings.arguments as DriverModel;
        return MaterialPageRoute(
          builder: (_) => TruckDetailsScreen(driver: driver),
        );
      case '/categoryPostScreen':
        final args = settings.arguments as Map<String, String>; // ✅ صح
        return MaterialPageRoute(
          builder: (_) => CategoryPostScreen(
            categoryId: args['categoryId'] ?? '',
            categoryName: args['categoryName'] ?? '',
          ),
        );
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          ),
        );
    }
  }
}

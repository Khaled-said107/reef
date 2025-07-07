import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:reef/core/constants/app_colors.dart';
import 'package:reef/core/helpers/cach_helper.dart';
import 'package:reef/core/network/dio_helper.dart';
import 'package:reef/core/routing/app_router.dart';
import 'package:reef/core/routing/routes.dart';
import 'package:reef/feature/categories/logic/cubit/category_cubit.dart';
import 'package:reef/feature/create_post/logic/cubit/create_post_cubit.dart';
import 'package:reef/feature/my_posts/logic/MyPost_cubit/my_post_cubit.dart';
import 'package:reef/feature/payment/logic/cubit/payment_cubit.dart';

import 'core/network/share/bloc_observer.dart';
import 'feature/askEngineer/logic/cubit/ask_engineer_cubit.dart';
import 'feature/categories/logic/cubit/get_all_posts_cubit/get_all_posts_cubit.dart';
import 'feature/my_posts/logic/UpdateMyPost_Cubit/update_my_post_cubit.dart';
import 'feature/profile/logic/cubit/profile_cubit.dart';
import 'feature/truck/logic/dreiver_cubit.dart';

void main() async {
  Bloc.observer = const SimpleBlocObserver();

  WidgetsFlutterBinding.ensureInitialized();
  DioHelper.init();
  await CacheHelper.init();
  runApp(MainApp(appRouter: AppRouter()));
}

class MainApp extends StatelessWidget {
  final AppRouter appRouter;
  const MainApp({super.key, required this.appRouter});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      //designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,

      builder: (context, child) => MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => CategoryCubit()
              ..getCategories()
              ..fetchCategoriesWithPosts(),
          ),
          BlocProvider(create: (context) => CreatePostCubit()),
          BlocProvider(create: (context) => MyPostCubit()),
          BlocProvider(
            create: (context) => UpdateMyPostCubit(),
          ),
          BlocProvider(create: (context) => GetAllPostsCubit()),
          BlocProvider(create: (context) => DriverCubit()),
          BlocProvider(create: (context) => ASkEngineerCubit()),
          BlocProvider(create: (context) => PaymentCubit()),
          BlocProvider(create: (context) => ProfileCubit()..getUser()),
        ],
        child: MaterialApp(
          title: 'Reef',
          theme: ThemeData(
            primaryColor: AppColors.primary,
            scaffoldBackgroundColor: AppColors.bgColor,
            fontFamily: 'Poppins',
          ),
          debugShowCheckedModeBanner: false,
          onGenerateRoute: appRouter.generateRoute,
          initialRoute: Routes.splash,
          builder: (context, widget) {
            return MediaQuery(
              data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
              child: widget!,
            );
          },
        ),
      ),
    );
  }
}

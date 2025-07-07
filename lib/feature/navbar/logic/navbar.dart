import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reef/core/helpers/cach_helper.dart';
import 'package:reef/feature/askEngineer/ui/screens/engineer_AddPost.dart';
import 'package:reef/feature/categories/logic/cubit/category_cubit.dart';
import 'package:reef/feature/categories/ui/screens/categories_screen.dart';
import 'package:reef/feature/create_post/ui/screens/create_post_screen.dart';
import 'package:reef/feature/home/ui/screens/home_screen.dart';
import 'package:reef/feature/my_posts/ui/screens/my_posts_screen.dart';
import 'package:reef/feature/navbar/widgets/custom_nav_bar.dart';
import 'package:reef/feature/optinoal_role/optional_category.dart';
import 'package:reef/feature/profile/ui/screens/profile_screen.dart';

import '../../askEngineer/logic/cubit/ask_engineer_cubit.dart';
import '../../my_posts/logic/MyPost_cubit/my_post_cubit.dart';
import '../../optinoal_role/ui/optional_role.dart';
import '../../profile/logic/cubit/profile_cubit.dart';

class NavbarWidget extends StatefulWidget {
  NavbarWidget({Key? key, required this.role}) : super(key: key);

  final String role;

  @override
  State<NavbarWidget> createState() => _NavbarWidgetState();
}

class _NavbarWidgetState extends State<NavbarWidget> {
  int _currentIndex = 4;

  final List<Widget> _screens = [
    ProfileScreen(),
    MyPostsScreen(),
    OptionalRoleScreen(
      role: CacheHelper.getData('role')!,
    ),
    OptionalCategory(
      role: CacheHelper.getData('role')!,
    ),
    HomeScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: _screens),
      bottomNavigationBar: CustomNavBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          print(CacheHelper.getData('role'));
          var role = CacheHelper.getData('role');
          if (index == 0) {
            ProfileCubit.get(context).getUser();
          }
          if (index == 1) {
            MyPostCubit.get(context).getMyPosts();
            ASkEngineerCubit.get(context).getAllAds();
          }
          if (index == 4) {
            CategoryCubit.get(context).getCategories();
          }
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}

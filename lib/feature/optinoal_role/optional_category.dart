import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:reef/core/widgets/custom_feild.dart';
import 'package:reef/core/widgets/header.dart';
import 'package:reef/feature/categories/ui/screens/categories_screen.dart';
import 'package:reef/feature/truck/ui/screen/truks_screen.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/app_text.dart';

class OptionalCategory extends StatefulWidget {
  final String role;
  const OptionalCategory({super.key, required this.role});

  @override
  State<OptionalCategory> createState() => _OptionalCategoryState();
}

class _OptionalCategoryState extends State<OptionalCategory> {
  @override
  Widget build(BuildContext context) {
//user createPost
//eng add_eng_post
//driver add_car
    if (widget.role == 'driver') {
      return TrucksScreen();
    } else if (widget.role == 'user') {
      return CategoriesScreen();
    } else {
      return CategoriesScreen();
    }
  }
}

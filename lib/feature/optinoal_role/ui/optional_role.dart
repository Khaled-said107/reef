import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:reef/core/widgets/custom_feild.dart';
import 'package:reef/core/widgets/header.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/app_text.dart';
import '../../askEngineer/ui/screens/engineer_AddPost.dart';
import '../../create_post/ui/screens/create_post_screen.dart';
import '../../truck/ui/screen/AddCarScreen.dart';

class OptionalRoleScreen extends StatefulWidget {
  final String role;
  const OptionalRoleScreen({super.key,required this.role});

  @override
  State<OptionalRoleScreen> createState() => _OptionalRoleScreenState();
}

class _OptionalRoleScreenState extends State<OptionalRoleScreen> {

  @override
  Widget build(BuildContext context) {

//user createPost
//eng add_eng_post
//driver add_car
    if(widget.role=='driver'){
      return AddCarScreen();
    }else if(widget.role=='engineer'){
      return EngineerAddPost();
    } else{
      return CreatePostScreen();
    }
  }


}

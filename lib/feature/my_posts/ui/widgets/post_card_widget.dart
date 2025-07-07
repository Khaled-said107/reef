import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:reef/core/constants/app_colors.dart';
import 'package:reef/core/helpers/extensions.dart';
import 'package:reef/core/routing/routes.dart';
import 'package:reef/core/widgets/app_text.dart';

import '../../data/Model/MyPost_Model.dart';
import '../screens/detals_MyPosts_screen.dart';
import '../screens/edit_post_screen.dart';

class PostCard extends StatelessWidget {
  final Post post;
  const PostCard({
    super.key,
    required this.post
  });


  @override
  Widget build(BuildContext context) {
    return  Container(
        height: 231.h,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Color(0xffFFFEF8),
          border: Border.all(
            width: 1,
            color: Color(0xffEFEAD8),
          ),borderRadius: BorderRadius.circular(10.r)
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            GestureDetector(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=>DetalsMyPosts(
                  post: post,
                )));
              },
                child: Image(image: NetworkImage( 'http://82.29.172.199:8001${post.images[0]}'), height: 110.h,width: double.infinity,fit: BoxFit.contain,)),
            Padding(
              padding:  EdgeInsets.symmetric(
                vertical: 12.h,
                horizontal: 12.w
              ),
              child: Row(
                children: [
                      Column(
                        children: [
                          AppText(text:
                          '${post.price}  جنيه ', fontsize: 13.sp,fontWeight: FontWeight.w700,),
                          SizedBox(
                            height: 5,
                          ),
                          Container(
                            width: 50,
                            height: 20,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: post.accept?Colors.green:Colors.red,

                            ),
                            child: Center(child: Text(post.accept?'تم القبول':'قيد المراجعه',style: TextStyle(fontSize: 8,color: Colors.white),)),
                          ),
                        ],
                      ),
                      Spacer(),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      AppText(text: 
                      post.name, fontsize: 12.sp,fontWeight: FontWeight.w500,),
                      Gap(5.h),
                      AppText(text: 
                    post.description, fontsize: 7.sp,fontWeight: FontWeight.w500,color: Color(0xff7c7c7c),)
                    ],
                  ),
                ],
              ),
            ),
         Divider(
          color: Color(0xffEFEAD8),
         ),
         Padding(
           padding: EdgeInsets.symmetric(
                vertical: 5.h,
                horizontal: 12.w
              ),
           child: Row(
            children: [

              InkWell(
                onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => EditPostScreen(Postid: post.id,post: post,),));
                },
               child: Container(
                width: 72.w,
                height: 28.h,

                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.r),
                  color: AppColors.primary
                ),
                         child: Center(
                           child: AppText(text: 'تعديل',color: AppColors.white,fontsize: 10.sp,),
                         ),
                           ),
             ),


                Spacer(),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
            children: [
               AppText(text: 
                        'تاريخ النشر:  ${post.createdAt.split('T').first}', fontsize: 8.sp,fontWeight: FontWeight.w500,color: Color(0xff7c7c7c),),
                          Gap(5.w),
                       
                        Row(
                          children: [
                            AppText(text: 
                            '${post.views}  مشاهدة', fontsize: 7.sp,fontWeight: FontWeight.w500,),
                            Gap(3.w),
                            Image.asset('assets/images/eye.png',height: 5.5.h,width: 8.5.w,),
                          ],
                        )
            ],
           )
            ],
           ),
         ),
          ],
        ),

    );
  }
}
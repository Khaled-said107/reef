import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:reef/core/widgets/custom_feild.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/app_text.dart';
import '../../logic/cubit/ask_engineer_cubit.dart';
import '../../logic/cubit/ask_engineer_state.dart';

class CommentEngineerWidget extends StatefulWidget {
  final String adsId;
  const CommentEngineerWidget({super.key, required this.adsId});

  @override
  State<CommentEngineerWidget> createState() => _CommentEngineerWidgetState();
}

class _CommentEngineerWidgetState extends State<CommentEngineerWidget> {
  late TextEditingController comment;
  late TextEditingController replyController;
  String? replyingToCommentId;
  @override
  void initState() {
    super.initState();
    comment = TextEditingController();
    replyController = TextEditingController();
    ASkEngineerCubit.get(context).getAllComment(widget.adsId);
  }

  @override
  void dispose() {
    comment.dispose();
    replyController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ASkEngineerCubit, AskEngineerState>(
      listener: (context, state) {
        // When comment is successfully created, re-fetch comments
        if (state is SuccessCreateCommentState) {
          ASkEngineerCubit.get(context).getAllComment(widget.adsId);
          comment.clear(); // ✅ Clear the input
        }
      },
      builder: (context, state) {
        var cubit = ASkEngineerCubit.get(context).getAllCommentsModel;
        var comments = cubit?.comments;
        TextEditingController commentController = TextEditingController();

        return Directionality(
          textDirection: TextDirection.rtl,
          child: Column(
            children: [
              comments != null
                  ? Expanded(
                child: ListView.builder(
                  itemCount: comments.length,
                  itemBuilder: (context, index) {
                    final comment = comments[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Main comment
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CircleAvatar(
                                backgroundColor: AppColors.bgColor,
                                radius: 32.r,
                                backgroundImage: comment.user.profilePhoto != null &&
                                    comment.user.profilePhoto!.startsWith('https')
                                    ? AssetImage('assets/images/profile_default.png')
                                as ImageProvider
                                    : NetworkImage(
                                    'http://82.29.172.199:8001${comment.user.profilePhoto}'),
                              ),
                              SizedBox(width: 8.w),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(comment.user.name,
                                        style: TextStyle(fontWeight: FontWeight.bold)),
                                    Text(
                                      comment.createdAt.split('T').first,
                                      style: TextStyle(fontSize: 10.sp, color: Colors.grey),
                                    ),
                                    SizedBox(height: 4),
                                    Text(comment.content),
                                    SizedBox(height: 4),
                                    TextButton(
                                      onPressed: () {
                                        setState(() {
                                          replyingToCommentId = comment.id; // <-- أو comment._id
                                        });
                                      },
                                      child: Text("رد", style: TextStyle(fontSize: 12.sp)),
                                    ),
                                    // إظهار حقل الرد عند الضغط
                                    if (replyingToCommentId == comment.id)
                                      Padding(
                                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                                        child: Row(
                                          children: [
                                            Expanded(
                                              child: CustomFeild(
                                                controller: commentController,
                                                hintText: 'اكتب ردك هنا...',
                                                obscureText: false,
                                              ),
                                            ),
                                            IconButton(
                                              icon: Icon(Icons.send),
                                              onPressed: () {
                                                if (commentController.text.trim().isNotEmpty) {
                                                  ASkEngineerCubit.get(context).createReplayComment(
                                                    adsId: widget.adsId,
                                                    commentId: comment.id,
                                                    content: commentController.text.trim(),
                                                  );
                                                  setState(() {
                                                    replyingToCommentId = null;
                                                  });
                                                  commentController.clear();
                                                  FocusScope.of(context).unfocus();
                                                }
                                              },
                                            )
                                          ],
                                        ),
                                      )
                                  ],
                                ),
                              )
                            ],
                          ),
                          // Replies (if any)
                          if (comment.replies.isNotEmpty)
                            Padding(
                              padding: EdgeInsets.only(right: 36, top: 12),
                              child: Column(
                                children: comment.replies.map((reply) {
                                  return Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Column(
                                        children: [
                                          Container(
                                            width: 2,
                                            height: 40,
                                            color: Colors.green,
                                          ),
                                          CircleAvatar(
                                            backgroundColor: AppColors.bgColor,
                                            radius: 25.r,
                                            backgroundImage:
                                            reply.user.profilePhoto != null &&
                                                reply.user.profilePhoto!
                                                    .startsWith('https')
                                                ? AssetImage(
                                                'assets/images/profile_default.png')
                                            as ImageProvider
                                                : NetworkImage(
                                                'http://82.29.172.199:8001${reply.user.profilePhoto}'),
                                          ),
                                        ],
                                      ),
                                      SizedBox(width: 8),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(reply.user.name, style: TextStyle(fontWeight: FontWeight.bold)),
                                            Text(
                                              reply.createdAt.split('T').first,
                                              style: TextStyle(fontSize: 10.sp, color: Colors.grey),
                                            ),
                                            Text(reply.content),
                                          ],
                                        ),
                                      )
                                    ],
                                  );
                                }).toList(),
                              ),
                            ),
                        ],
                      ),
                    );

                  },
                ),
              )
                  : Expanded(child: Center(child: CircularProgressIndicator())),

              // Comment Input
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(
                      color: AppColors.primary,
                    ),
                  ),
                ),
                child: Row(
                  children: [
                    const SizedBox(width: 10),
                    Expanded(
                      child: Container(
                        width: 300.h,
                        height: 40.w,
                        child: CustomFeild(
                          controller: comment,
                          hintText: "اضافه تعليق ...",
                          obscureText: false,
                        ),
                      ),
                    ),
                    Gap(10.w),
                    GestureDetector(
                      onTap: () async {

                         ASkEngineerCubit.get(context).createComment(
                          adsId: widget.adsId,
                          content: comment.text.trim(),
                        );

                        // comment.clear();
                        //
                        // ASkEngineerCubit.get(context).getAllComment(widget.adsId);

                        },
                      child: Container(
                        width: 40.w,
                        height: 40.w,
                        child: Icon(Icons.send),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

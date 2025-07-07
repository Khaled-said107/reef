import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:reef/feature/my_posts/data/Model/MyPost_Model.dart';

import '../../../../core/helpers/cach_helper.dart' show CacheHelper;
import '../../../../core/network/dio_helper.dart';

part 'my_post_state.dart';

class MyPostCubit extends Cubit<MyPostState> {
  MyPostCubit() : super(MyPostInitial());

  static MyPostCubit get(context) => BlocProvider.of(context);


  MyPostModel? myPostModel;

  void getMyPosts(){
    emit(LoadingGetMyPostsState());
    DioHelper.getData(
      token: CacheHelper.getData('token'),
      url: 'post/me',
    ).then((value){
      print('data GetMyPosts : ${jsonEncode(value.data)}');
      myPostModel = MyPostModel.fromJson(value.data);
      // print(
      //     myPostModel!.posts.map((post) => {
      //       'id': post.id,
      //       'name': post.name,
      //       'description': post.description,
      //       'price': post.price,
      //       'quantity': post.quantity
      //     }).toList()
      // );
      emit(SuccessGetMyPostsState(myPostModel!));
    }).catchError((error){
      emit(ErrorGetMyPostsState());
      print('error GetMyPosts' + error.toString());
    });

  }



}

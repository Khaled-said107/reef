import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:image_picker/image_picker.dart';
import 'package:reef/core/constants/app_colors.dart';
import 'package:reef/core/helpers/extensions.dart';
import 'package:reef/core/widgets/app_text.dart';
import 'package:reef/feature/my_posts/ui/screens/my_posts_screen.dart';
import 'package:reef/feature/my_posts/ui/widgets/modifications_fields.dart';
import '../../../../core/helpers/cach_helper.dart';
import '../../../navbar/logic/navbar.dart';
import '../../data/Model/MyPost_Model.dart';
import '../../logic/MyPost_cubit/my_post_cubit.dart';
import '../../logic/UpdateMyPost_Cubit/update_my_post_cubit.dart';

class EditPostScreen extends StatefulWidget {
  EditPostScreen({super.key, required this.Postid,required this.post});
  final String Postid;
  final Post post;

  @override
  State<EditPostScreen> createState() => _EditPostScreenState();
}

class _EditPostScreenState extends State<EditPostScreen> {
  final nameController = TextEditingController();
  final descriptionController = TextEditingController();
  final priceController = TextEditingController();
  final quantityController = TextEditingController();
  final addressController = TextEditingController();
  final phoneController = TextEditingController();
  final whatsappController = TextEditingController();

  List<String> products = ['محاصيل زراعيه', 'حيوانات', 'عربات'];
  List<String> ifFood = ['عنب', 'خوخ', 'طماطم', 'جزر', 'زرا', 'فراولا', 'كوسا', 'بتنجان', 'خيار', 'فلفل', 'قمح', 'قصب السكر', 'ورد', 'منجا'];
  List<String> ifAnimals = ['حمار', 'حصان', 'بغل', 'بقره', 'جاموسا', 'معزه', 'خروف', 'دجاج', 'ديك رومي', 'ارانب', 'بط'];
  List<String> ifVehicels = ['جرار', 'محراث', 'عربات نقل', 'عربات نص نقل'];
  List<String> priceUnits = ['للواحدة', 'للكيلو', 'للطرد', 'للكرتونة'];
  List<String> quantityUnits = ['كيلو', 'جرام', 'قطعة', 'طن', 'صندوق'];
  List<String> sellTypes = ['جملة', 'تجزئة'];
  List<String> productConditions = ['من فترة', 'حديثاً'];

  String? selectedMainProduct;
  String? selectedSubProduct;
  String? priceType;
  String? quantityUnit;
  String? sellType;
  String? condition;
  File? selectedImage;


  List<String> WhichProduct(String selectedCategory) {
    if (selectedCategory == products[0]) {
      return ifFood;
    } else if (selectedCategory == products[1]) {
      return ifAnimals;
    } else {
      return ifVehicels;
    }
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final state = context.read<MyPostCubit>().state;

      if (state is SuccessGetMyPostsState) {
        final posts = state.myPost.posts;
        nameController.text = widget.post.name ?? '';
        descriptionController.text = widget.post.description ?? '';
        priceController.text = widget.post.price.toString() ?? '';
        quantityController.text = widget.post.quantity.toString() ?? '';
        addressController.text = widget.post.address ?? '';
        phoneController.text = widget.post.phone ?? '';
        whatsappController.text = widget.post.whatsapp ?? '';
        priceType = widget.post.priceUnit;
        quantityUnit = widget.post.quantityUnit;
        sellType = widget.post.sellType;
        condition = widget.post.condition;

      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<UpdateMyPostCubit, UpdateMyPostState>(
      listener: (context, state) {
        if (state is UpdateMyPost) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("تم التعديل بنجاح")),
          );
          MyPostCubit.get(context).getMyPosts();
           Navigator.pop(context) ;
        } else if (state is ErrorOfUpdate) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("فشل في التعديل: ${state.error}")),
          );
          print(state.error);
        }
        if(state is SuccessDeletePostState){
          Navigator.push(context, MaterialPageRoute(builder: (context)=>NavbarWidget(
            role: CacheHelper.getData('role')!,
          )));
        }
      },
      builder: (context, state) {
        return Scaffold(
          body: SafeArea(
            child: Column(

              children: [
                _header(context),
                _image(),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 15.h, horizontal: 15.w),
                    child: ListView(
                      children: [
                        // Row(
                        //   children: [
                        //     Expanded(
                        //       child: _dropDown(
                        //         value: selectedMainProduct,
                        //         onChanged: (val) {
                        //           setState(() {
                        //             selectedMainProduct = val;
                        //             selectedSubProduct = null;
                        //           });
                        //         },
                        //         hint: 'اختر الصنف ',
                        //         items: products,
                        //       ),
                        //     ),
                        //     Gap(20.w),
                        //     Expanded(
                        //       child: _dropDown(
                        //         value: selectedSubProduct,
                        //         onChanged: (val) => setState(() => selectedSubProduct = val),
                        //         hint: 'اختر نوع المنتج',
                        //         items: selectedMainProduct == null ? [] : WhichProduct(selectedMainProduct!),
                        //       ),
                        //     ),
                        //   ],
                        // ),
                        ModificationsFields(title: 'أسم المنتج', controller: nameController, hint: '',),
                        ModificationsFields(title: 'وصف المنتج', controller: descriptionController, hint: '',),
                        Row(
                          children: [
                            Expanded(
                              child: _dropDown(
                                value: priceType,
                                onChanged: (val) => setState(() => priceType = val),
                                hint: 'اختر الوحدة',
                                items: priceUnits,
                              ),
                            ),
                            Gap(20.w),
                            Expanded(child: ModificationsFields(title: 'السعر', controller: priceController, hint: '',)),
                          ],
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: _dropDown(
                                value: quantityUnit,
                                onChanged: (val) => setState(() => quantityUnit = val),
                                hint: 'اختر الوزن',
                                items: quantityUnits,
                              ),
                            ),
                            Gap(20.w),
                            Expanded(child: ModificationsFields(title: 'الكميه المتوفره', controller: quantityController, hint: '',)),
                          ],
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: _dropDown(
                                value: sellType,
                                onChanged: (val) => setState(() => sellType = val),
                                hint: 'اختر نوع البيع',
                                items: sellTypes,
                              ),
                            ),
                            Gap(20.w),
                            Expanded(
                              child: _dropDown(
                                value: condition,
                                onChanged: (val) => setState(() => condition = val),
                                hint: 'اخترالحالة',
                                items: productConditions,
                              ),
                            ),
                          ],
                        ),
                        ModificationsFields(title: 'العنوان', controller: addressController, hint: '',),
                        Row(
                          children: [
                            Expanded(child: ModificationsFields(title: 'رقم الواتساب', controller: whatsappController, hint: '',)),
                            Gap(20.w),
                            Expanded(child: ModificationsFields(title: 'رقم الهاتف', controller: phoneController, hint: '',)),
                          ],
                        ),
                        Gap(20.h),
                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                                onPressed: () {
                                  context.read<UpdateMyPostCubit>().deletePost(widget.Postid);

                                },
                                child: state is LoadingDeletePostState?Text('....يتم الحذف'):Text('حذف الإعلان'),
                              ),
                            ),
                            Gap(20.w),
                            Expanded(
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
                                onPressed: () {
                                  final token = CacheHelper.getData('token').toString();
                                  print('sasasaas'+widget.Postid);
                                  print('hjjhjj'+nameController.text);
                                  print(descriptionController.text);
                                  print(double.tryParse(priceController.text));
                                  print(priceType);
                                  print( int.tryParse(quantityController.text));
                                  print(quantityUnit);
                                  print(sellType);
                                  print(addressController.text);
                                  print(phoneController.text);
                                  print(whatsappController.text);
                                  print(token);
                                  context.read<UpdateMyPostCubit>().updatePost(
                                    id: widget.Postid,
                                    name: nameController.text,
                                    description: descriptionController.text,
                                    price: double.tryParse(priceController.text.trim()) ?? 0,
                                    priceUnit: priceType ?? '',
                                    quantity: int.tryParse(quantityController.text.trim()) ?? 0,
                                    quantityUnit: quantityUnit ?? '',
                                    sellType: sellType ?? '',
                                    condition: condition ?? '',
                                    address: addressController.text,
                                    phone: phoneController.text,
                                    whatsapp: whatsappController.text,
                                    token: token,
                                    imageFile: selectedImage

                                  );
                                },
                                child: state is LodingMyUpdate? Text('....يتم التعديل'): Text('حفظ التعديلات'),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _dropDown({
    required String? value,
    required void Function(String?) onChanged,
    required String hint,
    required List<String> items,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.r),
        color: const Color(0xffF3EFE1),
      ),
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: DropdownButton<String>(
          isExpanded: true,
          value: value,
          icon: SvgPicture.asset('assets/images/dropdown.svg'),
          underline: const SizedBox(),
          hint: AppText(text: hint, fontsize: 12.sp, color: Color(0xff7c7c7c)),
          items: items.map((String item) {
            return DropdownMenuItem<String>(
              value: item,
              child: AppText(text: item),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
  Widget _image() => Stack(
    children: [
      Container(
        color: AppColors.white,
        height: 250.h,
        width: double.infinity,
        child: Center(
          child:
          selectedImage == null
              ? Image.network('http://82.29.172.199:8001${widget.post.images[0]}'
            ,height: 250.h,
            width: double.infinity,
            fit: BoxFit.fill,)
              : Image.file(selectedImage!, height: 106.h, width: 151.w),
        ),
      ),
      Positioned(
        bottom: 10.h,
        left: 10.w,
        child: InkWell(
          onTap: pickImage,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 10.w),
            height: 35.h,
            width: 148.w,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.r),
              color: AppColors.white,
            ),
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.edit, color: AppColors.black),
                  Gap(10.w),
                  AppText(
                    text: 'إضافة صورة',
                    color: AppColors.black,
                    fontsize: 13.sp,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    ],
  );

  Future<void> pickImage() async {
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );
    if (pickedFile != null) {
      setState(() {
        selectedImage = File(pickedFile.path);
      });
    }
  }

  // Widget _image() => Stack(
  //   children: [
  //
  //    // NetworkImage( 'http://82.29.172.199:8001${post.images[0]}'),
  //     Image.network('http://82.29.172.199:8001${widget.post.images[0]}'
  //     ,height: 250.h,
  //     width: double.infinity,
  //     fit: BoxFit.fill,),
  //     Positioned(
  //       bottom: 10.h,
  //       left: 10.w,
  //       child: InkWell(
  //         onTap: () {},
  //         child: Container(
  //           padding: EdgeInsets.symmetric(horizontal: 10.w),
  //           height: 35.h,
  //           width: 148.w,
  //           decoration: BoxDecoration(
  //             borderRadius: BorderRadius.circular(8.r),
  //             color: AppColors.white,
  //           ),
  //           child: Center(
  //             child: Row(
  //               mainAxisAlignment: MainAxisAlignment.center,
  //               children: [
  //                 Icon(Icons.edit, color: AppColors.black),
  //                 Gap(10.w),
  //                 AppText(
  //                   text: 'تغيير الصورة',
  //                   color: AppColors.black,
  //                   fontsize: 13.sp,
  //                 ),
  //               ],
  //             ),
  //           ),
  //         ),
  //       ),
  //     ),
  //   ],
  // );

  Padding _header(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 18.h, horizontal: 15.w),
      child: Row(
        children: [
          Spacer(),
          AppText(
            text: "تعديل الأعلان",
            fontsize: 17.sp,
            fontWeight: FontWeight.w500,
          ),
          Gap(10.w),
          InkWell(
            onTap: () {
              context.pop();
            },
            child: SvgPicture.asset('assets/images/backIcon.svg'),
          ),
          Gap(10.w),
        ],
      ),
    );
  }
}

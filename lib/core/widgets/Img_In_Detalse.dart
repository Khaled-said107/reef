import 'dart:io';

import 'package:flutter/material.dart';
import 'package:reef/core/constants/app_colors.dart';

class ImgInDetalse extends StatefulWidget {
  final List<String>imgs;
  final int imgIndex;
  const ImgInDetalse({super.key,required this.imgs,required this.imgIndex});

  @override
  State<ImgInDetalse> createState() => _ImgInDetalseState();
}

class _ImgInDetalseState extends State<ImgInDetalse> {
  late PageController _controller;
  late int _currentIndex;
  @override
  void initState() {
    super.initState();
    _currentIndex = widget.imgIndex;
    _controller = PageController(initialPage: _currentIndex);
  }
  Widget build(BuildContext context) {
    return Scaffold(

      backgroundColor: Colors.black38,
      body: Stack(
        children: [
          PageView.builder(
              controller: _controller,
              itemCount: widget.imgs.length,
              onPageChanged: (index) => setState(() => _currentIndex = index),
              itemBuilder:(context, index) {
                return InteractiveViewer(child: Center(
                child: Image(image: NetworkImage(widget.imgs[index]),)),);
              },
          ),
          // زر الرجوع (السهم على اليسار)
          Positioned(
            left: 10,
            top: MediaQuery.of(context).size.height / 2 ,
            child: GestureDetector(
              onTap: () {
                if (_currentIndex > 0) {
                  _controller.previousPage(
                    duration: Duration(milliseconds: 200),
                    curve: Curves.bounceInOut,
                  );
                }
              },
              child: CircleAvatar(
                radius: 25,
                backgroundColor: Colors.white70,
                child: Center(child: Icon(Icons.arrow_back_ios, color: Colors.black)),
              ),
            ),
          ),

          // زر التالي (السهم على اليمين)
          Positioned(
            right: 10,
            top: MediaQuery.of(context).size.height / 2 ,
            child: GestureDetector(
              onTap: () {
                if (_currentIndex < widget.imgs.length - 1) {
                  _controller.nextPage(
                    duration: Duration(milliseconds: 200),
                    curve: Curves.bounceInOut,
                  );
                }
              },
              child: CircleAvatar(
                radius: 25,
                backgroundColor: Colors.white70,
                child: Center(child: Icon(Icons.arrow_forward_ios, color: Colors.black)),
              ),
            ),
          ),

          Positioned(
            top: 40,
            left: 20,
            child: IconButton(
              icon: Icon(Icons.close, color: AppColors.textGrey, size: 30),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ],
      ),
    );
  }
}

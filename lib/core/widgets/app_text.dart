import 'package:flutter/material.dart';

class AppText extends StatelessWidget {
  final String text;
  final double? fontsize;
  final FontWeight? fontWeight;
  final Color? color;
  final TextAlign? textAlign;
  final int? maxLines;

  const AppText(
      {super.key,
      required this.text,
      this.fontsize,
      this.fontWeight,
      this.color,
      this.textAlign,
      this.maxLines});

  @override
  Widget build(BuildContext context) {
    return Text(text,
        textAlign: textAlign,
        maxLines: maxLines ?? 5,
        style: TextStyle(
            fontSize: fontsize,
            fontWeight: fontWeight,
            fontFamily: 'Tajawal',
            overflow:
                TextOverflow.ellipsis, // ← دي اللي بتخلي الكلام يتقطع بنقط

            color: color));
  }
}

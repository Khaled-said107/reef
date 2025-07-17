import 'package:flutter/material.dart';

class AppText extends StatelessWidget {
  final String text;
  final double? fontsize;
  final FontWeight? fontWeight;
  final Color? color;
  final TextAlign? textAlign;
  final int? maxLines;
  final int? maxWords; // 👈 باراميتر جديد لتحديد عدد الكلمات

  const AppText({
    super.key,
    required this.text,
    this.fontsize,
    this.fontWeight,
    this.color,
    this.textAlign,
    this.maxLines,
    this.maxWords, // 👈 ضفناه هنا كمان
  });

  @override
  Widget build(BuildContext context) {
    String displayText = text;

    if (maxWords != null) {
      final words = text.split(' ');
      if (words.length > maxWords!) {
        displayText = words.take(maxWords!).join(' ') + '...';
      }
    }

    return Text(
      displayText,
      textAlign: textAlign,
      maxLines: maxLines ?? 5,
      style: TextStyle(
        fontSize: fontsize,
        fontWeight: fontWeight,
        fontFamily: 'Tajawal',
        overflow: TextOverflow.ellipsis,
        color: color,
      ),
    );
  }
}

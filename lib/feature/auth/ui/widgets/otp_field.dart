import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:reef/core/constants/app_colors.dart';

class OtpField extends StatelessWidget {
  const OtpField({
    super.key,
    required this.textEditingController,
  });

  final TextEditingController textEditingController;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 50),
      child: PinCodeTextField(
               appContext: context,
               controller: textEditingController,
               keyboardType: TextInputType.number,
               animationType: AnimationType.fade,
               validator: (v) {
                 if (v!.length < 4) {
                   return "الرمز مكون من 4 أرقام";
                 } else {
                   return null;
                 }
               },
               pinTheme: PinTheme(
                 shape: PinCodeFieldShape.underline,
                 selectedColor: AppColors.primary,
                 activeColor: AppColors.primary,
                 inactiveColor: const Color.fromARGB(255, 171, 171, 171),
                 fieldHeight: 50,
                 fieldWidth: 40,
                 activeFillColor: Colors.white,
               ),
               cursorColor: Colors.black,
               animationDuration: const Duration(milliseconds: 500),
               onChanged: (value) {
                 debugPrint(value);
                 // setState(() {
                 //   currentText = value;
                 // });
               },
               length: 4,
               blinkWhenObscuring: true,
               boxShadows: const [
                 BoxShadow(
                   offset: Offset(0, 1),
                   color: Colors.black12,
                   blurRadius: 10,
                 )
               ],
               onCompleted: (v) {
                 debugPrint("Completed");
               },
               // onTap: () {
               //   print("Pressed");
               // },
               beforeTextPaste: (text) {
                 debugPrint("Allowing to paste $text");
                 return true;
               },
               
             ),
    );
  }
}
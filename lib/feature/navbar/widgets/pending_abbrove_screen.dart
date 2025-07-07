import 'package:flutter/material.dart';
import 'package:reef/core/widgets/app_text.dart';

class PendingApprovalScreen extends StatelessWidget {
  const PendingApprovalScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: AppText(
          text: 'تم استلام طلبك.\nسيتم تفعيل الحساب بعد موافقة الإدارة.',
          fontsize: 16,
          fontWeight: FontWeight.bold,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

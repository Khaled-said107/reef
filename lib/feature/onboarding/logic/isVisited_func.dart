import 'package:flutter/material.dart';
import 'package:reef/core/helpers/cach_helper.dart';
import 'package:reef/core/routing/routes.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:reef/core/helpers/extensions.dart';

void finishOnBoarding(BuildContext context) async{
await CacheHelper.saveBool(key: 'complete_onBoarding', value: true);
 context.pushReplacementNamed(Routes.register);
}
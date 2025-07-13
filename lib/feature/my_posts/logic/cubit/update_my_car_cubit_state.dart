import 'package:flutter/cupertino.dart';
import 'package:reef/feature/my_posts/data/Model/MyCar_Modle.dart';

import '../../../truck/data/DeliveryData.dart';

@immutable
sealed class MyCarState {}

final class MyCarInitial extends MyCarState {}

final class MyCarSucsses extends MyCarState {
  final MyCarModel carModel;
  MyCarSucsses(this.carModel);
}

final class MyCarLoding extends MyCarState {}

final class MyCarError extends MyCarState {
  final String error;
  MyCarError(this.error);
}

class NoCarData extends MyCarState {}

import 'package:flutter/material.dart';
import 'package:reef/feature/my_posts/data/Model/UpdateMyCar_Modle.dart';

@immutable
sealed class UpdateMyCarState {}

final class UpdateMyCarInitial extends UpdateMyCarState {}

final class UpdateMyCarSucsses extends UpdateMyCarState {
  final UpdateMyCarModle updateMyCarModle;
  UpdateMyCarSucsses(this.updateMyCarModle);
}

final class UpdateMyCarLoding extends UpdateMyCarState {}

final class UpdateMyCarError extends UpdateMyCarState {
  final String error;
  UpdateMyCarError(this.error);
}

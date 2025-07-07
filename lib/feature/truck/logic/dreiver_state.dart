

import 'package:flutter/material.dart';

import '../data/CarModel.dart';
import '../data/DeliveryData.dart';
import '../data/DriversResponseModel.dart';

@immutable
sealed class DriverState {}

final class DriverInitial extends DriverState {}

class DriverLoading extends DriverState {}

class DriverSuccess extends DriverState {
  final DriversResponseModel? drivers;
  DriverSuccess(this.drivers);
}

class DriverError extends DriverState {
  final String message;
  DriverError(this.message);
}

///////////////////add driver///////////////////////////
class AddDriverLoading extends DriverState {}

class AddDriverSuccess extends DriverState {
  final CarModel? driver;
  AddDriverSuccess(this.driver);
}

class AddDriverError extends DriverState {
  final String message;
  AddDriverError(this.message);
}

class DeliveryLoading extends DriverState {}

class DeliverySuccess extends DriverState {
  final DeliveryData data;

  DeliverySuccess(this.data);
}

class DeliveryError extends DriverState {
  final String message;

  DeliveryError(this.message);
}
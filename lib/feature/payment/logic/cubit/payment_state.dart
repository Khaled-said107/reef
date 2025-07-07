part of 'payment_cubit.dart';

@immutable
sealed class PaymentState {}

final class PaymentInitial extends PaymentState {}

class PaymentPost extends PaymentState {
  final PaymentModel model;

  PaymentPost(this.model);
}

final class PaymentLoding extends PaymentState {}

final class PaymentError extends PaymentState {
  String error;
  PaymentError(this.error);
}

part of 'checkout_cubit.dart';

abstract class CheckoutState {
  String? paymentMethod;
  CheckoutState({this.paymentMethod});
}

final class CheckoutInitial extends CheckoutState {}

final class CheckoutLoading extends CheckoutState {}

final class CheckoutSuccess extends CheckoutState {
  final String? paymentMethodString;
  CheckoutSuccess({this.paymentMethodString})
      : super(paymentMethod: paymentMethodString);
}

final class CheckoutFailure extends CheckoutState {}

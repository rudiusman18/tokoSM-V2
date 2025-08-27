part of 'checkout_cubit.dart';

abstract class CheckoutState {
  String? paymentMethod;
  Map<String, dynamic>? courierModel;
  Map<String, dynamic>? selectedCourier;
  CheckoutState({this.paymentMethod, this.courierModel, this.selectedCourier});
}

final class CheckoutInitial extends CheckoutState {}

final class CheckoutLoading extends CheckoutState {}

final class CheckoutSuccess extends CheckoutState {
  final String? paymentMethodString;
  final Map<String, dynamic>? courierModelData;
  final Map<String, dynamic>? selectedCourierData;
  CheckoutSuccess(
      {this.paymentMethodString,
      this.courierModelData,
      this.selectedCourierData})
      : super(
          paymentMethod: paymentMethodString,
          courierModel: courierModelData,
          selectedCourier: selectedCourierData,
        );
}

final class CheckoutFailure extends CheckoutState {
  final String? error;
  CheckoutFailure({this.error}) : super();
}

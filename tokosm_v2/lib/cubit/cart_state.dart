part of 'cart_cubit.dart';

abstract class CartState {
  final ProductModel? productModel;
  List<int>? productAmount = [0];
  CartState({
    this.productModel,
    this.productAmount,
  });
}

final class CartInitial extends CartState {}

final class CartLoading extends CartState {}

final class CartSuccess extends CartState {
  final ProductModel? productModelData;
  final List<int>? productAmountData;
  CartSuccess({this.productModelData, this.productAmountData})
      : super(productModel: productModelData, productAmount: productAmountData);
}

final class CartFailure extends CartState {
  final String error;
  CartFailure({required this.error}) : super();
}

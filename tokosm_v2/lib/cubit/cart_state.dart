part of 'cart_cubit.dart';

abstract class CartState {
  final ProductModel? productModel;
  CartState({
    this.productModel,
  });
}

final class CartInitial extends CartState {}

final class CartLoading extends CartState {}

final class CartSuccess extends CartState {
  final ProductModel? productModelData;
  CartSuccess({this.productModelData}) : super(productModel: productModelData);
}

final class CartFailure extends CartState {
  final String error;
  CartFailure({required this.error}) : super();
}

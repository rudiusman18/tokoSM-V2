part of 'cart_cubit.dart';

abstract class CartState {
  final ProductModel? productModel;
  final ProductModel? productToTransaction;
  List<int>? productAmount = [0];
  CartState({
    this.productModel,
    this.productAmount,
    this.productToTransaction,
  });
}

final class CartInitial extends CartState {}

final class CartLoading extends CartState {}

final class CartSuccess extends CartState {
  final ProductModel? productModelData;
  final ProductModel? productToTransactionData;
  final List<int>? productAmountData;
  CartSuccess(
      {this.productModelData,
      this.productAmountData,
      this.productToTransactionData})
      : super(
          productModel: productModelData,
          productAmount: productAmountData,
          productToTransaction: productToTransactionData,
        );
}

final class CartFailure extends CartState {
  final String error;
  CartFailure({required this.error}) : super();
}

part of 'cart_cubit.dart';

abstract class CartState {
  final ProductModel? productModel;
  final ProductModel? productToTransaction;
  final List<int>? productPricestoTransaction;
  List<int>? productAmount = [0];
  CartState({
    this.productModel,
    this.productAmount,
    this.productToTransaction,
    this.productPricestoTransaction,
  });
}

final class CartInitial extends CartState {}

final class CartLoading extends CartState {}

final class CartSuccess extends CartState {
  final ProductModel? productModelData;
  final ProductModel? productToTransactionData;
  final List<int>? productAmountData;
  final List<int>? productPricestoTransactionData;
  CartSuccess({
    this.productModelData,
    this.productAmountData,
    this.productToTransactionData,
    this.productPricestoTransactionData,
  }) : super(
          productModel: productModelData,
          productAmount: productAmountData,
          productToTransaction: productToTransactionData,
          productPricestoTransaction: productPricestoTransactionData,
        );
}

final class CartFailure extends CartState {
  final String error;
  CartFailure({required this.error}) : super();
}

part of 'product_cubit.dart';

abstract class ProductState {
  final ProductModel flashSaleProduct;
  final ProductModel discountProduct;
  final ProductModel promoProduct;
  final ProductModel bestSellerProduct;
  final ProductModel popularProduct;

  const ProductState({
    required this.flashSaleProduct,
    required this.discountProduct,
    required this.promoProduct,
    required this.bestSellerProduct,
    required this.popularProduct,
  });
}

class ProductInitial extends ProductState {
  ProductInitial()
      : super(
          flashSaleProduct: ProductModel(),
          discountProduct: ProductModel(),
          promoProduct: ProductModel(),
          bestSellerProduct: ProductModel(),
          popularProduct: ProductModel(),
        );
}

class ProductLoading extends ProductState {
  ProductLoading()
      : super(
          flashSaleProduct: ProductModel(),
          discountProduct: ProductModel(),
          promoProduct: ProductModel(),
          bestSellerProduct: ProductModel(),
          popularProduct: ProductModel(),
        );
}

class ProductSuccess extends ProductState {
  final ProductModel flashSaleProductData;
  final ProductModel discountProductData;
  final ProductModel promoProductData;
  final ProductModel bestSellerProductData;
  final ProductModel popularProductData;

  ProductSuccess({
    required this.flashSaleProductData,
    required this.discountProductData,
    required this.promoProductData,
    required this.bestSellerProductData,
    required this.popularProductData,
  }) : super(
          flashSaleProduct: flashSaleProductData,
          discountProduct: discountProductData,
          promoProduct: promoProductData,
          bestSellerProduct: bestSellerProductData,
          popularProduct: popularProductData,
        );
}

class ProductFailure extends ProductState {
  String error;
  ProductFailure(this.error)
      : super(
          flashSaleProduct: ProductModel(),
          discountProduct: ProductModel(),
          promoProduct: ProductModel(),
          bestSellerProduct: ProductModel(),
          popularProduct: ProductModel(),
        );
}

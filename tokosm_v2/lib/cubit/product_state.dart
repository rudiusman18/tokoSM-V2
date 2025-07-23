part of 'product_cubit.dart';

abstract class ProductState {
  final ProductModel flashSaleProduct;
  final ProductModel discountProduct;
  final ProductModel promoProduct;
  final ProductModel bestSellerProduct;
  final ProductModel popularProduct;
  final ProductModel wildProduct;
  final int productTabIndex;

  const ProductState({
    required this.flashSaleProduct,
    required this.discountProduct,
    required this.promoProduct,
    required this.bestSellerProduct,
    required this.popularProduct,
    required this.wildProduct,
    required this.productTabIndex,
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
          wildProduct: ProductModel(),
          productTabIndex: 0,
        );
}

class ProductLoading extends ProductState {
  final int productTabIndexData;
  ProductLoading(this.productTabIndexData)
      : super(
          flashSaleProduct: ProductModel(),
          discountProduct: ProductModel(),
          promoProduct: ProductModel(),
          bestSellerProduct: ProductModel(),
          popularProduct: ProductModel(),
          wildProduct: ProductModel(),
          productTabIndex: productTabIndexData,
        );
}

class ProductSuccess extends ProductState {
  final ProductModel flashSaleProductData;
  final ProductModel discountProductData;
  final ProductModel promoProductData;
  final ProductModel bestSellerProductData;
  final ProductModel popularProductData;
  final ProductModel wildProductData;
  final int productTabIndexData;

  ProductSuccess({
    required this.flashSaleProductData,
    required this.discountProductData,
    required this.promoProductData,
    required this.bestSellerProductData,
    required this.popularProductData,
    required this.wildProductData,
    required this.productTabIndexData,
  }) : super(
          flashSaleProduct: flashSaleProductData,
          discountProduct: discountProductData,
          promoProduct: promoProductData,
          bestSellerProduct: bestSellerProductData,
          popularProduct: popularProductData,
          wildProduct: wildProductData,
          productTabIndex: productTabIndexData,
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
          wildProduct: ProductModel(),
          productTabIndex: 0,
        );
}

class ProductSearchKeyword extends ProductState {
  final ProductModel flashSaleProductData;
  final ProductModel discountProductData;
  final ProductModel promoProductData;
  final ProductModel bestSellerProductData;
  final ProductModel popularProductData;
  final ProductModel wildProductData;
  final int productTabIndexData;
  String searchKeyword;
  ProductSearchKeyword({
    required this.searchKeyword,
    required this.flashSaleProductData,
    required this.discountProductData,
    required this.promoProductData,
    required this.bestSellerProductData,
    required this.popularProductData,
    required this.wildProductData,
    required this.productTabIndexData,
  }) : super(
          flashSaleProduct: flashSaleProductData,
          discountProduct: discountProductData,
          promoProduct: promoProductData,
          bestSellerProduct: bestSellerProductData,
          popularProduct: popularProductData,
          wildProduct: wildProductData,
          productTabIndex: productTabIndexData,
        );
}

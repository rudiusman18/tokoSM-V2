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

  // Hanya muncul saat state success
  final String searchkeyword;
  final String selectedCategoryFilter;
  final String selectedPromoFilter;
  final String selectedRatingFilter;
  final String minPriceFilter;
  final String maxPriceFilter;
  final DataProduct? detailProduct;

  ProductSuccess({
    required this.flashSaleProductData,
    required this.discountProductData,
    required this.promoProductData,
    required this.bestSellerProductData,
    required this.popularProductData,
    required this.wildProductData,
    required this.productTabIndexData,
    this.searchkeyword = "",
    this.selectedCategoryFilter = "",
    this.selectedPromoFilter = "",
    this.selectedRatingFilter = "",
    this.minPriceFilter = "",
    this.maxPriceFilter = "",
    this.detailProduct,
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

// NOTE: Detail Product State
abstract class DetailProductState {
  final DetailProductModel detailProductModel;
  DetailProductState({required this.detailProductModel});
}

final class DetailProductInitial extends DetailProductState {
  DetailProductInitial() : super(detailProductModel: DetailProductModel());
}

final class DetailProductLoading extends DetailProductState {
  DetailProductLoading() : super(detailProductModel: DetailProductModel());
}

final class DetailProductSuccess extends DetailProductState {
  final DetailProductModel detailProductData;
  DetailProductSuccess(this.detailProductData)
      : super(detailProductModel: detailProductData);
}

final class DetailProductFailure extends DetailProductState {
  final String error;
  DetailProductFailure(this.error)
      : super(detailProductModel: DetailProductModel());
}

part of 'wishlist_cubit.dart';

sealed class WishlistState {
  int tabIndex = 0;
  ProductModel wishlistProduct = ProductModel();

  WishlistState({required this.tabIndex, required this.wishlistProduct});
}

final class WishlistInitial extends WishlistState {
  WishlistInitial() : super(tabIndex: 0, wishlistProduct: ProductModel());
}

final class WishlistLoading extends WishlistState {
  final int tabIndexData;
  WishlistLoading(this.tabIndexData)
      : super(tabIndex: tabIndexData, wishlistProduct: ProductModel());
}

final class WishlistSuccess extends WishlistState {
  final int tabIndexData;
  final ProductModel wishlistProductData;
  WishlistSuccess(
      {required this.tabIndexData, required this.wishlistProductData})
      : super(
          tabIndex: tabIndexData,
          wishlistProduct: wishlistProductData,
        );
}

final class WishlistFailure extends WishlistState {
  final int tabIndexData;
  final String error;
  WishlistFailure({required this.error, required this.tabIndexData})
      : super(tabIndex: tabIndexData, wishlistProduct: ProductModel());
}

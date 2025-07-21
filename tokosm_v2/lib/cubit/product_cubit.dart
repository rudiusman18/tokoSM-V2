import 'package:bloc/bloc.dart';
import 'package:flutter/widgets.dart';
import 'package:tokosm_v2/cubit/login_cubit.dart';
import 'package:tokosm_v2/model/product_model.dart';
import 'package:tokosm_v2/service/product_service.dart';
part 'product_state.dart';

class ProductCubit extends Cubit<ProductState> {
  ProductCubit() : super(ProductInitial());

  void getProducts({
    required String token,
    required int cabangId,
    required String type,
    int page = 1,
    int limit = 10,
  }) async {
    emit(ProductLoading());
    try {
      ProductModel productModel = await ProductService().getProduct(
        token: token,
        cabangId: 1,
        type: type,
        page: page,
        limit: limit,
      );
      print("produk berhasil didapatkan");
      emit(ProductSuccess(
          flashSaleProductData:
              type == "flashsale" ? productModel : state.flashSaleProduct,
          discountProductData:
              type == "diskon" ? productModel : state.discountProduct,
          promoProductData: type == "promo" ? productModel : state.promoProduct,
          bestSellerProductData:
              type == "terlaris" ? productModel : state.bestSellerProduct,
          popularProductData:
              type == "populer" ? productModel : state.popularProduct));
    } catch (e) {
      print("produk error ${e.toString()}");
      emit(ProductFailure(e.toString()));
    }
  }
}

import 'package:bloc/bloc.dart';
import 'package:tokosm_v2/model/product_model.dart';
import 'package:tokosm_v2/service/product_service.dart';
part 'product_state.dart';

class ProductCubit extends Cubit<ProductState> {
  ProductCubit() : super(ProductInitial());

  void productTabIndex(int index) {
    emit(
      ProductSuccess(
        flashSaleProductData: state.flashSaleProduct,
        discountProductData: state.discountProduct,
        promoProductData: state.promoProduct,
        bestSellerProductData: state.bestSellerProduct,
        popularProductData: state.popularProduct,
        wildProductData: state.wildProduct,
        productTabIndexData: index,
      ),
    );
  }

  void getAllProduct({
    required String token,
    required int cabangId,
    required String type,
    String sort = "",
    int page = 1,
    int limit = 10,
  }) async {
    // Simpan data sebelumnya kalau state saat ini adalah ProductSuccess
    ProductModel? flashSale = state is ProductSuccess
        ? (state as ProductSuccess).flashSaleProduct
        : null;
    ProductModel? discount = state is ProductSuccess
        ? (state as ProductSuccess).discountProduct
        : null;
    ProductModel? promo =
        state is ProductSuccess ? (state as ProductSuccess).promoProduct : null;
    ProductModel? bestSeller = state is ProductSuccess
        ? (state as ProductSuccess).bestSellerProduct
        : null;
    ProductModel? popular = state is ProductSuccess
        ? (state as ProductSuccess).popularProduct
        : null;
    int indexTab =
        state is ProductSuccess ? (state as ProductSuccess).productTabIndex : 0;

    emit(ProductLoading(indexTab));
    try {
      ProductModel productModel = await ProductService().getProduct(
        token: token,
        cabangId: cabangId,
        type: type,
        sort: sort,
      );
      emit(
        ProductSuccess(
          flashSaleProductData: flashSale ?? state.flashSaleProduct,
          discountProductData: discount ?? state.discountProduct,
          promoProductData: promo ?? state.promoProduct,
          bestSellerProductData: bestSeller ?? state.bestSellerProduct,
          popularProductData: popular ?? state.popularProduct,
          wildProductData: productModel,
          productTabIndexData: indexTab,
        ),
      );
    } catch (e) {
      emit(ProductFailure(e.toString()));
    }
  }

  void getProducts({
    required String token,
    required int cabangId,
    required String type,
    String sort = "",
    int page = 1,
    int limit = 10,
  }) async {
    emit(ProductLoading(0));
    try {
      ProductModel productModel = await ProductService().getProduct(
        token: token,
        cabangId: 1,
        type: type,
        page: page,
        limit: limit,
        sort: sort,
      );
      emit(
        ProductSuccess(
          flashSaleProductData:
              type == "flashsale" ? productModel : state.flashSaleProduct,
          discountProductData:
              type == "diskon" ? productModel : state.discountProduct,
          promoProductData: type == "promo" ? productModel : state.promoProduct,
          bestSellerProductData:
              type == "terlaris" ? productModel : state.bestSellerProduct,
          popularProductData:
              type == "populer" ? productModel : state.popularProduct,
          wildProductData: state.wildProduct,
          productTabIndexData: state.productTabIndex,
        ),
      );
    } catch (e) {
      print("Error $e");
      emit(ProductFailure(e.toString()));
    }
  }
}

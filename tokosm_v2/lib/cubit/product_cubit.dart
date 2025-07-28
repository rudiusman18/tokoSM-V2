import 'package:bloc/bloc.dart';
import 'package:tokosm_v2/model/product_model.dart';
import 'package:tokosm_v2/service/product_service.dart';
part 'product_state.dart';

class ProductCubit extends Cubit<ProductState> {
  ProductCubit() : super(ProductInitial());

  void productTabIndex(int index) {
    emit(
      ProductSuccess(
        searchkeyword: (state as ProductSuccess).searchkeyword,
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
    String category = "",
    String minrating = "",
    String minprice = "",
    String maxprice = "",
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

    String maxPriceFilter = (state is ProductSuccess)
        ? (state as ProductSuccess).maxPriceFilter
        : "";

    String minPriceFilter = (state is ProductSuccess)
        ? (state as ProductSuccess).minPriceFilter
        : "";

    String searchKeyword = (state is ProductSuccess)
        ? (state as ProductSuccess).searchkeyword
        : "";

    String selectedCategoryFilter = (state is ProductSuccess)
        ? (state as ProductSuccess).selectedCategoryFilter
        : "";

    String selectedPromoFilter = (state is ProductSuccess)
        ? (state as ProductSuccess).selectedPromoFilter
        : "";

    String selectedRatingFilter = (state is ProductSuccess)
        ? (state as ProductSuccess).selectedRatingFilter
        : "";

    print("isi search keyword adalah: ${searchKeyword}");

    emit(ProductLoading(indexTab));
    try {
      ProductModel productModel = await ProductService().getProduct(
        token: token,
        search: searchKeyword,
        cabangId: cabangId,
        cat: category,
        maxprice: maxprice,
        minprice: minprice,
        minrating: minrating,
        type: type,
        sort: sort,
        page: page,
        limit: limit,
      );
      emit(
        ProductSuccess(
          maxPriceFilter: maxPriceFilter,
          minPriceFilter: minPriceFilter,
          searchkeyword: searchKeyword,
          selectedCategoryFilter: selectedCategoryFilter,
          selectedPromoFilter: selectedPromoFilter,
          selectedRatingFilter: selectedRatingFilter,
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
        search: "",
        cabangId: cabangId,
        type: type,
        page: page,
        limit: limit,
        sort: sort,
        cat: "",
        maxprice: "",
        minprice: "",
        minrating: "",
      );

      if (type == "flashsale") {
        print(productModel.data);
      }

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
      print("gagal dengan error $e");
      emit(ProductFailure(e.toString()));
    }
  }

  void setSearchKeyword(String text) {
    emit(
      ProductSuccess(
        searchkeyword: text,
        flashSaleProductData: state.flashSaleProduct,
        discountProductData: state.discountProduct,
        promoProductData: state.promoProduct,
        bestSellerProductData: state.bestSellerProduct,
        popularProductData: state.popularProduct,
        wildProductData: state.wildProduct,
        productTabIndexData: state.productTabIndex,
      ),
    );
  }

  void setProductFilter({
    required String kategori,
    required String promo,
    required String rating,
    required String minPrice,
    required String maxPrice,
  }) {
    emit(
      ProductSuccess(
        searchkeyword: (state as ProductSuccess).searchkeyword,
        selectedCategoryFilter: kategori,
        maxPriceFilter: maxPrice,
        minPriceFilter: minPrice,
        selectedPromoFilter: promo,
        selectedRatingFilter: rating,
        flashSaleProductData: state.flashSaleProduct,
        discountProductData: state.discountProduct,
        promoProductData: state.promoProduct,
        bestSellerProductData: state.bestSellerProduct,
        popularProductData: state.popularProduct,
        wildProductData: state.wildProduct,
        productTabIndexData: state.productTabIndex,
      ),
    );
  }

  void selectProduct({required DataProduct product}) {
    emit(
      ProductSuccess(
        flashSaleProductData: (state as ProductSuccess).flashSaleProductData,
        discountProductData: (state as ProductSuccess).discountProductData,
        promoProductData: (state as ProductSuccess).promoProductData,
        bestSellerProductData: (state as ProductSuccess).bestSellerProductData,
        popularProductData: (state as ProductSuccess).popularProductData,
        wildProductData: (state as ProductSuccess).wildProductData,
        productTabIndexData: (state as ProductSuccess).productTabIndexData,
        maxPriceFilter: (state as ProductSuccess).maxPriceFilter,
        minPriceFilter: (state as ProductSuccess).minPriceFilter,
        searchkeyword: (state as ProductSuccess).searchkeyword,
        selectedCategoryFilter:
            (state as ProductSuccess).selectedCategoryFilter,
        selectedPromoFilter: (state as ProductSuccess).selectedPromoFilter,
        selectedRatingFilter: (state as ProductSuccess).selectedRatingFilter,
        detailProduct: product,
      ),
    );
  }
}

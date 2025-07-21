import 'package:bloc/bloc.dart';
import 'package:tokosm_v2/model/product_model.dart';
import 'package:tokosm_v2/service/product_service.dart';

part 'wishlist_state.dart';

class WishlistCubit extends Cubit<WishlistState> {
  WishlistCubit() : super(WishlistInitial());

  void setTabIndex(int index) {
    emit(WishlistSuccess(
        tabIndexData: index, wishlistProductData: state.wishlistProduct));
  }

  void getWishlistProduct({
    required String token,
    required int cabangId,
    required String sort,
    int page = 1,
    int limit = 10,
  }) async {
    emit(WishlistLoading(state.tabIndex));
    try {
      ProductModel wishlistModel = await ProductService().getWishlistProduct(
        token: token,
        cabangId: cabangId,
        sort: sort,
        page: page,
        limit: limit,
      );
      emit(WishlistSuccess(
          tabIndexData: state.tabIndex, wishlistProductData: wishlistModel));
    } catch (e) {
      emit(WishlistFailure(error: e.toString(), tabIndexData: state.tabIndex));
    }
  }
}

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tokosm_v2/service/product_service.dart';

part 'review_state.dart';

class ReviewCubit extends Cubit<ReviewState> {
  ReviewCubit() : super(ReviewInitial());

  void getReviewProduct(
      {required String token, required String productID}) async {
    emit(ReviewLoading());
    try {
      var data = await ProductService()
          .getProductReview(token: token, productID: productID);
      emit(ReviewSuccess(reviewModelData: data));
    } catch (e) {
      emit(
        ReviewFailure(
          error: e.toString(),
        ),
      );
    }
  }

  void getUserReviewProduct({
    required String token,
    String? searchKeyword,
    int limit = 999999999,
    int page = 1,
  }) async {
    emit(ReviewLoading());
    try {
      var data = await ProductService().getUserProductReview(
        token: token,
        searchKeyword: searchKeyword ?? "",
        limit: limit,
        page: page,
      );
      emit(ReviewSuccess(reviewModelData: data));
    } catch (e) {
      emit(ReviewFailure(
        error: e.toString(),
      ));
    }
  }
}

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tokosm_v2/service/product_service.dart';

part 'category_state.dart';

class CategoryCubit extends Cubit<CategoryState> {
  CategoryCubit() : super(CategoryInitial());

  void getProductCategory({required String token}) async {
    emit(CategoryLoading());
    try {
      Map<String, dynamic> categoryModel =
          await ProductService().getProductCategory(token: token);
      emit(CategorySuccess(categoryModel));
    } catch (e) {
      emit(CategoryFailure(e.toString()));
    }
  }
}

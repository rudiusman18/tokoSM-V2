import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tokosm_v2/service/product_service.dart';

part 'category_state.dart';

class CategoryCubit extends Cubit<CategoryState> {
  CategoryCubit() : super(CategoryInitial());

  void getProductCategory({
    required String token,
    String filter = "",
    List<Map<String, dynamic>>? selectedCategory,
  }) async {
    emit(CategoryLoading());
    try {
      Map<String, dynamic> categoryModel =
          await ProductService().getProductCategory(
        token: token,
        filter: filter,
      );

      if (selectedCategory != null) {
        for (var data in selectedCategory) {
          if ((categoryModel["data"] as List)
                  .map((e) => e['kat2_slug'])
                  .contains(data['kat2_slug']) ==
              false) {
            (categoryModel["data"] as List).insert(0, data);
          }
        }
      }

      emit(CategorySuccess(categoryModel));
    } catch (e) {
      emit(CategoryFailure(e.toString()));
    }
  }
}

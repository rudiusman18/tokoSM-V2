part of 'category_cubit.dart';

abstract class CategoryState {
  final Map<String, dynamic>? categoryModel;

  const CategoryState({this.categoryModel});
}

final class CategoryInitial extends CategoryState {
  CategoryInitial() : super(categoryModel: null);
}

final class CategoryLoading extends CategoryState {
  CategoryLoading() : super(categoryModel: null);
}

final class CategorySuccess extends CategoryState {
  final Map<String, dynamic>? categoryData;
  CategorySuccess(this.categoryData) : super(categoryModel: categoryData);
}

final class CategoryFailure extends CategoryState {
  final String error;
  CategoryFailure(this.error) : super(categoryModel: null);
}

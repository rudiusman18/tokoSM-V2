part of 'review_cubit.dart';

abstract class ReviewState {
  Map<String, dynamic>? reviewModel;

  ReviewState({this.reviewModel});
}

final class ReviewInitial extends ReviewState {}

final class ReviewLoading extends ReviewState {}

final class ReviewSuccess extends ReviewState {
  final Map<String, dynamic>? reviewModelData;
  ReviewSuccess({this.reviewModelData}) : super(reviewModel: reviewModelData);
}

final class ReviewFailure extends ReviewState {
  String? error;
  ReviewFailure({this.error}) : super();
}

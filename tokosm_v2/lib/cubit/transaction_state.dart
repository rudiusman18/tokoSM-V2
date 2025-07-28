part of 'transaction_cubit.dart';

sealed class TransactionState {
  final int transactionTabIndex;
  final TransactionModel? transactionModel;
  final TransactionModel? detailTransactionModel;
  TransactionState({
    this.transactionTabIndex = 0,
    this.transactionModel,
    this.detailTransactionModel,
  });
}

final class TransactionInitial extends TransactionState {}

final class TransactionLoading extends TransactionState {
  final int tabIndex;
  TransactionLoading(this.tabIndex) : super(transactionTabIndex: tabIndex);
}

final class TransactionSuccess extends TransactionState {
  final int tabIndex;
  final TransactionModel? transactionModelData;
  TransactionSuccess({
    required this.tabIndex,
    this.transactionModelData,
  }) : super(
            transactionTabIndex: tabIndex,
            transactionModel: transactionModelData);
}

final class TransactionFailure extends TransactionState {
  final int tabIndex;
  final String error;
  TransactionFailure(this.tabIndex, this.error)
      : super(transactionTabIndex: tabIndex);
}

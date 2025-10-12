part of 'transaction_cubit.dart';

sealed class TransactionState {
  final int transactionTabIndex;
  final TransactionModel? transactionModel;
  final TransactionData? selectedTransaction;
  TransactionState({
    this.transactionTabIndex = 0,
    this.transactionModel,
    this.selectedTransaction,
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
  final TransactionData? selectedTransactionData;
  TransactionSuccess({
    required this.tabIndex,
    this.transactionModelData,
    this.selectedTransactionData,
  }) : super(
          transactionTabIndex: tabIndex,
          transactionModel: transactionModelData,
          selectedTransaction: selectedTransactionData,
        );
}

final class TransactionFailure extends TransactionState {
  final int tabIndex;
  final String error;
  TransactionFailure(this.tabIndex, this.error)
      : super(transactionTabIndex: tabIndex);
}

// NOTE: Detail transaction
sealed class DetailTransactionState {
  TransactionModel? detailTransactionModel;
  DetailTransactionState({this.detailTransactionModel});
}

final class DetailTransactionInitial extends DetailTransactionState {}

final class DetailTransactionLoading extends DetailTransactionState {}

final class DetailTransactionSuccess extends DetailTransactionState {
  final TransactionModel? detailTransactionModelData;
  DetailTransactionSuccess(this.detailTransactionModelData)
      : super(detailTransactionModel: detailTransactionModelData);
}

final class DetailTransactionFailure extends DetailTransactionState {
  final String error;
  DetailTransactionFailure(this.error) : super();
}

// NOTE: Detail payment transaction (cara bayar)
sealed class DetailPaymentTransactionState {}

final class DetailPaymentTrasansactionInitial
    extends DetailPaymentTransactionState {}

final class DetailPaymentTransactionLoading
    extends DetailPaymentTransactionState {}

final class DetailPaymentTrasansactionSuccess
    extends DetailPaymentTransactionState {
  final Map<String, dynamic> detailPaymentTransactionData;
  DetailPaymentTrasansactionSuccess(this.detailPaymentTransactionData)
      : super();
}

final class DetailPaymentTrasansactionFailure
    extends DetailPaymentTransactionState {
  final String error;
  DetailPaymentTrasansactionFailure(this.error);
}

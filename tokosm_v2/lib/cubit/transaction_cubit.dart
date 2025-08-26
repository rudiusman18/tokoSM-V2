import 'package:bloc/bloc.dart';
import 'package:tokosm_v2/model/product_model.dart';
import 'package:tokosm_v2/model/transaction_model.dart';
import 'package:tokosm_v2/service/transaction_service.dart';

part 'transaction_state.dart';

class TransactionCubit extends Cubit<TransactionState> {
  TransactionCubit() : super(TransactionInitial());

  void setTabIndex(int index) {
    emit(TransactionSuccess(
      tabIndex: index,
      transactionModelData: state.transactionModel,
    ));
  }

  void getTransactionData({
    required String token,
    required String status,
    required String cabangId,
    required String search,
    required int page,
    required int limit,
  }) async {
    emit(TransactionLoading(state.transactionTabIndex));
    try {
      TransactionModel transactionModel =
          await TransactionService().getTransaction(
        token: token,
        cabangId: cabangId,
        status: status,
        search: search,
        page: page,
        limit: limit,
      );

      emit(TransactionSuccess(
        tabIndex: state.transactionTabIndex,
        transactionModelData: transactionModel,
      ));
    } catch (e) {
      emit(TransactionFailure(state.transactionTabIndex, e.toString()));
    }
  }

  void selectTransaction({required TransactionData transaction}) {
    emit(TransactionSuccess(
      tabIndex: state.transactionTabIndex,
      transactionModelData: state.transactionModel,
      selectedTransactionData: transaction,
    ));
  }

  Future<void> postTransaction({
    required String token,
    required String cabangId,
    required String userId,
    required String username,
    required String total,
    required String paymentMethod,
    required String addressID,
    required List<DataProduct> products,
  }) async {
    TransactionData? selectedTransaction = state.selectedTransaction;
    TransactionModel? transactionModel = state.transactionModel;
    emit(TransactionLoading(state.transactionTabIndex));
    try {
      await TransactionService().postTransaction(
        token: token,
        cabangId: cabangId,
        userId: userId,
        username: username,
        total: total,
        paymentMethod: paymentMethod,
        addressID: addressID,
        products: products,
      );
      emit(TransactionSuccess(
        tabIndex: state.transactionTabIndex,
        selectedTransactionData: selectedTransaction,
        transactionModelData: transactionModel,
      ));
    } catch (e) {
      emit(
        TransactionFailure(
          state.transactionTabIndex,
          e.toString(),
        ),
      );
    }
  }
}

class DetailTransactionCubit extends Cubit<DetailTransactionState> {
  DetailTransactionCubit() : super(DetailTransactionInitial());

  void getDetailTransactionData(
      {required String token, required String noInvoice}) async {
    emit(DetailTransactionLoading());
    try {
      TransactionModel detailTransaction = await TransactionService()
          .getDetailTransaction(token: token, noInvoice: noInvoice);

      emit(
        DetailTransactionSuccess(
          detailTransaction,
        ),
      );
    } catch (e) {
      emit(DetailTransactionFailure(e.toString()));
    }
  }
}

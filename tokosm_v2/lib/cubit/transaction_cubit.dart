import 'package:bloc/bloc.dart';
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
    required int page,
    required int limit,
  }) async {
    emit(TransactionLoading(state.transactionTabIndex));
    try {
      TransactionModel transactionModel = await TransactionService()
          .getTransaction(token: token, cabangId: cabangId, status: status);

      emit(TransactionSuccess(
        tabIndex: state.transactionTabIndex,
        transactionModelData: transactionModel,
      ));
    } catch (e) {
      emit(TransactionFailure(state.transactionTabIndex, e.toString()));
    }
  }
}

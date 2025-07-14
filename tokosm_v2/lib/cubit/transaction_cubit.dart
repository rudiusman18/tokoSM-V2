import 'package:bloc/bloc.dart';

part 'transaction_state.dart';

class TransactionCubit extends Cubit<TransactionState> {
  TransactionCubit() : super(TransactionInitial());
}

class TransactionTabFilterCubit extends Cubit<int> {
  TransactionTabFilterCubit() : super(0);

  void setTabIndex(int index) {
    emit(index);
  }
}

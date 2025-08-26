import 'package:flutter_bloc/flutter_bloc.dart';
part 'checkout_state.dart';

class CheckoutCubit extends Cubit<CheckoutState> {
  CheckoutCubit() : super(CheckoutInitial());

  void setPaymentMethod({required String paymentMethod}) {
    emit(
      CheckoutSuccess(
        paymentMethodString: paymentMethod,
      ),
    );
  }
}

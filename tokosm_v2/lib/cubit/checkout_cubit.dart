import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tokosm_v2/service/delivery_service.dart';
part 'checkout_state.dart';

class CheckoutCubit extends Cubit<CheckoutState> {
  CheckoutCubit() : super(CheckoutInitial());

  void setPaymentMethod({required String paymentMethod}) {
    emit(
      CheckoutSuccess(
        paymentMethodString: paymentMethod,
        courierModelData: state.courierModel,
        selectedCourierData: state.selectedCourier,
      ),
    );
  }

  Future<void> getCourier({
    required String token,
    required int cabangID,
  }) async {
    String? paymentMethod = state.paymentMethod;
    Map<String, dynamic>? selectedCourier = state.selectedCourier;
    emit(CheckoutLoading());
    try {
      var data =
          await DeliveryService().getCourier(token: token, cabangID: cabangID);

      if (selectedCourier == null) {
        selectedCourier = {...data};
        selectedCourier["data"] = [data["data"].first];
        selectCourier(selectedCourier: selectedCourier);
      }
      emit(CheckoutSuccess(
        courierModelData: data,
        paymentMethodString: paymentMethod,
        selectedCourierData: selectedCourier,
      ));
    } catch (e) {
      emit(CheckoutFailure(error: e.toString()));
    }
  }

  void selectCourier({required Map<String, dynamic> selectedCourier}) {
    emit(CheckoutSuccess(
      paymentMethodString: state.paymentMethod,
      courierModelData: state.courierModel,
      selectedCourierData: selectedCourier,
    ));
  }
}

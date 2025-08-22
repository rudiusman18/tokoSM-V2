import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tokosm_v2/model/address_model.dart';
import 'package:tokosm_v2/service/checkout_service.dart';

part 'address_state.dart';

class AddressCubit extends Cubit<AddressState> {
  AddressCubit() : super(AddressInitial());

  Future<void> getAddress({required String token}) async {
    AddressData? selectedAddressModel = state.selectedAddressModel;

    emit(AddressLoading());
    try {
      AddressModel? addressModel =
          await CheckoutService().getAddress(token: token);

      // ignore: prefer_conditional_assignment
      if (selectedAddressModel == null) {
        selectedAddressModel = addressModel.data
            ?.where((element) => element.isUtama == 1)
            .toList()
            .first;
      }

      emit(AddressSuccess(
        addressModelData: addressModel,
        selectedAddressModelData: selectedAddressModel,
      ));
    } catch (e) {
      emit(AddressFailure(error: e.toString()));
    }
  }
}

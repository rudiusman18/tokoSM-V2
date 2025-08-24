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

  Future<void> postAddress({
    required String token,
    required String addressName,
    required String receiverName,
    required String phoneNumber,
    required String address,
    required String province,
    required String city,
    required String district,
    required String subdistrict,
    required String postCode,
    required String note,
    required String lat,
    required String lng,
  }) async {
    AddressData? selectedAddressModel = state.selectedAddressModel;
    AddressModel? addressModel = state.addressModel;

    emit(AddressLoading());
    try {
      var _ = await CheckoutService().postAddress(
        token: token,
        addressName: addressName,
        receiverName: receiverName,
        phoneNumber: phoneNumber,
        address: address,
        province: province,
        city: city,
        district: district,
        subdistrict: subdistrict,
        postCode: postCode,
        note: note,
        lat: lat,
        lng: lng,
      );
      emit(
        AddressSuccess(
          addressModelData: addressModel,
          selectedAddressModelData: selectedAddressModel,
        ),
      );
    } catch (e) {
      emit(
        AddressFailure(
          error: e.toString(),
        ),
      );
    }
  }

  void selectAddress({required AddressData addressData}) {
    emit(
      AddressSuccess(
        addressModelData: state.addressModel,
        selectedAddressModelData: addressData,
      ),
    );
  }
}

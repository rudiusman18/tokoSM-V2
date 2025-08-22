part of 'address_cubit.dart';

abstract class AddressState {
  final AddressModel? addressModel;
  final AddressData? selectedAddressModel;
  const AddressState({this.addressModel, this.selectedAddressModel});
}

final class AddressInitial extends AddressState {}

final class AddressLoading extends AddressState {}

final class AddressSuccess extends AddressState {
  final AddressModel? addressModelData;
  final AddressData? selectedAddressModelData;
  AddressSuccess({
    this.addressModelData,
    this.selectedAddressModelData,
  }) : super(
          addressModel: addressModelData,
          selectedAddressModel: selectedAddressModelData,
        );
}

final class AddressFailure extends AddressState {
  final String? error;
  AddressFailure({this.error}) : super(addressModel: null);
}

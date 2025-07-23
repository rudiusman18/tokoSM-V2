part of 'cabang_cubit.dart';

abstract class CabangState {
  final CabangModel cabangModel;
  final DataCabang selectedCabangData;
  CabangState({required this.cabangModel, required this.selectedCabangData});
}

final class CabangInitial extends CabangState {
  CabangInitial()
      : super(cabangModel: CabangModel(), selectedCabangData: DataCabang());
}

final class CabangLoading extends CabangState {
  final DataCabang selectedCabang;
  CabangLoading({required this.selectedCabang})
      : super(cabangModel: CabangModel(), selectedCabangData: selectedCabang);
}

final class CabangSuccess extends CabangState {
  final CabangModel cabangModelData;
  final DataCabang selectedCabang;
  CabangSuccess({required this.cabangModelData, required this.selectedCabang})
      : super(
          cabangModel: cabangModelData,
          selectedCabangData: selectedCabang,
        );
}

final class CabangFailure extends CabangState {
  final String error;
  CabangFailure(this.error)
      : super(
          cabangModel: CabangModel(),
          selectedCabangData: DataCabang(),
        );
}

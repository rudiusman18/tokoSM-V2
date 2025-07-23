import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tokosm_v2/model/cabang_model.dart';
import 'package:tokosm_v2/service/cabang_service.dart';

part 'cabang_state.dart';

class CabangCubit extends Cubit<CabangState> {
  CabangCubit() : super(CabangInitial());

  void selectCabang({required DataCabang cabang}) {
    emit(CabangSuccess(
        cabangModelData: state.cabangModel, selectedCabang: cabang));
  }

  void getCabangData({
    required String token,
  }) async {
    try {
      CabangModel cabangModel =
          await CabangService().getCabangData(token: token);
      emit(
        CabangSuccess(
          cabangModelData: cabangModel,
          selectedCabang: state.selectedCabangData,
        ),
      );
    } catch (e) {
      emit(CabangFailure(e.toString()));
    }
  }
}

import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tokosm_v2/model/cabang_model.dart';
import 'package:tokosm_v2/service/cabang_service.dart';

part 'cabang_state.dart';

class CabangCubit extends Cubit<CabangState> {
  CabangCubit() : super(CabangInitial());

  Future<void> selectCabang({required DataCabang cabang}) async {
    final prefs = await SharedPreferences.getInstance();
    final dataCabang = cabang.toJson();
    final encodedDataCabang = jsonEncode(dataCabang);
    await prefs.setString('data_cabang', encodedDataCabang);
    emit(CabangSuccess(
        cabangModelData: state.cabangModel, selectedCabang: cabang));
  }

  void getCabangData({
    required String token,
  }) async {
    try {
      CabangModel cabangModel =
          await CabangService().getCabangData(token: token);

      final prefs = await SharedPreferences.getInstance();
      final cabangString = prefs.getString('data_cabang');
      if (cabangString != null) {
        final decodeDataCabang = jsonDecode(cabangString);
        final dataCabang = DataCabang.fromJson(decodeDataCabang);
        selectCabang(cabang: dataCabang);
        emit(
          CabangSuccess(
            cabangModelData: cabangModel,
            selectedCabang: dataCabang,
          ),
        );
      } else {
        emit(
          CabangSuccess(
            cabangModelData: cabangModel,
            selectedCabang: state.selectedCabangData,
          ),
        );
      }
    } catch (e) {
      emit(CabangFailure(e.toString()));
    }
  }
}

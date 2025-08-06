import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tokosm_v2/model/area_model.dart';
import 'package:tokosm_v2/service/setting_service.dart';

part 'setting_state.dart';

class AreaSettingCubit extends Cubit<AreaSettingState> {
  AreaSettingCubit() : super(AreaSettingInitial());

  Future<void> getAreaData({
    required String token,
    String? kabKota,
  }) async {
    emit(AreaSettingLoading());
    try {
      var areaModel = await SettingService()
          .getAreaData(token: token, kabKota: kabKota ?? "");
      emit(AreaSettingSuccess(areaModelData: areaModel));
    } catch (e) {
      emit(AreaSettingFailure(error: e.toString()));
    }
  }
}

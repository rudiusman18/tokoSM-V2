part of 'setting_cubit.dart';

sealed class AreaSettingState {
  final AreaModel? areaModel;

  AreaSettingState({this.areaModel});
}

final class AreaSettingInitial extends AreaSettingState {}

final class AreaSettingLoading extends AreaSettingState {}

final class AreaSettingSuccess extends AreaSettingState {
  final AreaModel? areaModelData;
  AreaSettingSuccess({this.areaModelData}) : super(areaModel: areaModelData);
}

final class AreaSettingFailure extends AreaSettingState {
  final String error;
  AreaSettingFailure({required this.error}) : super(areaModel: null);
}

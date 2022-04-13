part of 'temp_settings_bloc.dart';

enum TempUnit {
  celsius,
  fahrenheit,
}

class TempSettingState extends Equatable {
  final TempUnit tempUnit;
  TempSettingState({this.tempUnit = TempUnit.celsius});
  factory TempSettingState.initial() => TempSettingState();
  @override
  List<Object> get props => [tempUnit];

  @override
  String toString() => 'TempSettingState(tempUnit: $tempUnit)';

  TempSettingState copyWith({
    TempUnit? tempUnit,
  }) {
    return TempSettingState(
      tempUnit: tempUnit ?? this.tempUnit,
    );
  }
}

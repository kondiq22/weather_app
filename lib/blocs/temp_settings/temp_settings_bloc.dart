import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'temp_settings_event.dart';
part 'temp_settings_state.dart';

class TempSettingsBloc extends Bloc<TempSettingsEvent, TempSettingState> {
  TempSettingsBloc() : super(TempSettingState.initial()) {
    on<ToggleTempUnitEvent>(_toggleTempUnit);
  }

  FutureOr<void> _toggleTempUnit(
    ToggleTempUnitEvent event,
    Emitter<TempSettingState> emit,
  ) async {
    emit(state.copyWith(
        tempUnit: state.tempUnit == TempUnit.celsius
            ? TempUnit.fahrenheit
            : TempUnit.celsius));
  }
}

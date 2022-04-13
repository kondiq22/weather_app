import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:weather_app/constants/constants.dart';

part 'theme_state.dart';

class ThemeCubit extends Cubit<ThemeState> {
  ThemeCubit() : super(ThemeState.initial()) {}

  void setTheme(double currentTemp) {
    if (currentTemp < kWarmOrNot) {
      emit(state.copyWith(appTheme: AppTheme.dark));
    } else {
      emit(state.copyWith(appTheme: AppTheme.light));
    }
  }
}

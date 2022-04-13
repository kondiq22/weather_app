import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_app/cubits/weather/temp_settings/temp_settings_cubit.dart';
import 'package:weather_app/pages/home_page.dart';
import 'package:weather_app/services/weather_api_services.dart';
import 'package:http/http.dart' as http;

import 'cubits/weather/theme/theme_cubit.dart';
import 'cubits/weather/weather_cubit.dart';
import 'repositories/weather_repository.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) => WeatherRepository(
          weatherApiServices: WeatherApiServices(
        httpClient: http.Client(),
      )),
      child: MultiBlocProvider(
          providers: [
            BlocProvider<WeatherCubit>(
              create: (context) => WeatherCubit(
                weatherRepository: context.read<WeatherRepository>(),
              ),
            ),
            BlocProvider<TempSettingsCubit>(
              create: (context) => TempSettingsCubit(),
            ),
            BlocProvider<ThemeCubit>(
              create: (context) => ThemeCubit(
                weatherCubit: context.read<WeatherCubit>(),
              ),
            )
          ],
          child: BlocBuilder<ThemeCubit, ThemeState>(
            builder: (context, state) {
              return MaterialApp(
                title: 'Weather APP',
                debugShowCheckedModeBanner: false,
                theme:
                    context.read<ThemeCubit>().state.appTheme == AppTheme.light
                        ? ThemeData.light()
                        : ThemeData.dark(),
                home: HomePage(),
              );
            },
          )),
    );
  }
}

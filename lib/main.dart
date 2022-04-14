import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_app/pages/home_page.dart';
import 'package:weather_app/services/weather_api_services.dart';
import 'package:http/http.dart' as http;

import 'blocs/blocs.dart';

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
            BlocProvider<WeatherBloc>(
              create: (context) => WeatherBloc(
                weatherRepository: context.read<WeatherRepository>(),
              ),
            ),
            BlocProvider<TempSettingsBloc>(
              create: (context) => TempSettingsBloc(),
            ),
            BlocProvider<ThemeBloc>(
              create: (context) => ThemeBloc(),
            ),
          ],
          child: BlocListener<WeatherBloc, WeatherState>(
            listener: (context, state) {
              context.read<ThemeBloc>().setTheme(state.weather.theTemp);
            },
            child: BlocBuilder<ThemeBloc, ThemeState>(
              builder: (context, state) {
                return MaterialApp(
                  title: 'Weather APP',
                  debugShowCheckedModeBanner: false,
                  theme:
                      context.read<ThemeBloc>().state.appTheme == AppTheme.light
                          ? ThemeData.light()
                          : ThemeData.dark(),
                  home: HomePage(),
                );
              },
            ),
          )),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:weather_app/cubits/weather/weather_cubit.dart';
import 'package:weather_app/pages/search_page.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_app/pages/settings.dart';

import '../constants/constants.dart';
import '../cubits/weather/temp_settings/temp_settings_cubit.dart';
import '../widgets/error_dialog.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? _city;
  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Weather'),
        actions: [
          IconButton(
            onPressed: () async {
              _city = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: ((context) {
                    return SearchPage();
                  }),
                ),
              );
              print('city: $_city');
              if (_city != null) {
                context.read<WeatherCubit>().fetchWeather(_city!);
              }
            },
            icon: Icon(Icons.search),
          ),
          IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: ((context) {
                      return SettingsPage();
                    }),
                  ),
                );
              },
              icon: Icon(Icons.settings)),
        ],
      ),
      body: _showWeather(),
    );
  }

  String showTemperature(double temperature) {
    final tempUnit = context.watch<TempSettingsCubit>().state.tempUnit;
    if (tempUnit == TempUnit.fahrenheit) {
      return ((temperature * 9 / 5) + 32).toStringAsFixed(1) + '°F';
    }
    return temperature.toStringAsFixed(1) + '°C';
  }

  Widget _showIcon(String abbr) {
    return FadeInImage.assetNetwork(
        placeholder: 'assets/images/loading.gif',
        image: 'https://$kHost/static/img/weather/png/64/$abbr.png',
        width: 64,
        height: 64);
  }

  Widget _showWeather() {
    return BlocConsumer<WeatherCubit, WeatherState>(
      listener: (context, state) {
        if (state.status == WeatherStatus.error) {
          errorDialog(context, state.error.errMsg);
        }
      },
      builder: (context, state) {
        if (state.status == WeatherStatus.initial) {
          return Center(
            child: Text(
              'Select a city',
              style: TextStyle(fontSize: 20.0),
            ),
          );
        }
        if (state.status == WeatherStatus.loading) {
          return Center(child: CircularProgressIndicator());
        }
        if (state.status == WeatherStatus.error && state.weather.title == '') {
          return Center(
            child: Text(
              'Select a city',
              style: TextStyle(fontSize: 20.0),
            ),
          );
        }
        return Center(
            child: ListView(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height / 6,
            ),
            Text(
              state.weather.title,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 40.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 10.0,
            ),
            Text(
              TimeOfDay.fromDateTime(state.weather.lastUpdated).format(context),
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18.0),
            ),
            SizedBox(
              height: 60.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  showTemperature(state.weather.theTemp),
                  style: TextStyle(
                    fontSize: 30.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  width: 20.0,
                ),
                Column(
                  children: [
                    Text(
                      showTemperature(state.weather.theTemp),
                      style: TextStyle(
                        fontSize: 16.0,
                      ),
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    Text(
                      showTemperature(state.weather.minTemp),
                      style: TextStyle(
                        fontSize: 16.0,
                      ),
                    )
                  ],
                )
              ],
            ),
            SizedBox(
              height: 40.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Spacer(),
                _showIcon(state.weather.weatherStateAbbr),
                SizedBox(
                  width: 20.0,
                ),
                Text(
                  state.weather.weatherStateName,
                  style: TextStyle(fontSize: 32.0),
                ),
                Spacer(),
              ],
            )
          ],
        ));
      },
    );
  }
}

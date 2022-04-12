import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_app/cubits/weather/temp_settings/temp_settings_cubit.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Settings')),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
        child: ListTile(
          title: Text('Temperature Unit'),
          subtitle: Text('Celsius/Fahrenheit (Default: Celsius)'),
          trailing: Switch(
            value: context.watch<TempSettingsCubit>().state.tempUnit ==
                TempUnit.celsius,
            onChanged: (_) {
              context.read<TempSettingsCubit>().toggleTempUnit();
            },
          ),
        ),
      ),
    );
  }
}

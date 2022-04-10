import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:weather_app/services/http_error_handler.dart';

import '../constants/constants.dart';
import '../exceptions/weather_exceptions.dart';

class WeatherApiServices {
  final http.Client httpClient;
  WeatherApiServices({
    required this.httpClient,
  });

  Future<int> getWoeid(String city) async {
    final Uri uri = Uri(
        scheme: 'https',
        host: kHost,
        path: '/api/location/search/',
        queryParameters: {
          'query': city,
        });
    try {
      final http.Response response = await http.get(uri);
      if (response.statusCode != 200) {
        throw Exception(httpErrorHandler(response));
      }
      final responseBody = json.decode(response.body);

      if (responseBody.isEmpty) {
        throw WeatherExceptions('Cannot get the woeid of $city');
      }

      if (responseBody.length > 1) {
        throw WeatherExceptions(
            'There are multiple candidates for $city/nPlease specify further!');
      }
      return responseBody[0]['woeid'];
    } catch (e) {
      rethrow;
    }
  }
}

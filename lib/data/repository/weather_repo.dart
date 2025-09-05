import 'dart:convert';

import 'package:weather_app/data/data_provider/weather_data_provider.dart';
import 'package:weather_app/models/weather_model.dart';



class WeatherRepository {
  final WeatherDataProvider weatherDataProvider;

  WeatherRepository(this.weatherDataProvider);

  Future<WeatherModel> getCurrentWeather(String cityName) async {
    try {
      print("Fetching weather for: $cityName");

      final weatherData =
      await weatherDataProvider.getCurrentWeather(cityName);

      print(" Raw API response: $weatherData");

      final data = jsonDecode(weatherData);

      print(" Parsed response cod: ${data['cod']}");

      if (data['cod'] != '200') {
        final message = data['message'] ?? 'Unknown error';
        throw 'API Error: ${data['cod']} - $message';
      }

      final model = WeatherModel.fromMap(data);

      print(" Weather parsed successfully: ${model.currentTemp}K, ${model.currentSky}");

      return model;
    } catch (e, stack) {

      throw e.toString();
    }
  }
}
import 'dart:convert';

import 'package:weather_app/data/data_provider/weather_data_provider.dart';
import 'package:weather_app/models/weather_model.dart';

class WeatherRepository {
  final WeatherDataProvider weatherDataProvider;

  WeatherRepository({required this.weatherDataProvider});

  // Existing city fetch
  Future<WeatherModel> getCurrentWeather(String cityName) async {
    final weatherData = await weatherDataProvider.getCurrentWeather(cityName);
    final data = jsonDecode(weatherData);
    if (data['cod'] != '200') {
      throw 'API Error: ${data['cod']} - ${data['message']}';
    }
    return WeatherModel.fromMap(data);
  }

  // Fetch weather by GPS coordinates
  Future<WeatherModel> getCurrentWeatherByLocation(double lat, double lon) async {
    final weatherData = await weatherDataProvider.getCurrentWeatherByLocation(lat, lon);
    final data = jsonDecode(weatherData);
    if (data['cod'] != '200') {
      throw 'API Error: ${data['cod']} - ${data['message']}';
    }
    return WeatherModel.fromMap(data);
  }
}



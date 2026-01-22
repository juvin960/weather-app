import 'package:http/http.dart' as http;

import '../../secrets.dart';

class WeatherDataProvider {
  final String openWeatherAPIKey = myOpenWeatherAPIKey;

  // Fetch weather by city name (existing)
  Future<String> getCurrentWeather(String cityName) async {
    try {
      final res = await http.get(
        Uri.parse(
          'http://api.openweathermap.org/data/2.5/forecast?q=$cityName&appid=$openWeatherAPIKey&units=metric',
        ),
      );

      if (res.statusCode != 200) {
        throw "Failed to fetch weather data: ${res.statusCode}";
      }

      return res.body;
    } catch (e) {
      throw e.toString();
    }
  }

  //  New: Fetch weather by latitude & longitude
  Future<String> getCurrentWeatherByLocation(
      double lat,
      double lon,
      ) async {
    try {
      final res = await http.get(
        Uri.parse(
          'http://api.openweathermap.org/data/2.5/forecast?lat=$lat&lon=$lon&appid=$openWeatherAPIKey&units=metric',
        ),
      );

      if (res.statusCode != 200) {
        throw "Failed to fetch weather data: ${res.statusCode}";
      }

      return res.body;
    } catch (e) {
      throw e.toString();
    }
  }
}

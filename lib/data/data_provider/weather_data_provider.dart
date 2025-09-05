import 'package:http/http.dart' as http;

import '../../secrets.dart';

class WeatherDataProvider {
  Future<String> getCurrentWeather(String cityName) async {
    try {
      final res = await http.get(
        Uri.parse(
          'http://api.openweathermap.org/data/2.5/forecast?q=$cityName&appid=$openWeatherAPIKey',
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
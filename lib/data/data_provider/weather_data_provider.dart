import 'package:http/http.dart' as http;

import '../../secrets.dart';


class WeatherDataProvider {
  // Asynchronous function to get current weather for a given city
  Future<String> getCurrentWeather(String cityName) async {
    try {
      // Make an HTTP GET request to the OpenWeatherMap forecast API  passing  cityName as a query parameter.
      final res = await http.get(
        Uri.parse(
          'http://api.openweathermap.org/data/2.5/forecast?q=$cityName&appid=$openWeatherAPIKey',
        ),
      );

      // Check if the response status code is not 200 (OK)
      if (res.statusCode != 200) {
        // If it's not OK, throw an error with the status code
        throw "Failed to fetch weather data: ${res.statusCode}";
      }

      // If successful, return the raw JSON response body as a String
      return res.body;
    } catch (e) {
      // Catch any error and throw it as a string message
      throw e.toString();
    }
  }
}

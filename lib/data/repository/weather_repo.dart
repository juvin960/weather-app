import 'dart:convert';

import 'package:weather_app/data/data_provider/weather_data_provider.dart';
import 'package:weather_app/models/weather_model.dart';

// Repository layer for handling weather data logic
// Is the bridge between the Data Provider (raw API calls) and the ViewModel (UI state).
class WeatherRepository {
  // Dependency: uses WeatherDataProvider to make API requests
  final WeatherDataProvider weatherDataProvider;

  // Constructor injection
  WeatherRepository(this.weatherDataProvider);

  // Fetch weather data for a specific city and return a WeatherModel
  Future<WeatherModel> getCurrentWeather(String cityName) async {
    try {
      print("Fetching weather for: $cityName");

      //  Call the provider to fetch raw API response (as String)
      final weatherData =
      await weatherDataProvider.getCurrentWeather(cityName);

      print(" Raw API response: $weatherData");

      //  Decode the JSON string into a Map
      final data = jsonDecode(weatherData);

      print(" Parsed response cod: ${data['cod']}");


      if (data['cod'] != '200') {
        final message = data['message'] ?? 'Unknown error';
        throw 'API Error: ${data['cod']} - $message';
      }

      final model = WeatherModel.fromMap(data);

      print(" Weather parsed successfully: ${model.currentTemp}K, ${model.currentSky}");

      // Return the WeatherModel to the caller
      return model;
    } catch (e, stack) {
      // Network and logic error is caught here

      throw e.toString();
    }
  }
}

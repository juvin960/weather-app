import 'package:flutter/foundation.dart';
import 'package:weather_app/models/weather_model.dart';
import 'package:weather_app/models/forecast_model.dart';
import '../data/repository/weather_repo.dart';

class WeatherViewModel extends ChangeNotifier {
  final WeatherRepository weatherRepository;

  WeatherViewModel({required this.weatherRepository});

  WeatherModel? _weather;
  WeatherModel? get weather => _weather;

  List<HourlyForecast> _hourlyForecast = [];
  List<HourlyForecast> get hourlyForecast => _hourlyForecast;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  /// fetches the weather of a cit name [cityName]
  Future<void> fetchWeather(String cityName) async {
    //show progress bar
    _isLoading = true;
    // resetting the error variable
    _errorMessage = null;
    // notify listener of the above variable changes
    notifyListeners();

    try {
      // call function getCurrentWeather() to get current weather for cityName
      final result = await weatherRepository.getCurrentWeather(cityName);
      // initialize _weather with the results from getCurrentWeather
      _weather = result;

      _hourlyForecast = (result.rawList ?? [])
          .skip(1)
          .take(5)
          .map((map) => HourlyForecast.fromMap(map))
          .toList();
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      // hide progress bar
      _isLoading = false;
      // notify listener of the above variable changes
      notifyListeners();
    }
  }
}

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

  Future<void> fetchWeather(String cityName) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final result = await weatherRepository.getCurrentWeather(cityName);
      _weather = result;

      _hourlyForecast = (result.rawList ?? [])
          .skip(1)
          .take(5)
          .map((map) => HourlyForecast.fromMap(map))
          .toList();
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import '../models/weather_model.dart';
import '../models/forecast_model.dart';
import '../data/repository/weather_repo.dart';

class WeatherViewModel extends ChangeNotifier {
  final WeatherRepository weatherRepository;

  WeatherViewModel({required this.weatherRepository}) {
    fetchWeatherByCurrentLocation(); // Auto-load on init
  }

  WeatherModel? _weather;
  WeatherModel? get weather => _weather;

  List<HourlyForecast> _hourlyForecast = [];
  List<HourlyForecast> get hourlyForecast => _hourlyForecast;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  // Fetch weather by city name
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

  // Fetch weather by device GPS
  Future<void> fetchWeatherByCurrentLocation() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final position = await _getCurrentLocation();

      final result = await weatherRepository.getCurrentWeatherByLocation(
        position.latitude,
        position.longitude,
      );

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

  // 🔹 Helper: Get current device location
  Future<Position> _getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception('Location services are disabled');
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      throw Exception('Location permission denied');
    }

    // New geolocator API uses LocationSettings
    return await Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
      ),
    );
  }
}

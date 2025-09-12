import 'dart:convert';


class WeatherModel {

  final double currentTemp;
  final String currentSky;
  final double currentPressure;
  final double currentWindSpeed;
  final double currentHumidity;
  //Keeps the raw weather list returned by the API for further use (hourly forecast)
  final List<dynamic>? rawList;

  // Constructor
  WeatherModel({
    required this.currentTemp,
    required this.currentSky,
    required this.currentPressure,
    required this.currentWindSpeed,
    required this.currentHumidity,
    this.rawList,
  });

  // Creates a new WeatherModel with some updated values while keeping others unchanged
  WeatherModel copyWith({
    double? currentTemp,
    String? currentSky,
    double? currentPressure,
    double? currentWindSpeed,
    double? currentHumidity,
  }) {
    return WeatherModel(
      currentTemp: currentTemp ?? this.currentTemp,
      currentSky: currentSky ?? this.currentSky,
      currentPressure: currentPressure ?? this.currentPressure,
      currentWindSpeed: currentWindSpeed ?? this.currentWindSpeed,
      currentHumidity: currentHumidity ?? this.currentHumidity,
    );
  }

  // Converts the WeatherModel into a Map (useful for JSON encoding or debugging)
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'currentTemp': currentTemp,
      'currentSky': currentSky,
      'currentPressure': currentPressure,
      'currentWindSpeed': currentWindSpeed,
      'currentHumidity': currentHumidity,
    };
  }

  // Factory constructor: creates a WeatherModel from a Map (API response)
  factory WeatherModel.fromMap(Map<String, dynamic> map) {
    // Take the first item in the "list" array (the most recent forecast/current data)
    final currentWeather = map['list'][0];

    return WeatherModel(
      currentTemp: (currentWeather['main']['temp'] as num).toDouble(),
      currentSky: currentWeather['weather'][0]['main'],
      currentPressure: (currentWeather['main']['pressure'] as num).toDouble(),
      currentWindSpeed: (currentWeather['wind']['speed'] as num).toDouble(),
      currentHumidity: (currentWeather['main']['humidity'] as num).toDouble(),
      // Save full list for later (e.g., hourly forecast)
      rawList: map['list'],
    );
  }

  // Convert the WeatherModel into a JSON string
  String toJson() => json.encode(toMap());

  // Create a WeatherModel object from a JSON string
  factory WeatherModel.fromJson(String source) =>
      WeatherModel.fromMap(json.decode(source) as Map<String, dynamic>);

  // For debugging/logging: return a readable string representation
  @override
  String toString() {
    return 'WeatherModel(currentTemp: $currentTemp, currentSky: $currentSky, currentPressure: $currentPressure, currentWindSpeed: $currentWindSpeed, currentHumidity: $currentHumidity)';
  }

  // Equality operator override: allows comparing two WeatherModel objects by value
  @override
  bool operator ==(covariant WeatherModel other) {
    if (identical(this, other)) return true;

    return other.currentTemp == currentTemp &&
        other.currentSky == currentSky &&
        other.currentPressure == currentPressure &&
        other.currentWindSpeed == currentWindSpeed &&
        other.currentHumidity == currentHumidity;
  }

  // Hash code override: ensures consistent hashing for sets/maps
  @override
  int get hashCode {
    return currentTemp.hashCode ^
    currentSky.hashCode ^
    currentPressure.hashCode ^
    currentWindSpeed.hashCode ^
    currentHumidity.hashCode;
  }
}

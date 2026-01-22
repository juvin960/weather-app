import 'dart:convert';

import 'dart:convert';

class WeatherModel {
  final String cityName;

  final double currentTemp;
  final String currentSky;
  final double currentPressure;
  final double currentWindSpeed;
  final double currentHumidity;


  final List<dynamic>? rawList;

  WeatherModel({
    required this.cityName,
    required this.currentTemp,
    required this.currentSky,
    required this.currentPressure,
    required this.currentWindSpeed,
    required this.currentHumidity,
    this.rawList,
  });


  WeatherModel copyWith({
    String? cityName,
    double? currentTemp,
    String? currentSky,
    double? currentPressure,
    double? currentWindSpeed,
    double? currentHumidity,
    List<dynamic>? rawList,
  }) {
    return WeatherModel(
      cityName: cityName ?? this.cityName,
      currentTemp: currentTemp ?? this.currentTemp,
      currentSky: currentSky ?? this.currentSky,
      currentPressure: currentPressure ?? this.currentPressure,
      currentWindSpeed: currentWindSpeed ?? this.currentWindSpeed,
      currentHumidity: currentHumidity ?? this.currentHumidity,
      rawList: rawList ?? this.rawList,
    );
  }


  Map<String, dynamic> toMap() {
    return {
      'cityName': cityName,
      'currentTemp': currentTemp,
      'currentSky': currentSky,
      'currentPressure': currentPressure,
      'currentWindSpeed': currentWindSpeed,
      'currentHumidity': currentHumidity,
    };
  }

  // Create from API response
  factory WeatherModel.fromMap(Map<String, dynamic> map) {
    final currentWeather = map['list'][0];

    return WeatherModel(
      cityName: map['city']['name'],
      currentTemp: (currentWeather['main']['temp'] as num).toDouble(),
      currentSky: currentWeather['weather'][0]['main'],
      currentPressure: (currentWeather['main']['pressure'] as num).toDouble(),
      currentWindSpeed: (currentWeather['wind']['speed'] as num).toDouble(),
      currentHumidity: (currentWeather['main']['humidity'] as num).toDouble(),
      rawList: map['list'],
    );
  }


  String toJson() => json.encode(toMap());

  factory WeatherModel.fromJson(String source) =>
      WeatherModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'WeatherModel(cityName: $cityName, temp: $currentTemp, sky: $currentSky)';
  }

  @override
  bool operator ==(covariant WeatherModel other) {
    if (identical(this, other)) return true;

    return other.cityName == cityName &&
        other.currentTemp == currentTemp &&
        other.currentSky == currentSky &&
        other.currentPressure == currentPressure &&
        other.currentWindSpeed == currentWindSpeed &&
        other.currentHumidity == currentHumidity;
  }

  @override
  int get hashCode {
    return cityName.hashCode ^
    currentTemp.hashCode ^
    currentSky.hashCode ^
    currentPressure.hashCode ^
    currentWindSpeed.hashCode ^
    currentHumidity.hashCode;
  }
}


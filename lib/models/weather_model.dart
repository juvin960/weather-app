
import 'dart:convert';

class WeatherModel {

  final double currentTemp;
  final String currentSky;
  final double currentPressure;
  final double currentWindSpeed;
  final double currentHumidity;
  final List<dynamic>? rawList;
  WeatherModel({
    required this.currentTemp,
    required this.currentSky,
    required this.currentPressure,
    required this.currentWindSpeed,
    required this.currentHumidity,
    this.rawList,
  });

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

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'currentTemp': currentTemp,
      'currentSky': currentSky,
      'currentPressure': currentPressure,
      'currentWindSpeed': currentWindSpeed,
      'currentHumidity': currentHumidity,
    };
  }

  factory WeatherModel.fromMap(Map<String, dynamic> map) {
    final currentWeather = map['list'][0];

    return WeatherModel(
      currentTemp: (currentWeather['main']['temp'] as num).toDouble(),
      currentSky: currentWeather['weather'][0]['main'],
      currentPressure: (currentWeather['main']['pressure'] as num).toDouble(),
      currentWindSpeed: (currentWeather['wind']['speed'] as num).toDouble(),
      currentHumidity: (currentWeather['main']['humidity'] as num).toDouble(),
      rawList: map['list'],
    );
  }
 

  String toJson() => json.encode(toMap());

  factory WeatherModel.fromJson(String source) => WeatherModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'WeatherModel(currentTemp: $currentTemp, currentSky: $currentSky, currentPressure: $currentPressure, currentWindSpeed: $currentWindSpeed, currentHumidity: $currentHumidity)';
  }

  @override
  bool operator ==(covariant WeatherModel other) {
    if (identical(this, other)) return true;

    return
      other.currentTemp == currentTemp &&
          other.currentSky == currentSky &&
          other.currentPressure == currentPressure &&
          other.currentWindSpeed == currentWindSpeed &&
          other.currentHumidity == currentHumidity;
  }

  @override
  int get hashCode {
    return currentTemp.hashCode ^
    currentSky.hashCode ^
    currentPressure.hashCode ^
    currentWindSpeed.hashCode ^
    currentHumidity.hashCode;
  }
}

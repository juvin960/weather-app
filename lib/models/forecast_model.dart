class HourlyForecast {
  final DateTime time;
  final String sky;
  final double temp;

  HourlyForecast({
    required this.time,
    required this.sky,
    required this.temp,
  });

  factory HourlyForecast.fromMap(Map<String, dynamic> map) {
    return HourlyForecast(
      time: DateTime.parse(map['dt_txt']),
      sky: map['weather'][0]['main'],
      temp: (map['main']['temp'] as num).toDouble(),
    );
  }
}

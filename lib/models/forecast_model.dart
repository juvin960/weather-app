
class HourlyForecast {

  final DateTime time;
  final String sky;
  final double temp;

  // Constructor to create an HourlyForecast instance
  HourlyForecast({
    required this.time,
    required this.sky,
    required this.temp,
  });

  // Factory constructor to create an HourlyForecast object from a Map (API response)
  factory HourlyForecast.fromMap(Map<String, dynamic> map) {
    return HourlyForecast(
      // Convert the string timestamp into a DateTime object
      time: DateTime.parse(map['dt_txt']),

      // Extract the sky condition (first item in the "weather" array, field "main")
      sky: map['weather'][0]['main'],

      // Convert temperature to double (handles both int and double from API)
      temp: (map['main']['temp'] as num).toDouble(),
    );
  }
}

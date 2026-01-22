import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../view_model/weather_view_model.dart';
import '../widgets/additional_info_item.dart';
import '../widgets/hourly_forecast_item.dart';


class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      context.read<WeatherViewModel>().fetchWeatherByCurrentLocation();
    });
  }

  @override
  Widget build(BuildContext context) {
    final weatherVM = context.watch<WeatherViewModel>();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Weather App",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () => weatherVM.fetchWeatherByCurrentLocation(),
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: Builder(
        builder: (_) {
          if (weatherVM.isLoading) {
            return const Center(child: CircularProgressIndicator.adaptive());
          }

          if (weatherVM.errorMessage != null) {
            return Center(child: Text(weatherVM.errorMessage!));
          }

          final weather = weatherVM.weather;
          if (weather == null) {
            return const Center(child: Text("No data available"));
          }

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                SizedBox(
                  width: double.infinity,
                  child: Card(
                    elevation: 10,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            children: [
                              // City Name
                              Text(
                                weather.cityName,
                                style: const TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 8),


                              Text(
                                '${weather.currentTemp.round()}°C',
                                style: const TextStyle(
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 16),

                              // Weather Icon
                              Icon(
                                weather.currentSky == 'Clouds' ||
                                    weather.currentSky == 'Rain'
                                    ? Icons.cloud
                                    : Icons.sunny,
                                size: 64,
                              ),
                              const SizedBox(height: 16),

                              // Sky Description
                              Text(
                                weather.currentSky,
                                style: const TextStyle(fontSize: 20),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // Hourly Forecast
                const Text(
                  'Hourly Forecast',
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),

                SizedBox(
                  height: 120,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: weatherVM.hourlyForecast.length,
                    itemBuilder: (context, index) {
                      final forecast = weatherVM.hourlyForecast[index];
                      return HourlyForecastItem(
                        time: DateFormat.Hm().format(forecast.time),
                        icon: forecast.sky == 'Clouds' || forecast.sky == 'Rain'
                            ? Icons.cloud
                            : Icons.sunny,
                        temperature: '${forecast.temp.round()}°C',
                      );
                    },
                  ),
                ),

                const SizedBox(height: 20),

                // Additional Information
                const Text(
                  'Additional Information',
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    AdditionalInfoItem(
                      icon: Icons.water_drop,
                      label: 'Humidity',
                      value: '${weather.currentHumidity}%',
                    ),
                    AdditionalInfoItem(
                      icon: Icons.air,
                      label: 'Wind',
                      value: '${weather.currentWindSpeed} m/s',
                    ),
                    AdditionalInfoItem(
                      icon: Icons.speed,
                      label: 'Pressure',
                      value: '${weather.currentPressure} hPa',
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

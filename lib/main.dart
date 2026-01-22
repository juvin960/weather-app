import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather_app/data/data_provider/weather_data_provider.dart';
import 'package:weather_app/view/screens/weather_screen.dart';
import 'package:weather_app/view_model/weather_view_model.dart';

import 'data/repository/weather_repo.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) =>
          WeatherViewModel(
            weatherRepository: WeatherRepository(
              weatherDataProvider: WeatherDataProvider(),
            ),
          ),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData.dark(useMaterial3: true),
        home: const WeatherScreen(),
      ),
    );
  }
}

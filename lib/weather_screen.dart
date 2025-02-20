import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weather_app/secrets.dart';
import 'additional_info_item.dart';
import 'hourly_forecast_item.dart';
import 'package:http/http.dart' as http;

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  late Future<Map<String, dynamic>> weather;
  Future<Map<String, dynamic>> getCurrentWeather() async{
    try{
      String cityName = 'London';
      final res = await http.get(
        Uri.parse('http://api.openweathermap.org/data/2.5/forecast?q=$cityName,uk&APPID=$openWeatherAPIKey'),
      );
      final data = jsonDecode(res.body);

      if (data['cod']!= '200'){
        throw 'An unexpected error occurred';
      }
      return data;
    }catch (e) {
      throw e.toString();
    }
  }
  @override
  void initState() {
    super.initState();
    weather = getCurrentWeather();
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        title: const Text(
            "Weather App",
                style:TextStyle(
            fontWeight: FontWeight.bold,
        ),
        ),
        centerTitle: true,
        actions:  [
           IconButton(
             onPressed:(){
               setState(() {
                 weather = getCurrentWeather();
               });
             },
             icon: const Icon(Icons.refresh),
           ),
        ],
      ),
      body: FutureBuilder(
        future:weather,
        builder: (context, snapshot) {
          if(snapshot.connectionState == ConnectionState.waiting){
            return const Center(
                child: CircularProgressIndicator.adaptive(),
            );
          }

          if (snapshot.hasError){
            return Center(
                child: Text(snapshot.error.toString()),
            );
          }

          final data = snapshot.data!;

          final currentWeather = data['list'][0] ;

          final currentTemp = currentWeather['main']['temp'];
          final currentSky = currentWeather['weather'][0]['main'];
          final currentPressure = currentWeather['main']['pressure'];
          final currentWind = currentWeather['wind']['speed'];
          final currentHumidity = currentWeather['main']['humidity'];

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
                      filter: ImageFilter.blur(
                        sigmaX: 10,
                        sigmaY: 10,
                      ),
                      child:  Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            Text(
                             '$currentTemp K',
                                 style: const TextStyle(
                                   fontSize: 32,
                                   fontWeight: FontWeight.bold,
                                 ),
                            ),
                            const SizedBox(height: 16),
                             Icon(
                             currentSky == 'Clouds' || currentSky == 'Rain' ? Icons.cloud: Icons.sunny,
                              size: 64,
                            ),
                            const SizedBox(height: 16),
                             Text(
                               currentSky,
                              style: const TextStyle(
                                fontSize: 20,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Text('Hourly Forecast',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                height: 120,
                child: ListView.builder(
                    itemCount: 5,
                  scrollDirection: Axis.horizontal,
                    itemBuilder:(context, index){
                      final hourlyForecast = data['list'][index + 1];
                      final hourlySky = data['list'][index + 1]['weather'][0]['main'];
                      final time = DateTime.parse(hourlyForecast['dt_txt']);
                      return HourlyForecastItem(
                          time:DateFormat.Hm().format(time),
                          icon: hourlySky == 'Clouds' ||  hourlySky == 'Rain'
                                     ? Icons.cloud
                                     : Icons.sunny,

                          temperature: hourlyForecast['main']['temp'].toString(),
                      );
                    },
                ),
              ),
              const SizedBox(height: 20),
              const Text('Additional Information',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
           Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              AdditionalInfoItem(
                icon: Icons.water_drop,
                label: 'Humidity',
                value: currentHumidity.toString(),
              ),
              AdditionalInfoItem(
                icon: Icons.air,
                label: 'Wind Speed',
                value: currentWind.toString(),
              ),
              AdditionalInfoItem(
                  icon: Icons.beach_access,
                  label: 'pressure',
                  value: currentPressure.toString(),

              ),

            ],
          ),
            ],
          ),
        );
        },
      ) ,
    );
  }
}




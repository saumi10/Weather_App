import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:weather_app/additional_info_widget.dart';
import 'package:weather_app/hourly_forecast_item.dart';
import 'package:http/http.dart' as http;

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  double currentTemperature = 0;
  bool isLoading = false;
  @override
  void initState() {
    super.initState();
    getCurrentWeather();
  }

  Future getCurrentWeather() async {
    try {
      setState(() {
        isLoading = true;
      });
      String cityName = 'Noida';
      final res = await http.get(
        Uri.parse(
          'https://api.openweathermap.org/data/2.5/forecast?q=$cityName&APPID=87249731fb9331ea382d2f24fe2dba8d',
        ),
      );

      final data = jsonDecode(res.body);
      if (data['cod'] != '200') {
        throw 'An unexpected error occurred';
      }
      setState(() {
        currentTemperature = data['list'][0]['main']['temp'] - 273.15;
        isLoading = false;
      });
    } catch (e) {
      throw e.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Weather App',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle:
            true, //to centre align our appBar's title text, without using container
        actions: [
          //for icons like back button or refresh on app bar
          IconButton(
            //provides padding by default
            onPressed: () {},
            icon: const Icon(Icons.refresh),
            color: Colors.blue,
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //main card
                  SizedBox(
                    //just using width property so no need to use container widget
                    width: double.infinity,
                    child: Card(
                      //card widget to use properties like elevation which column doesnt have
                      elevation: 20,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      //ClipRRect widget helping to put border radius and separate the blur effect from background
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                          child: Padding(
                            padding: EdgeInsets.all(16.0),
                            child: Column(
                              children: [
                                Text(
                                  '${currentTemperature != 0 ? currentTemperature.toStringAsFixed(2) : currentTemperature.toStringAsFixed(0)} °C',
                                  style: const TextStyle(
                                    fontSize: 32,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 20),
                                Icon(
                                  Icons.cloud,
                                  size: 62,
                                  color: Colors.white,
                                ),
                                const SizedBox(height: 20),
                                Text(
                                  'Rain',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.normal,
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
                  const Text(
                    'Weather Forecast',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 10),
                  //making hourly forecast cards below
                  //scrollView
                  const SingleChildScrollView(
                    //changing scroll view axis to horizontal
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        //made a card widget at the bottom ,outside of this stateless widget,so as to use it everywhere instead of making the whole card widget 5 times
                        //CARD1
                        HourlyForecastItem(
                          time: '00:00',
                          icon: Icons.mode_night,
                          temperature: '77°F',
                        ),
                        //CARD2
                        HourlyForecastItem(
                          time: '03:00',
                          icon: Icons.mode_night,
                          temperature: '77°F',
                        ),
                        //CARD3
                        HourlyForecastItem(
                          time: '06:00',
                          icon: Icons.sunny,
                          temperature: '77°F',
                        ),
                        //CARD4
                        HourlyForecastItem(
                          time: '09:00',
                          icon: Icons.sunny,
                          temperature: '77°F',
                        ),
                        //CARD5
                        HourlyForecastItem(
                          time: '12:00',
                          icon: Icons.sunny,
                          temperature: '77°F',
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),
                  //additional info
                  const Text(
                    'Additional Information',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      AdditionalInfoWidget(
                        icon: Icons.water_drop,
                        label: 'Humidity',
                        value: '94',
                      ),
                      AdditionalInfoWidget(
                        icon: Icons.thermostat,
                        label: 'Pressure',
                        value: '1006',
                      ),
                      AdditionalInfoWidget(
                        icon: Icons.air,
                        label: 'Wind Speed',
                        value: '7',
                      ),
                    ],
                  ),
                ],
              ),
            ),
    );
  }
}

import 'package:flutter/material.dart';
import '../services/api_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String city = "Moscow";
  Map<String, dynamic>? weather;

  @override
  void initState() {
    super.initState();
    fetchWeather();
  }

  Future<void> fetchWeather() async {
    try {
      final weatherData = await ApiService.getWeather(city);
      if (!mounted) return;
      setState(() {
        weather = weatherData;
      });
    } catch (e) {
      print("Ошибка при получении данных: $e");
    }
  }

  IconData getWeatherIcon(String condition) {
    switch (condition.toLowerCase()) {
      case 'clear':
        return Icons.wb_sunny;
      case 'clouds':
        return Icons.cloud;
      case 'rain':
        return Icons.grain;
      case 'snow':
        return Icons.ac_unit;
      case 'mist':
        return Icons.blur_on;
      case 'storm':
        return Icons.flash_on;
      default:
        return Icons.wb_cloudy;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Гардеробус")),
      body: weather == null
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Container(
                    width: 370,
                    height: 100,
                    decoration: BoxDecoration(
                      color: const Color(0xFF62DEFA),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Stack(
                      children: [
                        Positioned(
                          left: 8,
                          top: 10,
                          child: Text(
                            '${weather!["temperature"]}°C',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 48,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                        Positioned(
                          left: 105,
                          top: 57,
                          child: Text(
                            '${weather!["humidity"]}%',
                            style: TextStyle(
                              color: const Color(0xFF1E1E1E),
                              fontSize: 32,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                        Positioned(
                          right: 20,
                          top: 25,
                          child: Icon(
                            getWeatherIcon(weather!["condition"]),
                            size: 48,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    width: 370,
                    height: 200,
                    decoration: BoxDecoration(
                      color: const Color(0xFF62DEFA),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'Давление: ${weather!["pressure"]} мм рт. ст.',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 32,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'Скорость ветра: ${weather!["wind_speed"]} м/с',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    width: 370,
                    height: 154.94,
                    decoration: BoxDecoration(
                      color: const Color(0xFF62DEFA),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'Утром прохладно, но днём будет теплее',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Container(
                              width: 76,
                              height: 102,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: NetworkImage("https://placehold.co/77x102"),
                                  fit: BoxFit.cover,
                                ),
                                borderRadius: BorderRadius.circular(15),
                              ),
                            ),
                            Container(
                              width: 99,
                              height: 102,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: NetworkImage("https://placehold.co/99x102"),
                                  fit: BoxFit.cover,
                                ),
                                borderRadius: BorderRadius.circular(15),
                              ),
                            ),
                            Container(
                              width: 75,
                              height: 102,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: NetworkImage("https://placehold.co/75x102"),
                                  fit: BoxFit.cover,
                                ),
                                borderRadius: BorderRadius.circular(15),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}

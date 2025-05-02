import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:weather_app/services/weather_model.dart';
import 'package:weather_app/services/locator.dart';
import 'package:lottie/lottie.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Weather? w;

  @override
  void initState() {
    super.initState();
    getWeather();
  }

  getWeather() async {
    String? city_name = await getLocation();

    try {
      Weather weather = Weather(cityName: city_name);
      await weather.getWeather();
      setState(() {
        w = weather;
      });
      // print(weather.temp);
    } catch (e) {
      print('Error while fetching weather: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Weather App',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 25,
          ),
        ),
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarBrightness: Brightness.dark,
        ),
        elevation: 0,
        shadowColor: Colors.black,
        centerTitle: true,
        backgroundColor: HexColor('#5f6464'),
      ),
      backgroundColor: HexColor('#1d1e1e'),
      body: SafeArea(
        child:
            w == null
                ? const CircularProgressIndicator()
                : Column(
                  children: [
                    Text(w!.cityName, style: TextStyle(color: Colors.white)),
                    const SizedBox(height: 20),
                    Text(w!.temp, style: TextStyle(color: Colors.white)),
                  ],
                ),
      ),
    );
  }
}

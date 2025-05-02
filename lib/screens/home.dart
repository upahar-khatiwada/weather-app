import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:weather_app/services/weather_model.dart';
import 'package:weather_app/services/locator.dart';
import 'package:lottie/lottie.dart';
import 'package:weather_app/services/Capitalizer.dart';
import 'package:weather_app/services/animation_selector.dart';

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
                    SizedBox(height: 30),
                    ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pushNamed(context, '/map');
                      },
                      label: Text(
                        'Edit Location',
                        style: TextStyle(color: Colors.black, fontSize: 18),
                      ),
                      icon: Icon(Icons.edit_location, size: 20),
                      style: ButtonStyle(
                        foregroundColor: WidgetStateProperty.all(Colors.black),
                        backgroundColor: WidgetStateProperty.all(Colors.white),
                        // padding: WidgetStateProperty.all(EdgeInsets.all(12)),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 10),
                      child: Center(
                        child: Text(
                          capitalize(w!.cityName),
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 30,
                          ),
                        ),
                      ),
                    ),
                    Lottie.asset(getJSON(w!.main)),
                    // Lottie.asset('assets/mist.json'),
                    const SizedBox(height: 10),
                    Container(
                      child: Center(
                        child: Text(
                          '${w!.temp} °C',
                          style: TextStyle(color: Colors.white, fontSize: 40),
                        ),
                      ),
                    ),
                  ],
                ),
      ),
    );
  }
}

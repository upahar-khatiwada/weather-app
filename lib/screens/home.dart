import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:weather_app/services/weather_model.dart';
import 'package:weather_app/services/locator.dart';
import 'package:lottie/lottie.dart';
import 'package:weather_app/services/Capitalizer.dart';
import 'package:weather_app/services/animation_selector.dart';

bool isDarkMode = true;

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  // w is an object to get the weather data
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
        iconTheme: IconThemeData(color: Colors.white),
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
      drawer: SideBar(),
      backgroundColor: HexColor('#1d1e1e'),
      // backgroundColor: Colors.white,
      body: SafeArea(
        child:
            w == null
                ? Center(
                  child: const CircularProgressIndicator(color: Colors.white),
                )
                : Column(
                  children: [
                    SizedBox(height: 30),
                    ElevatedButton.icon(
                      onPressed: () async {
                        // Navigator.pushNamed(context, '/map');

                        final selectedCity = await Navigator.pushNamed(
                          context,
                          '/map',
                        );

                        if (selectedCity != null && selectedCity is String) {
                          try {
                            Weather weather = Weather(cityName: selectedCity);
                            await weather.getWeather();
                            setState(() {
                              w = weather;
                            });
                          } catch (e) {
                            print(
                              'Error while fetching weather after selecting city: $e',
                            );
                          }
                        }
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
                      margin: EdgeInsets.only(top: 5),
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
                    Center(
                      child: Text(
                        '${w!.temp} °C',
                        style: TextStyle(color: Colors.white, fontSize: 40),
                      ),
                    ),
                    SizedBox(height: 30),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        // Sunrise Container
                        Column(
                          children: [
                            Container(
                              width: 150,
                              height: 50,
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: HexColor('#5f6464'),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.wb_sunny,
                                    color: Colors.white,
                                    size: 30,
                                  ),
                                  SizedBox(width: 8),
                                  Text(
                                    w!.sunriseFormatted,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 30),
                            Container(
                              width: 150,
                              height: 50,
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: HexColor('#5f6464'),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset('assets/low_temp.png', scale: 15),
                                  Text(
                                    w!.temp_min,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 25,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),

                        // Sunset Container (example)
                        Column(
                          children: [
                            Container(
                              width: 150,
                              height: 50,
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: HexColor('#5f6464'),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.nights_stay,
                                    color: Colors.white,
                                    size: 30,
                                  ),
                                  SizedBox(width: 8),
                                  Text(
                                    w!.sunsetFormatted, // Add formatted time if needed
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 30),
                            Container(
                              width: 150,
                              height: 50,
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: HexColor('#5f6464'),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    'assets/high_temp.png',
                                    // scale: 15,
                                    height: 50,
                                  ),
                                  Text(
                                    w!.temp_max,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 25,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
      ),
    );
  }
}

// Text(
// w!.main,
// style: TextStyle(
// color: Colors.white,
// fontSize: 40,
// ),
// ),

class SideBar extends StatelessWidget {
  const SideBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [buildHeader(context), buildMenuItems(context)],
        ),
      ),
    );
  }
}

Widget buildHeader(BuildContext context) => Container(
  color: HexColor('#5f6464'),
  padding: const EdgeInsets.only(top: 60, bottom: 20),
  child: Column(
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.settings, color: Colors.white, size: 33),
          SizedBox(width: 7),
          Text(
            'Settings',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 30,
            ),
          ),
        ],
      ),
      const SizedBox(height: 10),
    ],
  ),
);

Widget buildMenuItems(BuildContext context) => Container(
  color: HexColor('#1d1e1e'),
  height: MediaQuery.of(context).size.height,
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      SizedBox(height: 10.0),
      Material(
        color: HexColor('#1d1e1e'),
        child: InkWell(
          onTap: () {
            // Handle tap
          },
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: Row(
              children: [
                Icon(Icons.light_mode, color: Colors.white),
                SizedBox(width: 10),
                Text(
                  'Light Mode',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ],
  ),
);

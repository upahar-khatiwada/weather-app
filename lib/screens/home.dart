import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:weather_app/services/weather_model.dart';
import 'package:weather_app/services/locator.dart';
import 'package:lottie/lottie.dart';
import 'package:weather_app/services/Capitalizer.dart';
import 'package:weather_app/services/animation_selector.dart';

// To control the theme
bool isLightMode = false;

// Color values
Color darkAPP = HexColor('#5f6464');
Color darkBG = HexColor('#1d1e1e');
Color lightBG = HexColor('#f5f7f7');
Color lightAPP = HexColor('#dfe4e4');

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
      // print('Error while fetching weather: $e');
      Flushbar(
        message: 'Error while fetching weather!',
        margin: EdgeInsets.all(10),
        borderRadius: BorderRadius.circular(8),
        backgroundColor: Colors.red,
        duration: Duration(seconds: 3),
        flushbarPosition: FlushbarPosition.BOTTOM, // Shows at the bottom
        flushbarStyle: FlushbarStyle.FLOATING, // Floats over the UI
        forwardAnimationCurve: Curves.easeOut,
        reverseAnimationCurve: Curves.easeIn,
        icon: Icon(Icons.check_circle, color: Colors.white),
      ).show(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: isLightMode ? Colors.black : Colors.white,
        ),
        title: Text(
          'Weather App',
          style: TextStyle(
            color: isLightMode ? Colors.black : Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 25,
          ),
        ),
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarBrightness: Brightness.dark,
        ),
        elevation: 0,
        shadowColor: isLightMode ? Colors.white : Colors.black,
        centerTitle: true,
        backgroundColor: isLightMode ? lightAPP : darkAPP,
      ),
      drawer: SideBar(onThemeChanged: () => setState(() {})),
      backgroundColor: isLightMode ? lightBG : darkBG,
      body: SafeArea(
        child:
            w == null
                ? Center(
                  child: CircularProgressIndicator(
                    color: isLightMode ? Colors.black : Colors.white,
                  ),
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
                            Flushbar(
                              message: "API couldn't find the city!",
                              margin: EdgeInsets.all(10),
                              borderRadius: BorderRadius.circular(8),
                              backgroundColor: Colors.red,
                              duration: Duration(seconds: 3),
                              flushbarPosition:
                                  FlushbarPosition
                                      .BOTTOM, // Shows at the bottom
                              flushbarStyle:
                                  FlushbarStyle.FLOATING, // Floats over the UI
                              forwardAnimationCurve: Curves.easeOut,
                              reverseAnimationCurve: Curves.easeIn,
                              icon: Icon(
                                Icons.check_circle,
                                color: Colors.white,
                              ),
                            ).show(context);
                            // print(
                            //   'Error while fetching weather after selecting city: $e',
                            // );
                          }
                        }
                      },

                      label: Text(
                        'Edit Location',
                        style: TextStyle(
                          color: isLightMode ? Colors.white : Colors.black,
                          fontSize: 18,
                        ),
                      ),
                      icon: Icon(
                        Icons.edit_location,
                        size: 20,
                        color: isLightMode ? Colors.white : Colors.black,
                      ),
                      style: ButtonStyle(
                        // foregroundColor: WidgetStateProperty.all(isLightMode ? Colors.black : Colors.white),
                        backgroundColor: WidgetStateProperty.all(
                          isLightMode ? Colors.black : Colors.white,
                        ),
                        // padding: WidgetStateProperty.all(EdgeInsets.all(12)),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 5),
                      child: Center(
                        child: Text(
                          capitalize(w!.cityName),
                          style: TextStyle(
                            color: isLightMode ? Colors.black : Colors.white,
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
                        style: TextStyle(
                          color: isLightMode ? Colors.black : Colors.white,
                          fontSize: 40,
                        ),
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
                                color: isLightMode ? lightAPP : darkAPP,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.wb_sunny,
                                    color:
                                        isLightMode
                                            ? Colors.black
                                            : Colors.white,
                                    size: 30,
                                  ),
                                  SizedBox(width: 8),
                                  Text(
                                    w!.sunriseFormatted,
                                    style: TextStyle(
                                      color:
                                          isLightMode
                                              ? Colors.black
                                              : Colors.white,
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
                                color: isLightMode ? lightAPP : darkAPP,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset('assets/low_temp.png', scale: 15),
                                  Text(
                                    w!.temp_min,
                                    style: TextStyle(
                                      color:
                                          isLightMode
                                              ? Colors.black
                                              : Colors.white,
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
                                color: isLightMode ? lightAPP : darkAPP,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.nights_stay,
                                    color:
                                        isLightMode
                                            ? Colors.black
                                            : Colors.white,
                                    size: 30,
                                  ),
                                  SizedBox(width: 8),
                                  Text(
                                    w!.sunsetFormatted, // Add formatted time if needed
                                    style: TextStyle(
                                      color:
                                          isLightMode
                                              ? Colors.black
                                              : Colors.white,
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
                                color: isLightMode ? lightAPP : darkAPP,
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
                                      color:
                                          isLightMode
                                              ? Colors.black
                                              : Colors.white,
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

class SideBar extends StatefulWidget {
  final VoidCallback onThemeChanged;
  const SideBar({super.key, required this.onThemeChanged});

  @override
  State<SideBar> createState() => _SideBarState();
}

class _SideBarState extends State<SideBar> {
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

  Widget buildHeader(BuildContext context) => Container(
    color: isLightMode ? lightAPP : darkAPP,
    padding: EdgeInsets.only(top: 60, bottom: 20),
    child: Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.settings,
              color: isLightMode ? Colors.black : Colors.white,
              size: 33,
            ),
            SizedBox(width: 7),
            Text(
              'Settings',
              style: TextStyle(
                color: isLightMode ? Colors.black : Colors.white,
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
    color: isLightMode ? lightBG : darkBG,
    height: MediaQuery.of(context).size.height,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(height: 10.0),
        Material(
          color: isLightMode ? lightBG : darkBG,
          child: InkWell(
            onTap: () {
              // Handle tap
            },
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: Row(
                children: [
                  Icon(
                    Icons.light_mode,
                    color: isLightMode ? Colors.black : Colors.white,
                  ),
                  SizedBox(width: 10),
                  Text(
                    'Light Mode',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: isLightMode ? Colors.black : Colors.white,
                    ),
                  ),
                  SizedBox(width: 7),
                  Switch(
                    value: isLightMode,
                    activeColor: Colors.black,
                    onChanged: (bool val) {
                      setState(() {
                        // your state update code
                        isLightMode = val;
                      });
                      widget.onThemeChanged();
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    ),
  );
}

import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:latlong2/latlong.dart';
import 'package:weather_app/services/locator.dart';
import 'package:weather_app/screens/home.dart';
import 'package:http/http.dart';
import 'dart:convert';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  final MapController _mapController = MapController();
  LatLng? _currentLocation;

  // For the search bar
  final TextEditingController _locationTextController = TextEditingController();

  // For getting the tapped location, contains latitude and longitude of the tapped place
  LatLng? _selectedLocation;

  @override
  void initState() {
    super.initState();
    _currentLocation = LatLng(locatedLatitude!, locatedLongitude!);
  }

  // Function for search Bar
  Future<void> getCoordinatesFromCityName(searched_city) async {
    Response response = await get(
      Uri.parse(
        'https://nominatim.openstreetmap.org/search?q=$searched_city&format=json&limit=1',
      ),
    );

    if (response.statusCode == 200) {
      // This API returns a dynamic list not a map
      final List<dynamic> searchedLocationData = json.decode(response.body);
      print(searchedLocationData);

      if (searchedLocationData.isNotEmpty) {
        // The runtime type is String hence parsing needed!
        final searchedLatitude = double.parse(searchedLocationData[0]['lat']);
        final searchedLongitude = double.parse(searchedLocationData[0]['lon']);

        _mapController.move(LatLng(searchedLatitude, searchedLongitude), 7);
      } else {
        Flushbar(
          message: 'Could not search the city!',
          margin: EdgeInsets.all(10),
          borderRadius: BorderRadius.circular(8),
          backgroundColor: Colors.red,
          flushbarPosition: FlushbarPosition.BOTTOM,
          flushbarStyle: FlushbarStyle.FLOATING,
          forwardAnimationCurve: Curves.easeOut,
          reverseAnimationCurve: Curves.easeIn,
          icon: Icon(Icons.cancel, color: Colors.white),
        ).show(context);
      }
    } else {
      Flushbar(
        message: 'Could not search the city!',
        margin: EdgeInsets.all(10),
        borderRadius: BorderRadius.circular(8),
        backgroundColor: Colors.red,
        flushbarPosition: FlushbarPosition.BOTTOM,
        flushbarStyle: FlushbarStyle.FLOATING,
        forwardAnimationCurve: Curves.easeOut,
        reverseAnimationCurve: Curves.easeIn,
        icon: Icon(Icons.cancel, color: Colors.white),
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
          'Select Location',
          style: TextStyle(
            color: isLightMode ? Colors.black : Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 25,
          ),
        ),
        elevation: 0,
        shadowColor: isLightMode ? Colors.white : Colors.black,
        centerTitle: true,
        backgroundColor: isLightMode ? lightAPP : darkAPP,
        actions: [
          IconButton(
            icon: Icon(
              Icons.check,
              color: isLightMode ? Colors.black : Colors.white,
            ),
            onPressed: () {
              if (city != null || city == '') {
                // Pops back the selected city gotten from locator.dart to home.dart
                Navigator.pop(context, city); // send selected city back
              } else {
                // ScaffoldMessenger.of(context).showSnackBar(
                //   SnackBar(content: Text("Please tap on a location first")),
                // );
                Flushbar(
                  message: 'Please tap on a location first!',
                  margin: EdgeInsets.all(10),
                  borderRadius: BorderRadius.circular(8),
                  backgroundColor: Colors.red,
                  duration: Duration(seconds: 3),
                  flushbarPosition:
                      FlushbarPosition.BOTTOM, // Shows at the bottom
                  flushbarStyle: FlushbarStyle.FLOATING, // Floats over the UI
                  forwardAnimationCurve: Curves.easeOut,
                  reverseAnimationCurve: Curves.easeIn,
                  icon: Icon(Icons.cancel, color: Colors.white),
                ).show(context);
              }
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          FlutterMap(
            mapController: _mapController, // Controls the map's movement
            options: MapOptions(
              initialZoom: 2,
              minZoom: 0,
              maxZoom: 100,
              initialCenter:
                  _currentLocation ??
                  LatLng(27.70, 85.32), //default centre kathmandu
              onTap: (TapPosition, latlng) async {
                setState(() {
                  _selectedLocation =
                      latlng; //latlng is the tapped latitude/longitude
                  // locatedLatitude = latlng.latitude;
                  // locatedLongitude = latlng.longitude;
                  // getLocation();
                });
                // gets the tapped city from the coordinates
                final tappedCity = await getCityFromCoordinates(
                  latlng.latitude,
                  latlng.longitude,
                );

                if (tappedCity.isEmpty) {
                  Flushbar(
                    message: 'Could not find a city here!',
                    margin: EdgeInsets.all(10),
                    borderRadius: BorderRadius.circular(8),
                    backgroundColor: Colors.red,
                    duration: Duration(seconds: 3),
                    flushbarPosition:
                        FlushbarPosition.BOTTOM, // Shows at the bottom
                    flushbarStyle: FlushbarStyle.FLOATING, // Floats over the UI
                    forwardAnimationCurve: Curves.easeOut,
                    reverseAnimationCurve: Curves.easeIn,
                    icon: Icon(Icons.cancel, color: Colors.white),
                  ).show(context);
                  city = "";
                } else {
                  city = tappedCity;
                  // ScaffoldMessenger.of(context).showSnackBar(
                  //   SnackBar(content: Text('The tapped city: ${city}')),
                  // );
                  Flushbar(
                    message: 'The tapped City: $city',
                    margin: EdgeInsets.all(10),
                    borderRadius: BorderRadius.circular(8),
                    backgroundColor: Colors.green,
                    duration: Duration(seconds: 3),
                    flushbarPosition:
                        FlushbarPosition.BOTTOM, // Shows at the bottom
                    flushbarStyle: FlushbarStyle.FLOATING, // Floats over the UI
                    forwardAnimationCurve: Curves.easeOut,
                    reverseAnimationCurve: Curves.easeIn,
                    icon: Icon(Icons.check_circle, color: Colors.white),
                  ).show(context);
                  // print('The tapped city: ${city.runtimeType}');
                }
                // TapPosition returns screen coordinates while latlng returns actual latitude and longitudes
                // print("Tapped: ${latlng.latitude}, ${latlng.longitude}");
              },
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              ),
              CurrentLocationLayer(
                style: LocationMarkerStyle(
                  marker: DefaultLocationMarker(
                    child: Icon(
                      Icons.location_pin,
                      color: isLightMode ? Colors.black : Colors.white,
                    ),
                  ),
                  markerSize: Size(34, 34),
                  markerDirection: MarkerDirection.heading,
                ),
              ),
              MarkerLayer(
                markers:
                    _selectedLocation != null
                        ? [
                          Marker(
                            width: 80,
                            height: 80,
                            point: _selectedLocation!,
                            child: Icon(
                              Icons.location_on,
                              color: Colors.red,
                              size: 40,
                            ),
                          ),
                        ]
                        : [],
              ),
            ],
          ),
          Positioned(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _locationTextController,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: isLightMode ? darkAPP : Colors.white,
                        hintText: "Enter a valid location:",
                        hintStyle: TextStyle(
                          color: isLightMode ? Colors.white : Colors.black,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20,
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    style: IconButton.styleFrom(
                      backgroundColor: isLightMode ? darkAPP : Colors.white,
                    ),
                    onPressed: () {
                      final searchedLocation =
                          _locationTextController.text.trim();
                      getCoordinatesFromCityName(searchedLocation);
                    },
                    icon: Icon(
                      Icons.search,
                      color: isLightMode ? Colors.white : Colors.black,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      // To get back to current location
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (_currentLocation != null) {
            // Code for debugging, use async function to get the current location
            // final temp = await getCityFromCoordinates(
            //   _currentLocation.latitude,
            //   _currentLocation.longitude,
            // );
            // print(temp);
            _mapController.move(_currentLocation!, 7);
          } else {
            Flushbar(
              message: 'Could not get the Location!',
              margin: EdgeInsets.all(10),
              borderRadius: BorderRadius.circular(8),
              backgroundColor: Colors.red,
              duration: Duration(seconds: 3),
              flushbarPosition: FlushbarPosition.BOTTOM, // Shows at the bottom
              flushbarStyle: FlushbarStyle.FLOATING, // Floats over the UI
              forwardAnimationCurve: Curves.easeOut,
              reverseAnimationCurve: Curves.easeIn,
              icon: Icon(Icons.cancel, color: Colors.white),
            ).show(context);
            // ScaffoldMessenger.of(context).showSnackBar(
            //   SnackBar(content: Text('Failed to get the Location')),
            // );
          }
        },
        backgroundColor: isLightMode ? lightAPP : darkAPP,
        child: Icon(
          Icons.my_location,
          color: isLightMode ? Colors.black : Colors.white,
        ),
      ),
    );
  }
}

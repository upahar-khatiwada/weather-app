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
  final LatLng? _currentLocation = LatLng(locatedLatitude!, locatedLongitude!);

  // For the search bar
  final TextEditingController _locationController = TextEditingController();

  // For getting the tapped location
  LatLng? _selectedLocation;

  // Function for search Bar
  Future<void> fetchLocationFromCoordinates(searchedLocation_) async {
    try {
      Response response = await get(
        Uri.parse(
          'https://nominatim.openstreetmap.org/search?q=$searchedLocation_&format=json&limit=1',
        ),
      );

      if (response.statusCode == 200) {
        // Couldn't use Map since it returned a list with the error message:
        // type 'List<dynamic>' is not a subtype of type 'Map<dynamic, dynamic>'
        final List<dynamic> searchedLocationData = json.decode(response.body);
        // print(searchedLocationData);
        if (searchedLocationData.isNotEmpty) {
          print(searchedLocationData);
          setState(() {
            _selectedLocation = LatLng(
              searchedLocationData[0]['lat'],
              searchedLocationData[0]['lon'],
            );
          });
        }
      } else {
        print('STATUS CODE NOT 200');
      }
    } catch (e) {
      print(e);
      Flushbar(
        message: 'Error while searching: $e',
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
              if (city != null) {
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
                  icon: Icon(Icons.check_circle, color: Colors.white),
                ).show(context);
              }
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialZoom: 2,
              minZoom: 0,
              maxZoom: 100,
              initialCenter: _currentLocation ?? LatLng(0, 0),
              onTap: (TapPosition, latlng) async {
                setState(() {
                  _selectedLocation = latlng;
                  locatedLatitude = latlng.latitude;
                  locatedLongitude = latlng.longitude;
                  // getLocation();
                });
                // gets the tapped city from the coordinates
                final tappedCity = await getCityFromCoordinates(
                  latlng.latitude,
                  latlng.longitude,
                );

                if (tappedCity == null || tappedCity.isEmpty) {
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
                    icon: Icon(Icons.check_circle, color: Colors.white),
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
                      controller: _locationController,
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
                      final searchedLocation = _locationController.text.trim();
                      if (searchedLocation.isNotEmpty) {
                        fetchLocationFromCoordinates(searchedLocation);
                        _mapController.move(_selectedLocation!, 13);
                      } else {
                        Flushbar(
                          message: 'Could not find the searched location',
                          margin: EdgeInsets.all(10),
                          borderRadius: BorderRadius.circular(8),
                          backgroundColor: Colors.red,
                          duration: Duration(seconds: 3),
                          flushbarPosition:
                              FlushbarPosition.BOTTOM, // Shows at the bottom
                          flushbarStyle:
                              FlushbarStyle.FLOATING, // Floats over the UI
                          forwardAnimationCurve: Curves.easeOut,
                          reverseAnimationCurve: Curves.easeIn,
                          icon: Icon(Icons.check_circle, color: Colors.white),
                        ).show(context);
                      }
                    },
                    icon: const Icon(Icons.search),
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
            _mapController.move(_currentLocation, 7);
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Failed to get the Location')),
            );
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

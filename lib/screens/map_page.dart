import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:latlong2/latlong.dart';
import 'package:weather_app/services/locator.dart';
import 'package:weather_app/screens/home.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  final MapController _mapController = MapController();
  final LatLng? _currentLocation = LatLng(locatedLatitude!, locatedLongitude!);

  // For getting the tapped location
  LatLng? _selectedLocation;

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

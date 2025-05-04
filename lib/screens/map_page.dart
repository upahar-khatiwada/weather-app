import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:latlong2/latlong.dart';
import 'package:weather_app/services/locator.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  final MapController _mapController = MapController();
  final LatLng? _currentLocation = LatLng(locatedLatitude!, locatedLongitude!);

  // For getting the tapped location
  // LatLng? _selectedLocation;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Select Location',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 25,
          ),
        ),
        elevation: 0,
        shadowColor: Colors.black,
        centerTitle: true,
        backgroundColor: HexColor('#5f6464'),
        actions: [
          IconButton(
            icon: Icon(Icons.check, color: Colors.white),
            onPressed: () {
              if (city != null) {
                Navigator.pop(context, city); // send selected city back
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Please tap on a location first")),
                );
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
                  // _selectedLocation = latlng;
                  locatedLatitude = latlng.latitude;
                  locatedLongitude = latlng.longitude;
                  // getLocation();
                });
                city = await getCityFromCoordinates(
                  latlng.latitude,
                  latlng.longitude,
                );
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
                    child: Icon(Icons.location_pin, color: Colors.white),
                  ),
                  markerSize: Size(34, 34),
                  markerDirection: MarkerDirection.heading,
                ),
              ),
            ],
          ),
        ],
      ),
      // To get back to current location
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (_currentLocation != null) {
            _mapController.move(_currentLocation!, 10);
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Failed to get the Location')),
            );
          }
        },
        backgroundColor: HexColor('#5f6464'),
        child: Icon(Icons.my_location, color: Colors.white),
      ),
    );
  }
}

// Unused code because of flutter_osm_plugin's weird behavior

// import 'package:flutter/material.dart';
// import 'package:hexcolor/hexcolor.dart';
// import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
// import 'package:weather_app/services/locator.dart';
// import 'package:geocoding/geocoding.dart';
//
// class googleMaps extends StatefulWidget {
//   const googleMaps({super.key});
//
//   @override
//   State<googleMaps> createState() => _googleMapsState();
// }
//
// class _googleMapsState extends State<googleMaps> {
//   late MapController mapController;
//   @override
//   void initState() {
//     super.initState();
//     mapController = MapController.withUserPosition(
//       trackUserLocation: UserTrackingOption(
//         enableTracking: true,
//         unFollowUser: false,
//       ),
//     );
//   }
//
//   @override
//   void dispose() {
//     mapController.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text(
//           'Select Location',
//           style: TextStyle(
//             color: Colors.white,
//             fontWeight: FontWeight.bold,
//             fontSize: 25,
//           ),
//         ),
//         elevation: 0,
//         shadowColor: Colors.black,
//         centerTitle: true,
//         backgroundColor: HexColor('#5f6464'),
//       ),
//       backgroundColor: HexColor('#1d1e1e'),
//       // Map drawn here
//       body: OSMFlutter(
//         controller: mapController,
//         onGeoPointClicked: (GeoPoint? position) async {
//           if (position != null) {}
//           await mapController.addMarker(
//             position!,
//             markerIcon: MarkerIcon(
//               icon: Icon(Icons.location_on, color: Colors.red, size: 48),
//             ),
//           );
//         },
//         onLocationChanged: (GeoPoint newLocation) async {
//           try {
//             List<Placemark> placeMarks = await placemarkFromCoordinates(
//               newLocation.latitude,
//               newLocation.longitude,
//             );
//
//             String? city = placeMarks.isNotEmpty ? placeMarks[0].locality : "";
//             print("The new location is $city");
//
//             setState(() {
//               placemarks = placeMarks;
//             });
//           } catch (e) {
//             print('There was an error finding location from maps: $e');
//           }
//         },
//         osmOption: OSMOption(
//           userTrackingOption: UserTrackingOption(
//             enableTracking: true,
//             unFollowUser: false,
//           ),
//           zoomOption: ZoomOption(
//             initZoom: 8,
//             minZoomLevel: 3,
//             maxZoomLevel: 19,
//             stepZoom: 1.0,
//           ),
//           userLocationMarker: UserLocationMaker(
//             personMarker: MarkerIcon(
//               icon: Icon(Icons.edit_location, color: Colors.red, size: 48),
//             ),
//             directionArrowMarker: MarkerIcon(
//               icon: Icon(Icons.double_arrow, size: 48, color: Colors.red),
//             ),
//           ),
//           roadConfiguration: RoadOption(roadColor: Colors.yellowAccent),
//
//           // Marker options apparently got removed from flutter_osm_plugin
//           // markerOption: MarkerOption(
//           //   defaultMarker: MarkerIcon(
//           //     icon: Icon(Icons.person_pin_circle, color: Colors.blue, size: 56),
//           //   ),
//           // ),
//         ),
//       ),
//     );
//   }
// }

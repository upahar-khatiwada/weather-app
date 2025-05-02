import 'package:geolocator/geolocator.dart';
import 'dart:convert';
import 'package:geocoding/geocoding.dart';

Future<String> getLocation() async {
  LocationPermission permission = await Geolocator.checkPermission();

  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      return Future.error('Location permissions are disabled!');
    }
  }

  if (permission == LocationPermission.deniedForever) {
    return Future.error('Locations permissions are permanently denied!');
  }

  final LocationSettings locationSettings = LocationSettings(
    accuracy: LocationAccuracy.high,
  );

  Position position = await Geolocator.getCurrentPosition(
    locationSettings: locationSettings,
  );

  List<Placemark> placemarks = await placemarkFromCoordinates(
    position.latitude,
    position.longitude,
  );

  String? city = placemarks[0].locality;
  print(city);

  // return city ?? "";
  return 'kathmandu';
}

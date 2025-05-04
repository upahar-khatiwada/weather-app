import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

double? locatedLatitude, locatedLongitude;
late List<Placemark> placemarks;
late String? city;
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

  // Not needed anymore as we tracked user's live position in map.dart
  locatedLatitude = position.latitude;
  locatedLongitude = position.longitude;

  city = placemarks[0].locality;
  print(city);

  return city ?? "";
  // return 'kathmandu';
}

Future<String> getCityFromCoordinates(double lat, double lon) async {
  List<Placemark> placemarks = await placemarkFromCoordinates(lat, lon);
  return placemarks[0].locality ?? "";
}

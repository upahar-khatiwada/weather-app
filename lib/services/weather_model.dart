import 'package:http/http.dart';
import 'dart:convert';
import 'package:weather_app/API/api_info.dart';
import 'package:intl/intl.dart';

class Weather {
  late String cityName;
  Weather({required this.cityName});
  late String temp, main, temp_min, temp_max, sunriseFormatted, sunsetFormatted;
  late int sunrise, sunset, timezone;

  Future<void> getWeather() async {
    Response response = await get(
      Uri.parse('$baseUrl?q=$cityName&appid=$apiKey&units=metric'),
    );
    Map data = jsonDecode(response.body);
    // print(data);
    // print(data['main']['temp']);
    // print(data['main']['pressure']);
    // print(data['main']['humidity']);
    // print(data['weather'][0]['main']);
    // print(data['name']);

    temp = data['main']['temp'].toString();
    sunrise = data['sys']['sunrise'];
    sunset = data['sys']['sunset'];
    timezone = data['timezone'];
    main = data['weather'][0]['main'].toString();

    temp_min = data['main']['temp_min'].toString();
    temp_max = data['main']['temp_max'].toString();
    // cityName = data['name'].toString();

    // converting to datetime
    DateTime sunriseTime = DateTime.fromMillisecondsSinceEpoch(
      sunrise * 1000 + timezone * 1000,
    );
    DateTime sunsetTime = DateTime.fromMillisecondsSinceEpoch(
      sunset * 1000 + timezone * 1000,
    );

    sunriseFormatted = DateFormat('hh:mm a').format(sunriseTime);
    sunsetFormatted = DateFormat('hh:mm a').format(sunsetTime);
  }
}

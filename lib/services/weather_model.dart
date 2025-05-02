import 'package:http/http.dart';
import 'dart:convert';
import 'package:weather_app/API/api_info.dart';

class Weather {
  late String cityName;
  Weather({required this.cityName});
  late String temp, pressure, humidity, main;

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
    pressure = data['main']['pressure'].toString();
    humidity = data['main']['humidity'].toString();
    main = data['weather'][0]['main'].toString();
    // cityName = data['name'].toString();
  }
}

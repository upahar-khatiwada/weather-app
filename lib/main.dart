import 'package:flutter/material.dart';
import 'package:weather_app/screens/home.dart';
import 'package:weather_app/screens/map.dart';

void main() {
  runApp(
    MaterialApp(
      initialRoute: '/',
      routes: {'/': (context) => Home(), '/map': (context) => googleMaps()},
      debugShowCheckedModeBanner: false,
    ),
  );
}

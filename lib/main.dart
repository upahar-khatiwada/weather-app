import 'package:flutter/material.dart';
import 'package:weather_app/screens/home.dart';
// import 'package:weather_app/screens/map.dart';
import 'package:weather_app/screens/map_page.dart';

void main() {
  runApp(
    MaterialApp(
      initialRoute: '/',
      routes: {'/': (context) => Home(), '/map': (context) => MapPage()},
      debugShowCheckedModeBanner: false,
    ),
  );
}

import 'package:flutter/material.dart';
import 'package:weather_app/screens/home.dart';
// import 'package:weather_app/screens/map.dart';
import 'package:weather_app/screens/map_page.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Hive.openBox('db_theme');
  runApp(
    MaterialApp(
      initialRoute: '/',
      routes: {'/': (context) => Home(), '/map': (context) => MapPage()},
      debugShowCheckedModeBanner: false,
    ),
  );
}

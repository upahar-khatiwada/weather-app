import 'package:flutter/material.dart';

class googleMaps extends StatefulWidget {
  const googleMaps({super.key});

  @override
  State<googleMaps> createState() => _googleMapsState();
}

class _googleMapsState extends State<googleMaps> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Select Location'), centerTitle: true),
    );
  }
}

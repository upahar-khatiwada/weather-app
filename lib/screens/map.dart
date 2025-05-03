import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

class googleMaps extends StatefulWidget {
  const googleMaps({super.key});

  @override
  State<googleMaps> createState() => _googleMapsState();
}

class _googleMapsState extends State<googleMaps> {
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
      ),
      backgroundColor: HexColor('#1d1e1e'),
    );
  }
}

import 'package:flutter/material.dart';

class MyButtons extends StatelessWidget {
  final String text;
  final Function callback;
  const MyButtons({required this.text, required this.callback, super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        callback(text);
        print('callback triggered');
      },
      child: Container(
        height: 80,
        width: double.maxFinite,
        margin: EdgeInsets.only(left: 50, right: 50, top: 30),
        decoration: BoxDecoration(
          color: Colors.blueGrey,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 23,
            ),
          ),
        ),
      ),
    );
  }
}

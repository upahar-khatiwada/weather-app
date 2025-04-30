import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/widget_state.dart';
import 'package:weather_app/temp.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String topic = 'flutter';

  callback(varTopic) {
    setState(() {
      topic = varTopic;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          // leading: Drawer(backgroundColor: Colors.redAccent),
          title: Text('Testing Flutter'),
          titleSpacing: 1,
          centerTitle: true,
        ),
        body: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // SizedBox(height: 150),
              // TextButton(
              //   onPressed: () {},
              //   style: ButtonStyle(
              //     backgroundColor: WidgetStateProperty.all(Colors.red),
              //   ),
              //   child: Text(
              //     'On Pressing: $topic',
              //     style: TextStyle(color: Colors.black),
              //   ),
              // ),
              Container(
                height: 80,
                width: double.maxFinite,
                margin: EdgeInsets.only(left: 50, right: 50, top: 30),
                decoration: BoxDecoration(
                  color: Colors.blueGrey,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: Text(
                    'I pressed $topic',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 23,
                    ),
                  ),
                ),
              ),
              MyButtons(text: 'ok', callback: callback),
            ],
          ),
        ),
      ),
    );
  }
}

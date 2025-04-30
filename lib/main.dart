import 'package:flutter/material.dart';
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
  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false, home: MyFirsTpAGE());
  }
}

// class _MyAppState extends State<MyApp> {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: SafeArea(
//         maintainBottomViewPadding: true,
//         child: Scaffold(
//           appBar: AppBar(
//             title: Text('Test Title'),
//             centerTitle: true,
//             backgroundColor: Colors.lightBlue,
//           ),
//           body: Center(
//             child: ElevatedButton(
//               onPressed: () {
//                 Navigator.of(context).push(
//                   MaterialPageRoute(
//                     builder: (context) {
//                       return MySecondApp();
//                     },
//                   ),
//                 );
//               },
//               child: Text('Press!'),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

//Without the myfirstpage class below, there would be an error as flutter will have to build everything

class MyFirsTpAGE extends StatefulWidget {
  const MyFirsTpAGE({super.key});

  @override
  State<MyFirsTpAGE> createState() => _MyFirsTpAGEState();
}

class _MyFirsTpAGEState extends State<MyFirsTpAGE> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      maintainBottomViewPadding: true,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Test Title'),
          centerTitle: true,
          backgroundColor: Colors.lightBlue,
        ),
        body: Center(
          child: ElevatedButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) {
                    return MySecondApp();
                  },
                ),
              );
            },
            child: Text('Press!'),
          ),
        ),
      ),
    );
  }
}

class MySecondApp extends StatefulWidget {
  const MySecondApp({super.key});

  @override
  State<MySecondApp> createState() => _MySecondAppState();
}

class _MySecondAppState extends State<MySecondApp> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Test Title 2'),
        centerTitle: true,
        backgroundColor: Colors.lightBlue,
      ),
    );
  }
}

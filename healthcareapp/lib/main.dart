import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:healthcareapp/pages/activitystats/ActivityMenu.dart';
import 'package:healthcareapp/pages/details/details.dart';
import 'package:healthcareapp/pages/home/home.dart';
import 'package:health/health.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:async';

import 'pages/bmi/bmi.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
  //await Permission.activityRecognition.request();
  //await Permission.location.request();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Health Care App",
      theme: ThemeData(
        fontFamily: 'Roboto',
        textTheme: const TextTheme(
          headline1: TextStyle(
            fontSize: 14,
            color: Colors.black,
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
      debugShowCheckedModeBanner: false,
      routes: {
        '/': (context) => const HomePage(),
        '/details': (context) => const DetailsPage(),
        '/bmi': (context) => const BmiPage(),
        '/activity-menu': (context) => const ActivityMenu(),
      },
      initialRoute: '/details',
    );
  }
}

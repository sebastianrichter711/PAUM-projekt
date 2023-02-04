import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:healthcareapp/pages/activitystats/ActivityMenu.dart';
import 'package:healthcareapp/pages/activitystats/CaloriesPage.dart';
import 'package:healthcareapp/pages/activitystats/DistancePage.dart';
import 'package:healthcareapp/pages/activitystats/StepsPage.dart';
import 'package:healthcareapp/pages/details/details.dart';
import 'package:healthcareapp/pages/home/home.dart';
import 'package:health/health.dart';
import 'package:healthcareapp/pages/life-params/BloodPressurePage.dart';
import 'package:healthcareapp/pages/life-params/LifeParamsPage.dart';
import 'package:healthcareapp/pages/life-params/PulsePage.dart';
import 'package:healthcareapp/pages/life-params/TemperaturePage.dart';
import 'package:healthcareapp/pages/life-params/add/AddBloodPressure.dart';
import 'package:healthcareapp/pages/life-params/add/AddPulse.dart';
import 'package:healthcareapp/pages/life-params/add/AddTemperature.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:async';

import 'pages/bmi/bmi.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
  await Permission.activityRecognition.request();
  await Permission.location.request();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    HealthFactory healthFactory = HealthFactory();
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
        '/details': (context) => DetailsPage(health: healthFactory),
        '/bmi': (context) => const BmiPage(),
        '/activity-page': (context) => const ActivityPage(),
        '/steps': (context) => const StepsPage(),
        '/distance': (context) => const DistancePage(),
        '/calories': (context) => CaloriesPage(health: healthFactory),
        '/life-params': (context) => LifeParamsPage(health: healthFactory),
        '/pulse': (context) => PulsePage(health: healthFactory),
        '/add-pulse': (context) => AddPulsePage(health: healthFactory),
        '/body-temperature': (context) =>
            TemperaturePage(health: healthFactory),
        '/add-body-temperature': (context) =>
            AddTemperaturePage(health: healthFactory),
        '/blood-pressure': (context) =>
            BloodPressurePage(health: healthFactory),
        '/add-blood-pressure': (context) =>
            AddBloodPressurePage(health: healthFactory),
      },
      initialRoute: '/details',
    );
  }
}

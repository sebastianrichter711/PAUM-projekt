import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:healthcareapp/pages/activitystats/ActivityMenu.dart';
import 'package:healthcareapp/pages/activitystats/CaloriesPage.dart';
import 'package:healthcareapp/pages/activitystats/DistancePage.dart';
import 'package:healthcareapp/pages/activitystats/StepsPage.dart';
import 'package:healthcareapp/pages/details/details.dart';
import 'package:healthcareapp/pages/home/home.dart';
import 'package:health/health.dart';
import 'package:healthcareapp/pages/life-params/BloodGlucosePage.dart';
import 'package:healthcareapp/pages/life-params/LifeParamsPage.dart';
import 'package:healthcareapp/pages/life-params/PulsePage.dart';
import 'package:healthcareapp/pages/life-params/TemperaturePage.dart';
import 'package:healthcareapp/pages/life-params/add/AddBloodGlucose.dart';
import 'package:healthcareapp/pages/life-params/add/AddPulse.dart';
import 'package:healthcareapp/pages/life-params/add/AddTemperature.dart';
import 'package:healthcareapp/pages/sleep/SleepPage.dart';
import 'package:healthcareapp/pages/sleep/add/AddSleep.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:async';

import 'pages/bmi/bmi.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
  final types = [
    HealthDataType.DISTANCE_DELTA,
    HealthDataType.STEPS,
    HealthDataType.ACTIVE_ENERGY_BURNED,
    HealthDataType.MOVE_MINUTES,
    HealthDataType.BODY_TEMPERATURE,
    HealthDataType.HEART_RATE,
    HealthDataType.BLOOD_PRESSURE_SYSTOLIC,
    HealthDataType.BLOOD_PRESSURE_DIASTOLIC,
    HealthDataType.SLEEP_IN_BED,
    HealthDataType.SLEEP_ASLEEP,
    HealthDataType.BLOOD_GLUCOSE
  ];
  final permissions = [
    HealthDataAccess.READ_WRITE,
    HealthDataAccess.READ_WRITE,
    HealthDataAccess.READ_WRITE,
    HealthDataAccess.READ_WRITE,
    HealthDataAccess.READ_WRITE,
    HealthDataAccess.READ_WRITE,
    HealthDataAccess.READ_WRITE,
    HealthDataAccess.READ_WRITE,
    HealthDataAccess.READ_WRITE,
    HealthDataAccess.READ_WRITE,
    HealthDataAccess.READ_WRITE
  ];
  bool? hasPermissions =
      await HealthFactory.hasPermissions(types, permissions: permissions);
  if (hasPermissions == false) {
    HealthFactory health = HealthFactory();
    await health.requestAuthorization(types, permissions: permissions);
  }
  await Permission.activityRecognition.request();
  await Permission.location.request();
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
        '/details': (context) => DetailsPage(health: HealthFactory()),
        '/bmi': (context) => const BmiPage(),
        '/activity-page': (context) => const ActivityPage(),
        '/steps': (context) => const StepsPage(),
        '/distance': (context) => const DistancePage(),
        '/calories': (context) => const CaloriesPage(),
        '/life-params': (context) => LifeParamsPage(health: HealthFactory()),
        '/pulse': (context) => PulsePage(health: HealthFactory()),
        '/add-pulse': (context) => AddPulsePage(health: HealthFactory()),
        '/body-temperature': (context) =>
            TemperaturePage(health: HealthFactory()),
        '/add-body-temperature': (context) =>
            AddTemperaturePage(health: HealthFactory()),
        '/blood-glucose': (context) =>
            BloodGlucosePage(health: HealthFactory()),
        '/add-blood-glucose': (context) =>
            AddBloodGlucosePage(health: HealthFactory()),
        '/sleep': (context) => SleepPage(health: HealthFactory()),
        '/add-sleep': (context) => AddSleepPage(health: HealthFactory()),
      },
      initialRoute: '/details',
    );
  }
}

import 'package:flutter/material.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:healthcareapp/pages/details/widgets/chart/lineChart.dart';
import 'package:healthcareapp/widgets/bottom_navigation.dart';
import 'package:health/health.dart';

class BloodPressurePage extends StatelessWidget {
  final HealthFactory health;
  const BloodPressurePage({super.key, required this.health});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [BloodPressureData(health: health), BottomNavigation()],
      ),
    );
  }
}

class BloodPressureData extends StatefulWidget {
  final HealthFactory health;
  BloodPressureData({super.key, required this.health});

  @override
  State<BloodPressureData> createState() => _BloodPressureDataState();
}

class _BloodPressureDataState extends State<BloodPressureData> {
  double todayCalories = 0.0;
  double weekCalories = 0.0;
  double avgWeekCalories = 0.0;
  int weekday = DateTime.now().weekday;
  List<Point> systolicPoints = [];
  List<Point> diastolicPoints = [];
  @override
  Widget build(BuildContext context) {
    fetchSystolicPressureWeek();
    fetchDiastolicPressureWeek();
    double width = MediaQuery.of(context).size.width - 60;
    return Expanded(
        child: Center(
            child: Padding(
      padding: const EdgeInsets.fromLTRB(0, 40, 0, 20),
      child:
          Column(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
        Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Text(
            'Ciśnienie krwi',
            style: TextStyle(
              fontFamily: 'Manrope',
              fontWeight: FontWeight.bold,
              fontSize: 42,
              decoration: TextDecoration.none,
            ),
          ),
        ]),
        SizedBox(height: 20),
        LineChartWidget(health: widget.health, points: systolicPoints),
        LineChartWidget(health: widget.health, points: diastolicPoints),
        Wrap(
          runSpacing: 16,
          children: [
            modeButton("Dodaj pomiar", 'Spalone kalorie dziś [Cal]', Icons.add,
                Color(0xFF008000), width),
          ],
        )
      ]),
    )));
  }

  Padding circButton(IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: RawMaterialButton(
          onPressed: () {},
          fillColor: Colors.white,
          shape: CircleBorder(),
          constraints: BoxConstraints(minHeight: 35, minWidth: 35),
          child: FaIcon(icon, size: 22, color: Color(0xFF2F3041))),
    );
  }

  GestureDetector modeButton(
      String title, String subtitle, IconData icon, Color color, double width) {
    return GestureDetector(
        onTap: () {
          Navigator.of(context).pushNamed('/add-blood-pressure');
        },
        child: Container(
            width: width,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.all(Radius.circular(16)),
            ),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 22.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(title,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.none,
                              fontFamily: 'Manrope',
                              color: Colors.white,
                              fontSize: 24,
                            )),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30, vertical: 18),
                    child: FaIcon(icon, size: 35, color: Colors.white),
                  )
                ])));
  }

  Future<void> fetchSystolicPressureWeek() async {
    List<HealthDataPoint> gotSystolicPressure = [];
    List<Point> listOfPoints = [];
    double? systolicPressure = 0;
    double result = 0.0;

    // get steps for today (i.e., since midnight)
    final now = DateTime.now();
    DateTime midnight = DateTime(now.year, now.month, now.day);

    final types = [HealthDataType.BLOOD_PRESSURE_SYSTOLIC];
    bool requested = await widget.health
        .requestAuthorization([HealthDataType.BLOOD_PRESSURE_SYSTOLIC]);

    if (requested) {
      int j = 0;
      for (int i = 6; i >= 0; i--) {
        result = 0.0;
        DateTime startDate;
        DateTime endDate;
        if (i != 0) {
          startDate = midnight.subtract(Duration(days: i));
          endDate = midnight.subtract(Duration(days: i - 1));
        } else {
          startDate = midnight;
          endDate = DateTime.now();
        }
        try {
          gotSystolicPressure = await widget.health
              .getHealthDataFromTypes(startDate, endDate, types);
        } catch (error) {
          print("Caught exception in gotPulse: $error");
        }

        gotSystolicPressure =
            HealthFactory.removeDuplicates(gotSystolicPressure);
        if (gotSystolicPressure.length == 0) {
          Point newPoint = Point(x: j.toDouble(), y: 0.0);
          listOfPoints.add(newPoint);
          print("Day:  $j  Pulse:  $systolicPressure");
          j += 1;
        } else {
          gotSystolicPressure
              .forEach((x) => result += double.parse(x.value.toString()));
          systolicPressure =
              result / double.parse(gotSystolicPressure.length.toString());
          Point newPoint = Point(x: j.toDouble(), y: systolicPressure);
          listOfPoints.add(newPoint);
          print("Day:  $j  Pulse:  $systolicPressure");
          j += 1;
        }
      }
      setState(() {
        systolicPoints = listOfPoints;
      });
    } else {
      print("Authorization not granted - error in authorization");
    }
  }

  Future<void> fetchDiastolicPressureWeek() async {
    List<HealthDataPoint> gotDiastolicPressure = [];
    List<Point> listOfPoints = [];
    double? diastolicPressure = 0;
    double result = 0.0;

    // get steps for today (i.e., since midnight)
    final now = DateTime.now();
    DateTime midnight = DateTime(now.year, now.month, now.day);

    final types = [HealthDataType.BLOOD_PRESSURE_DIASTOLIC];
    bool requested = await widget.health
        .requestAuthorization([HealthDataType.BLOOD_PRESSURE_DIASTOLIC]);

    if (requested) {
      int j = 0;
      for (int i = 6; i >= 0; i--) {
        result = 0.0;
        DateTime startDate;
        DateTime endDate;
        if (i != 0) {
          startDate = midnight.subtract(Duration(days: i));
          endDate = midnight.subtract(Duration(days: i - 1));
        } else {
          startDate = midnight;
          endDate = DateTime.now();
        }
        try {
          gotDiastolicPressure = await widget.health
              .getHealthDataFromTypes(startDate, endDate, types);
        } catch (error) {
          print("Caught exception in gotPulse: $error");
        }

        gotDiastolicPressure =
            HealthFactory.removeDuplicates(gotDiastolicPressure);
        if (gotDiastolicPressure.length == 0) {
          Point newPoint = Point(x: j.toDouble(), y: 0.0);
          listOfPoints.add(newPoint);
          print("Day:  $j  Pulse:  $diastolicPressure");
          j += 1;
        } else {
          gotDiastolicPressure
              .forEach((x) => result += double.parse(x.value.toString()));
          diastolicPressure =
              result / double.parse(gotDiastolicPressure.length.toString());
          Point newPoint = Point(x: j.toDouble(), y: diastolicPressure);
          listOfPoints.add(newPoint);
          print("Day:  $j  Pulse:  $diastolicPressure");
          j += 1;
        }
      }
      setState(() {
        diastolicPoints = listOfPoints;
      });
    } else {
      print("Authorization not granted - error in authorization");
    }
  }
}

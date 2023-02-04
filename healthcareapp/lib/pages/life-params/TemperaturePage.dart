import 'package:flutter/material.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:healthcareapp/pages/details/widgets/chart/lineChart.dart';
import 'package:healthcareapp/widgets/bottom_navigation.dart';
import 'package:health/health.dart';

class TemperaturePage extends StatelessWidget {
  final HealthFactory health;
  const TemperaturePage({super.key, required this.health});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [TemperatureData(health: health), BottomNavigation()],
      ),
    );
  }
}

class TemperatureData extends StatefulWidget {
  final HealthFactory health;
  TemperatureData({super.key, required this.health});

  @override
  State<TemperatureData> createState() => _TemperatureDataState();
}

class _TemperatureDataState extends State<TemperatureData> {
  double todayCalories = 0.0;
  double weekCalories = 0.0;
  double avgWeekCalories = 0.0;
  int weekday = DateTime.now().weekday;
  List<Point> points = [];
  @override
  Widget build(BuildContext context) {
    fetchWeekTemperature();
    double width = MediaQuery.of(context).size.width - 60;
    return Expanded(
        child: Center(
            child: Padding(
      padding: const EdgeInsets.fromLTRB(0, 40, 0, 20),
      child:
          Column(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
        Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Text(
            'Temperatura ciała',
            style: TextStyle(
              fontFamily: 'Manrope',
              fontWeight: FontWeight.bold,
              fontSize: 42,
              decoration: TextDecoration.none,
            ),
          ),
        ]),
        SizedBox(height: 20),
        LineChartWidget(health: widget.health, points: points),
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
          Navigator.of(context).pushNamed('/add-body-temperature');
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

  Future<void> fetchWeekTemperature() async {
    List<HealthDataPoint> gotTemperature = [];
    List<Point> listOfPoints = [];
    double? temperature = 0;
    double result = 0.0;

    // get steps for today (i.e., since midnight)
    final now = DateTime.now();
    DateTime midnight = DateTime(now.year, now.month, now.day);

    final types = [HealthDataType.BODY_TEMPERATURE];
    bool requested = await widget.health
        .requestAuthorization([HealthDataType.BODY_TEMPERATURE]);

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
          gotTemperature = await widget.health
              .getHealthDataFromTypes(startDate, endDate, types);
        } catch (error) {
          print("Caught exception in gotPulse: $error");
        }

        gotTemperature = HealthFactory.removeDuplicates(gotTemperature);
        if (gotTemperature.length == 0) {
          Point newPoint = Point(x: j.toDouble(), y: 0.0);
          listOfPoints.add(newPoint);
          print("Day:  $j  Pulse:  $temperature");
          j += 1;
        } else {
          gotTemperature
              .forEach((x) => result += double.parse(x.value.toString()));
          temperature = result / double.parse(gotTemperature.length.toString());
          Point newPoint = Point(x: j.toDouble(), y: temperature);
          listOfPoints.add(newPoint);
          print("Day:  $j  Pulse:  $temperature");
          j += 1;
        }
      }
      setState(() {
        points = listOfPoints;
      });
    } else {
      print("Authorization not granted - error in authorization");
    }
  }
}

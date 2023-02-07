import 'package:flutter/material.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:healthcareapp/pages/details/widgets/chart/lineChart.dart';
import 'package:healthcareapp/widgets/bottom_navigation.dart';
import 'package:health/health.dart';

class PulsePage extends StatelessWidget {
  final HealthFactory health;
  const PulsePage({super.key, required this.health});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [PulseData(health: health), BottomNavigation()],
      ),
    );
  }
}

class PulseData extends StatefulWidget {
  final HealthFactory health;
  PulseData({super.key, required this.health});

  @override
  State<PulseData> createState() => _PulseDataState();
}

class _PulseDataState extends State<PulseData> {
  int weekday = DateTime.now().weekday;
  List<Point> points = [];
  @override
  Widget build(BuildContext context) {
    fetchWeekPulse();
    double width = MediaQuery.of(context).size.width - 60;
    return Expanded(
        child: Center(
            child: Padding(
      padding: const EdgeInsets.fromLTRB(0, 40, 0, 20),
      child:
          Column(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
        Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Text(
            'Tętno [bpm]',
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
          Navigator.of(context).pushReplacementNamed('/add-pulse');
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

  Future<void> fetchWeekPulse() async {
    List<HealthDataPoint> gotPulse = [];
    List<Point> listOfPoints = [];
    double? pulse = 0;
    double result = 0.0;

    // get steps for today (i.e., since midnight)
    final now = DateTime.now();
    DateTime midnight = DateTime(now.year, now.month, now.day);

    final types = [HealthDataType.HEART_RATE];
    bool requested =
        await widget.health.requestAuthorization([HealthDataType.HEART_RATE]);

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
          gotPulse = await widget.health
              .getHealthDataFromTypes(startDate, endDate, types);
        } catch (error) {
          print("Caught exception in gotPulse: $error");
        }

        gotPulse = HealthFactory.removeDuplicates(gotPulse);
        if (gotPulse.length == 0) {
          listOfPoints.add(Point(x: j.toDouble(), y: 0.0));
          j += 1;
        } else {
          gotPulse.forEach((x) => result += double.parse(x.value.toString()));
          pulse = result / double.parse(gotPulse.length.toString());
          listOfPoints.add(Point(x: j.toDouble(), y: pulse));
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

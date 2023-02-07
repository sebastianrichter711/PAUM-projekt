import 'package:flutter/material.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:healthcareapp/pages/details/widgets/chart/lineChart.dart';
import 'package:healthcareapp/widgets/bottom_navigation.dart';
import 'package:health/health.dart';

class BloodGlucosePage extends StatelessWidget {
  final HealthFactory health;
  const BloodGlucosePage({super.key, required this.health});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [BloodGlucoseData(health: health), BottomNavigation()],
      ),
    );
  }
}

class BloodGlucoseData extends StatefulWidget {
  final HealthFactory health;
  BloodGlucoseData({super.key, required this.health});

  @override
  State<BloodGlucoseData> createState() => _BloodGlucoseDataState();
}

class _BloodGlucoseDataState extends State<BloodGlucoseData> {
  int weekday = DateTime.now().weekday;
  List<Point> bloodGlucosePoints = [];

  @override
  Widget build(BuildContext context) {
    fetchBloodGlucoseWeek();
    double width = MediaQuery.of(context).size.width - 60;
    return Expanded(
        child: Center(
            child: Padding(
      padding: const EdgeInsets.fromLTRB(0, 40, 0, 20),
      child:
          Column(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
        Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Text(
            'Poziom glukozy',
            style: TextStyle(
              fontFamily: 'Manrope',
              fontWeight: FontWeight.bold,
              fontSize: 32,
              decoration: TextDecoration.none,
            ),
          ),
        ]),
        SizedBox(height: 20),
        LineChartWidget(health: widget.health, points: bloodGlucosePoints),
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
          Navigator.of(context).pushReplacementNamed('/add-blood-glucose');
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

  Future<void> fetchBloodGlucoseWeek() async {
    List<HealthDataPoint> gotBloodGlucose = [];
    List<Point> listOfPoints = [];
    double? bloodGlucose = 0;
    double result = 0.0;

    final now = DateTime.now();
    DateTime midnight = DateTime(now.year, now.month, now.day);

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
        gotBloodGlucose = await widget.health.getHealthDataFromTypes(
            startDate, endDate, [HealthDataType.BLOOD_GLUCOSE]);
      } catch (error) {
        print("Caught exception in gotPulse: $error");
      }

      gotBloodGlucose = HealthFactory.removeDuplicates(gotBloodGlucose);
      if (gotBloodGlucose.length == 0) {
        listOfPoints.add(Point(x: j.toDouble(), y: 0.0));
        j += 1;
      } else {
        gotBloodGlucose
            .forEach((x) => result += double.parse(x.value.toString()));
        bloodGlucose = result / double.parse(gotBloodGlucose.length.toString());
        print("Day $j  Glucose $bloodGlucose");
        listOfPoints.add(Point(x: j.toDouble(), y: bloodGlucose * 0.0555));
        j += 1;
      }
    }
    setState(() {
      bloodGlucosePoints = listOfPoints;
    });
  }
}

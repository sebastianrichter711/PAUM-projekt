import 'package:flutter/material.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:healthcareapp/pages/details/widgets/chart/lineChart.dart';
import 'package:healthcareapp/widgets/bottom_navigation.dart';
import 'package:health/health.dart';

class SleepPage extends StatelessWidget {
  final HealthFactory health;
  const SleepPage({super.key, required this.health});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [SleepData(health: health), BottomNavigation()],
      ),
    );
  }
}

class SleepData extends StatefulWidget {
  final HealthFactory health;
  SleepData({super.key, required this.health});

  @override
  State<SleepData> createState() => _SleepDataState();
}

class _SleepDataState extends State<SleepData> {
  int weekday = DateTime.now().weekday;
  List<Point> points = [];
  @override
  Widget build(BuildContext context) {
    fetchWeekSleep();
    double width = MediaQuery.of(context).size.width - 60;
    return Expanded(
        child: Center(
            child: Padding(
      padding: const EdgeInsets.fromLTRB(0, 40, 0, 20),
      child:
          Column(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
        Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Text(
            'Sen',
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
            modeButton("Dodaj pomiar", 'Czas trwania snu', Icons.add,
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
          Navigator.of(context).pushNamed('/add-sleep');
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

  Future<void> fetchWeekSleep() async {
    List<HealthDataPoint> gotSleep = [];
    List<Point> listOfPoints = [];
    double? sleep = 0;
    // double result = 0.0;
    int hours = 0;
    int minutes = 0;
    int nextDayHours = 0;
    int nextDayMinutes = 0;

    // get steps for today (i.e., since midnight)
    final now = DateTime.now();
    DateTime midnight = DateTime(now.year, now.month, now.day);

    final types = [HealthDataType.SLEEP_IN_BED];
    bool requested =
        await widget.health.requestAuthorization([HealthDataType.SLEEP_IN_BED]);

    if (requested) {
      int j = 0;
      for (int i = 6; i >= 0; i--) {
        // result = 0.0;
        hours = nextDayHours;
        minutes = nextDayMinutes;
        nextDayHours = 0;
        nextDayMinutes = 0;
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
          gotSleep = await widget.health
              .getHealthDataFromTypes(startDate, endDate, types);
        } catch (error) {
          print("Caught exception in gotSleep: $error");
        }

        gotSleep = HealthFactory.removeDuplicates(gotSleep);
        if (gotSleep.length == 0) {
          Point newPoint = Point(x: j.toDouble(), y: 0.0);
          listOfPoints.add(newPoint);
          print("Day:  $j  Sleep:  $sleep");
          j += 1;
        } else {
          gotSleep.forEach((x) {
            // result += double.parse(x.value.toString());
            if (x.dateFrom.day < x.dateTo.day) {
              DateTime currentPointMidnight =
                  DateTime(x.dateTo.year, x.dateTo.month, x.dateTo.day);

              Duration firstHalfSleepLength =
                  currentPointMidnight.difference(x.dateFrom);
              hours += firstHalfSleepLength.inHours;
              minutes += firstHalfSleepLength.inMinutes;

              Duration secondHalfSleepLength =
                  x.dateTo.difference(currentPointMidnight);
              nextDayHours += secondHalfSleepLength.inHours;
              nextDayMinutes += secondHalfSleepLength.inMinutes;
            } else {
              Duration sleepLength = x.dateTo.difference(x.dateFrom);
              hours += sleepLength.inHours;
              minutes += sleepLength.inMinutes;
            }
            ;
          });
          var partOfHour = double.parse(
              ((minutes / 60) - (minutes / 60).truncate()).toStringAsFixed(2));
          var hoursToSave = hours.toDouble() + partOfHour;
          // sleep = result / double.parse(gotSleep.length.toString());
          Point newPoint = Point(x: j.toDouble(), y: hoursToSave);
          listOfPoints.add(newPoint);
          print("Day:  $j  Sleep:  $hoursToSave:$minutes");
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

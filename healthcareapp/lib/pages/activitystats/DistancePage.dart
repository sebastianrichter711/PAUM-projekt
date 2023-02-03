import 'package:flutter/material.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:healthcareapp/widgets/bottom_navigation.dart';
import 'package:health/health.dart';

class DistancePage extends StatelessWidget {
  const DistancePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: const [DistancePageWidget(), BottomNavigation()],
      ),
    );
  }
}

class DistancePageWidget extends StatefulWidget {
  const DistancePageWidget({super.key});

  @override
  State<DistancePageWidget> createState() => _DistancePageWidgetState();
}

class _DistancePageWidgetState extends State<DistancePageWidget> {
  double todayDistance = 0;
  double weekDistance = 0;
  double avgWeekDistance = 0.0;
  int weekday = DateTime.now().weekday;
  @override
  Widget build(BuildContext context) {
    fetchTodayDistance();
    fetchWeekDistance();
    double width = MediaQuery.of(context).size.width - 80;
    return Expanded(
        child: Center(
            child: Padding(
      padding: const EdgeInsets.fromLTRB(0, 40, 0, 20),
      child:
          Column(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
        Column(children: [
          Text(
            'Odległość',
            style: TextStyle(
              fontFamily: 'Manrope',
              fontWeight: FontWeight.bold,
              fontSize: 42,
              decoration: TextDecoration.none,
            ),
          ),
        ]),
        Wrap(
          runSpacing: 16,
          children: [
            modeButton(
                todayDistance.toStringAsFixed(2),
                'Dystans przebyty dziś [km]',
                FontAwesomeIcons.calendarDay,
                Color(0xFFFE7F00),
                width),
            modeButton(
                weekDistance.toStringAsFixed(2),
                'Dystans tygodniowy [km]',
                FontAwesomeIcons.calendarWeek,
                Color(0xFFFE7F00),
                width),
            modeButton(
                (weekDistance / weekday).round().toStringAsFixed(2),
                'Średni dzienny dystans [km]',
                FontAwesomeIcons.calendarWeek,
                Color(0xFFFE7F00),
                width),
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
                        Padding(
                            padding: const EdgeInsets.only(top: 6.0),
                            child: Text(subtitle,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    decoration: TextDecoration.none,
                                    fontFamily: 'Manrope',
                                    color: Colors.white,
                                    fontSize: 12)))
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

  Future<void> fetchTodayDistance() async {
    List<HealthDataPoint> gotDistance = [];
    double sum = 0.0;

    HealthFactory health = HealthFactory();

    // get steps for today (i.e., since midnight)
    final now = DateTime.now();
    final midnight = DateTime(now.year, now.month, now.day);

    final types = [HealthDataType.DISTANCE_DELTA];

    bool requested =
        await health.requestAuthorization([HealthDataType.DISTANCE_DELTA]);

    if (requested) {
      try {
        gotDistance = await health.getHealthDataFromTypes(midnight, now, types);
      } catch (error) {
        print("Caught exception in getHealthDataTypes: $error");
      }

      gotDistance = HealthFactory.removeDuplicates(gotDistance);

      // print the results
      //gotDistance.forEach((x) => print(x.value));
      gotDistance.forEach((x) => sum += double.parse(x.value.toString()));

      setState(() {
        todayDistance = sum / 1000;
      });
    } else {
      print("Authorization not granted - error in authorization");
    }
  }

  Future<void> fetchWeekDistance() async {
    List<HealthDataPoint> gotDistance = [];
    double sum = 0.0;

    HealthFactory health = HealthFactory();

    // get steps for today (i.e., since midnight)
    final now = DateTime.now();
    final midnight = DateTime(now.year, now.month, now.day);
    final weekBegin = midnight.subtract(Duration(days: midnight.weekday - 1));

    final types = [HealthDataType.DISTANCE_DELTA];

    bool requested =
        await health.requestAuthorization([HealthDataType.DISTANCE_DELTA]);

    if (requested) {
      try {
        gotDistance =
            await health.getHealthDataFromTypes(weekBegin, now, types);
      } catch (error) {
        print("Caught exception in getHealthDataTypes: $error");
      }

      gotDistance = HealthFactory.removeDuplicates(gotDistance);

      // print the results
      //gotDistance.forEach((x) => print(x.value));
      gotDistance.forEach((x) => sum += double.parse(x.value.toString()));

      setState(() {
        weekDistance = sum / 1000;
      });
    } else {
      print("Authorization not granted - error in authorization");
    }
  }
}

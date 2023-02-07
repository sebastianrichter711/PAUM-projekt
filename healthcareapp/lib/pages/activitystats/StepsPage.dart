import 'package:flutter/material.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:healthcareapp/widgets/bottom_navigation.dart';
import 'package:health/health.dart';

class StepsPage extends StatelessWidget {
  const StepsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: const [StepsPageWidget(), BottomNavigation()],
      ),
    );
  }
}

class StepsPageWidget extends StatefulWidget {
  const StepsPageWidget({super.key});

  @override
  State<StepsPageWidget> createState() => _StepsPageWidgetState();
}

class _StepsPageWidgetState extends State<StepsPageWidget> {
  int todaySteps = 0;
  int weekSteps = 0;
  double avgWeekSteps = 0.0;
  int weekday = DateTime.now().weekday;
  @override
  Widget build(BuildContext context) {
    fetchTodaySteps();
    fetchWeekSteps();
    double width = MediaQuery.of(context).size.width - 60;
    return Expanded(
        child: Center(
            child: Padding(
      padding: const EdgeInsets.fromLTRB(0, 40, 0, 20),
      child:
          Column(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
        Column(children: [
          Text(
            'Kroki',
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
            modeButton(todaySteps.toString(), 'Dzisiejsza liczba kroków',
                FontAwesomeIcons.calendarDay, Color(0xFFFE7F00), width),
            modeButton(weekSteps.toString(), 'Liczba kroków w tym tygodniu',
                FontAwesomeIcons.calendarWeek, Color(0xFFFE7F00), width),
            modeButton(
                avgWeekSteps.toStringAsFixed(1),
                'Średnia liczba kroków/dzień',
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

  Future<void> fetchWeekSteps() async {
    int? numberOfSteps;

    final now = DateTime.now();
    final midnight = DateTime(now.year, now.month, now.day);
    final weekBegin = midnight.subtract(Duration(days: midnight.weekday - 1));

    HealthFactory health = HealthFactory();

    try {
      numberOfSteps = await health.getTotalStepsInInterval(weekBegin, now);
    } catch (error) {
      print("Caught exception in getTotalStepsInInterval: $error");
    }

    numberOfSteps = (numberOfSteps == null) ? 0 : numberOfSteps;
    setState(() {
      weekSteps = numberOfSteps!;
      avgWeekSteps = (weekSteps / weekday);
    });
  }

  Future<void> fetchTodaySteps() async {
    int? numberOfSteps = 0;

    HealthFactory health = HealthFactory();

    final now = DateTime.now();
    final midnight = DateTime(now.year, now.month, now.day);

    try {
      numberOfSteps = await health.getTotalStepsInInterval(midnight, now);
    } catch (error) {
      print("Caught exception in getTotalStepsInInterval: $error");
    }

    //print('Total number of steps: $numberOfSteps');

    //numberOfSteps = (numberOfSteps == null) ? 0 : numberOfSteps;
    setState(() {
      todaySteps = numberOfSteps!;
    });
  }
}

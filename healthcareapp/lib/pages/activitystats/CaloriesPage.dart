import 'package:flutter/material.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:healthcareapp/data/DataFactory.dart';
import 'package:healthcareapp/widgets/bottom_navigation.dart';
import 'package:health/health.dart';

class CaloriesPage extends StatelessWidget {
  const CaloriesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: const [CaloriesPageWidget(), BottomNavigation()],
      ),
    );
  }
}

class CaloriesPageWidget extends StatefulWidget {
  const CaloriesPageWidget({super.key});

  @override
  State<CaloriesPageWidget> createState() => _CaloriesPageWidgetState();
}

class _CaloriesPageWidgetState extends State<CaloriesPageWidget> {
  double todayCalories = 0.0;
  double weekCalories = 0.0;
  double avgWeekCalories = 0.0;
  int weekday = DateTime.now().weekday;
  @override
  Widget build(BuildContext context) {
    DataFactory df = DataFactory();
    df.fetchTodayCalories().then((double result) => {
          setState(() {
            todayCalories = result;
          })
        });
    df.fetchWeekCalories().then((double result) => {
          setState(() {
            weekCalories = result;
          })
        });
    double width = MediaQuery.of(context).size.width - 60;
    return Expanded(
        child: Center(
            child: Padding(
      padding: const EdgeInsets.fromLTRB(0, 40, 0, 20),
      child:
          Column(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
        Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Text(
            'Wydatek',
            style: TextStyle(
              fontFamily: 'Manrope',
              fontWeight: FontWeight.bold,
              fontSize: 42,
              decoration: TextDecoration.none,
            ),
          ),
          Text(
            'energetyczny',
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
                todayCalories.toStringAsFixed(2),
                'Spalone kalorie dziś [Cal]',
                FontAwesomeIcons.calendarDay,
                Color(0xFFFE7F00),
                width),
            modeButton(
                weekCalories.toStringAsFixed(2),
                'Spalone kalorie w tyg. [Cal]',
                FontAwesomeIcons.calendarWeek,
                Color(0xFFFE7F00),
                width),
            modeButton(
                (weekCalories / weekday).round().toStringAsFixed(2),
                'Śr. liczba spalonych kal. [Cal]',
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
}

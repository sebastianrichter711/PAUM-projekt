import 'package:flutter/material.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:healthcareapp/widgets/bottom_navigation.dart';
import 'package:health/health.dart';

class CaloriesPage extends StatelessWidget {
  final HealthFactory health;
  const CaloriesPage({super.key, required this.health});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [CaloriesPageWidget(health: health), BottomNavigation()],
      ),
    );
  }
}

class CaloriesPageWidget extends StatefulWidget {
  final HealthFactory health;
  CaloriesPageWidget({super.key, required this.health});

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
    fetchTodayCalories();
    fetchWeekCalories();
    double width = MediaQuery.of(context).size.width - 80;
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

  Future<void> fetchTodayCalories() async {
    List<HealthDataPoint> gotCalories = [];
    double sum = 0.0;

    //HealthFactory health = HealthFactory();

    // get steps for today (i.e., since midnight)
    final now = DateTime.now();
    final midnight = DateTime(now.year, now.month, now.day);

    final types = [HealthDataType.ACTIVE_ENERGY_BURNED];

    bool requested = await widget.health
        .requestAuthorization([HealthDataType.ACTIVE_ENERGY_BURNED]);

    if (requested) {
      try {
        gotCalories =
            await widget.health.getHealthDataFromTypes(midnight, now, types);
      } catch (error) {
        print("Caught exception in getHealthDataTypes: $error");
      }

      gotCalories = HealthFactory.removeDuplicates(gotCalories);

      // print the results
      gotCalories.forEach((x) => sum += double.parse(x.value.toString()));

      setState(() {
        todayCalories = sum;
      });
    } else {
      print("Authorization not granted - error in authorization");
    }
  }

  Future<void> fetchWeekCalories() async {
    List<HealthDataPoint> gotCalories = [];
    double sum = 0.0;

    //HealthFactory health = HealthFactory();

    // get steps for today (i.e., since midnight)
    final now = DateTime.now();
    final midnight = DateTime(now.year, now.month, now.day);
    final weekBegin = midnight.subtract(Duration(days: midnight.weekday - 1));

    final types = [HealthDataType.ACTIVE_ENERGY_BURNED];

    bool requested = await widget.health
        .requestAuthorization([HealthDataType.ACTIVE_ENERGY_BURNED]);

    if (requested) {
      try {
        gotCalories =
            await widget.health.getHealthDataFromTypes(weekBegin, now, types);
      } catch (error) {
        print("Caught exception in getHealthDataTypes: $error");
      }

      gotCalories = HealthFactory.removeDuplicates(gotCalories);

      // print the results
      //gotDistance.forEach((x) => print(x.value));
      gotCalories.forEach((x) => sum += double.parse(x.value.toString()));

      setState(() {
        weekCalories = sum;
      });
    } else {
      print("Authorization not granted - error in authorization");
    }
  }
}

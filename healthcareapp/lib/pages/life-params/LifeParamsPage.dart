import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:health/health.dart';
import 'package:flutter/material.dart';
import 'package:healthcareapp/widgets/bottom_navigation.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class LifeParamsPage extends StatelessWidget {
  final HealthFactory health;
  const LifeParamsPage({super.key, required this.health});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [LifeParamsList(health: health), BottomNavigation()],
      ),
    );
  }
}

class LifeParamsList extends StatefulWidget {
  final HealthFactory health;
  LifeParamsList({super.key, required this.health});

  @override
  State<LifeParamsList> createState() => _LifeParamsListState();
}

class _LifeParamsListState extends State<LifeParamsList> {
  int todaySteps = 0;
  int weekSteps = 0;
  double avgWeekSteps = 0.0;
  int weekday = DateTime.now().weekday;
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width - 60;
    return Expanded(
        child: Center(
            child: Padding(
      padding: const EdgeInsets.fromLTRB(0, 40, 0, 20),
      child:
          Column(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
        Column(children: [
          Text(
            'Parametry',
            style: TextStyle(
              fontFamily: 'Manrope',
              fontWeight: FontWeight.bold,
              fontSize: 42,
              decoration: TextDecoration.none,
            ),
          ),
          Text(
            'życiowe',
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
            modeButton("Tętno", "", Icons.favorite_outline, Color(0xFF008000),
                width, 24),
            modeButton("Ciśnienie krwi", "", Icons.bloodtype, Color(0xFF008000),
                width, 24),
            modeButton("Temperatura ciała", "ciała", Icons.device_thermostat,
                Color(0xFF008000), width, 20),
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

  GestureDetector modeButton(String title, String subtitle, IconData icon,
      Color color, double width, double fontSize) {
    String nextPage = "";
    switch (title) {
      case "Tętno":
        nextPage = '/pulse';
        break;
      case "Ciśnienie krwi":
        nextPage = '/blood-pressure';
        break;
      case "Temperatura ciała":
        nextPage = '/body-temperature';
        break;
    }
    return GestureDetector(
        onTap: () {
          Navigator.of(context).pushNamed(nextPage);
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
                              fontSize: fontSize,
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

  // Future fetchStepData() async {
  //   int? steps;

  //   // get steps for today (i.e., since midnight)
  //   final now = DateTime.now();
  //   final midnight = DateTime(now.year, now.month, now.day);

  //   bool requested = await widget.health
  //       .requestAuthorization([HealthWorkoutActivityType.WALKING]);

  //   List<HealthWorkoutActivityType> types = [HealthWorkoutActivityType.WALKING];
  //   if (requested) {
  //     try {
  //       await widget.health.getHealthDataFromTypes(midnight, now, types);
  //     } catch (error) {
  //       print("Caught exception in getTotalStepsInInterval: $error");
  //     }

  //     print('Total number of steps: $steps');

  //     setState(() {
  //       _nofSteps = (steps == null) ? 0 : steps;
  //       _state = (steps == null) ? AppState.NO_DATA : AppState.STEPS_READY;
  //     });
  //   } else {
  //     print("Authorization not granted - error in authorization");
  //     setState(() => _state = AppState.DATA_NOT_FETCHED);
  //   }
  // }
}

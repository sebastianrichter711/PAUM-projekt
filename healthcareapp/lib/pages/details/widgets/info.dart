import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:health/health.dart';

class Info extends StatelessWidget {
  const Info({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: const [InfoWidget()],
    );
  }
}

class InfoWidget extends StatefulWidget {
  const InfoWidget({super.key});

  @override
  State<InfoWidget> createState() => _InfoWidgetState();
}

class _InfoWidgetState extends State<InfoWidget> {
  int calories = 0;
  double distance = 0.0;
  int minOfMove = 0;
  @override
  Widget build(BuildContext context) {
    fetchCalories();
    fetchDistance();
    fetchMinOfMove();
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        FaIcon(FontAwesomeIcons.bolt, size: 19, color: Colors.blue),
        const SizedBox(width: 2),
        Text.rich(
          TextSpan(
              text: calories.toString(),
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
              children: [
                const TextSpan(text: ' '),
                TextSpan(
                    text: "kcal",
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                    ))
              ]),
        ),
        const SizedBox(width: 9),
        FaIcon(FontAwesomeIcons.road, size: 19, color: Colors.blue),
        const SizedBox(width: 2),
        Text.rich(
          TextSpan(
              text: distance.toStringAsFixed(2),
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
              children: [
                const TextSpan(text: ' '),
                TextSpan(
                    text: "km",
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                    ))
              ]),
        ),
        const SizedBox(width: 9),
        FaIcon(FontAwesomeIcons.personWalking, size: 19, color: Colors.blue),
        const SizedBox(width: 2),
        Text.rich(
          TextSpan(
              text: minOfMove.toString(),
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
              children: [
                const TextSpan(text: ' '),
                TextSpan(
                    text: "min",
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                    ))
              ]),
        ),
      ],
    );
  }

  Future<void> fetchCalories() async {
    List<HealthDataPoint> gotCalories = [];
    double sum = 0.0;

    HealthFactory health = HealthFactory();

    // get steps for today (i.e., since midnight)
    final now = DateTime.now();
    final midnight = DateTime(now.year, now.month, now.day);

    final types = [HealthDataType.ACTIVE_ENERGY_BURNED];

    bool requested = await health
        .requestAuthorization([HealthDataType.ACTIVE_ENERGY_BURNED]);

    if (requested) {
      try {
        gotCalories = await health.getHealthDataFromTypes(midnight, now, types);
      } catch (error) {
        print("Caught exception in getHealthDataTypes: $error");
      }

      gotCalories = HealthFactory.removeDuplicates(gotCalories);

      // print the results
      gotCalories.forEach((x) => sum += double.parse(x.value.toString()));

      setState(() {
        calories = sum.round();
      });
    } else {
      print("Authorization not granted - error in authorization");
    }
  }

  Future<void> fetchDistance() async {
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
        distance = sum / 1000;
      });
    } else {
      print("Authorization not granted - error in authorization");
    }
  }

  Future<void> fetchMinOfMove() async {
    List<HealthDataPoint> gotMinutes = [];
    double sum = 0.0;

    HealthFactory health = HealthFactory();

    // get steps for today (i.e., since midnight)
    final now = DateTime.now();
    final midnight = DateTime(now.year, now.month, now.day);

    final types = [HealthDataType.MOVE_MINUTES];

    bool requested =
        await health.requestAuthorization([HealthDataType.MOVE_MINUTES]);

    if (requested) {
      try {
        gotMinutes = await health.getHealthDataFromTypes(midnight, now, types);
      } catch (error) {
        print("Caught exception in getHealthDataTypes: $error");
      }

      gotMinutes = HealthFactory.removeDuplicates(gotMinutes);

      // print the results
      //gotMinutes.forEach((x) => print(x.value));
      gotMinutes.forEach((x) => sum += double.parse(x.value.toString()));

      setState(() {
        minOfMove = sum.round();
      });
    } else {
      print("Authorization not granted - error in authorization");
    }
  }
}

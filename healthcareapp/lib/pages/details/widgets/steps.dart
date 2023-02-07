import 'package:flutter/material.dart';

import '../../../helpers.dart';
import 'package:health/health.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:async';

class Steps extends StatelessWidget {
  const Steps({super.key});

  @override
  Widget build(BuildContext context) {
    return const Expanded(
      child: SizedBox(
        width: double.infinity,
        child: StepsWidget(),
      ),
    );
  }
}

class StepsWidget extends StatefulWidget {
  const StepsWidget({super.key});

  @override
  State<StepsWidget> createState() => _StepsWidgetState();
}

class _StepsWidgetState extends State<StepsWidget> {
  String steps = "";
  @override
  Widget build(BuildContext context) {
    fetchStepData();
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Column(
        children: [
          Text(steps,
              style:
                  const TextStyle(fontSize: 33, fontWeight: FontWeight.w900)),
          const Text('Liczba kroków',
              style: TextStyle(
                  fontSize: 11, fontWeight: FontWeight.w500, height: 2))
        ],
      ),
    );
  }

  Future<void> fetchStepData() async {
    int? numberOfSteps;

    HealthFactory health = HealthFactory();

    // get steps for today (i.e., since midnight)
    final now = DateTime.now();
    final midnight = DateTime(now.year, now.month, now.day);

    bool requested = await health.requestAuthorization([HealthDataType.STEPS]);

    if (requested) {
      try {
        numberOfSteps = await health.getTotalStepsInInterval(midnight, now);
      } catch (error) {
        print("Caught exception in getTotalStepsInInterval: $error");
      }

      //print('Total number of steps: $numberOfSteps');

      numberOfSteps = (numberOfSteps == null) ? 0 : numberOfSteps;
      setState(() {
        steps = numberOfSteps.toString();
      });
    } else {
      print("Authorization not granted - error in authorization");
    }
  }
}

/// Fetch steps from the health plugin and show them in the app.

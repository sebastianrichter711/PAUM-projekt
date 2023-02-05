import 'package:flutter/material.dart';
import 'package:healthcareapp/pages/details/widgets/appbar.dart';
import 'package:healthcareapp/pages/details/widgets/chart/lineChart.dart';
import 'package:healthcareapp/pages/details/widgets/dates.dart';
import 'package:healthcareapp/pages/details/widgets/graph.dart';
import 'package:healthcareapp/pages/details/widgets/info.dart' hide Stats;
import 'package:healthcareapp/pages/details/widgets/stats.dart';
import 'package:healthcareapp/pages/details/widgets/steps.dart';
import 'package:healthcareapp/widgets/bottom_navigation.dart';
import 'package:health/health.dart';

class DetailsPage extends StatelessWidget {
  final HealthFactory health;
  const DetailsPage({super.key, required this.health});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SizedBox(
        width: double.infinity,
        child: DetailsPageStateful(health: health),
      ),
    );
  }
}

class DetailsPageStateful extends StatefulWidget {
  final HealthFactory health;
  const DetailsPageStateful({super.key, required this.health});

  @override
  State<DetailsPageStateful> createState() => _DetailsPageStatefulState();
}

class _DetailsPageStatefulState extends State<DetailsPageStateful> {
  List<Point> pointsToChart = [];
  @override
  Widget build(BuildContext context) {
    fetchStepData();
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: MainAppBar(appBar: AppBar()),
      body: Column(
        children: [
          Dates(),
          Steps(),
          LineChartWidget(health: widget.health, points: pointsToChart),
          Divider(height: 30),
          Info(),
          Divider(height: 30),
          Stats(),
          SizedBox(height: 30),
          BottomNavigation(),
        ],
      ),
    );
  }

  Future<void> fetchStepData() async {
    List<Point> listOfSteps = [];
    int? steps = 0;

    //HealthFactory health = HealthFactory();

    // get steps for today (i.e., since midnight)
    final now = DateTime.now();
    DateTime midnight = DateTime(now.year, now.month, now.day);

    bool requested =
        await widget.health.requestAuthorization([HealthDataType.STEPS]);

    if (requested) {
      int j = 0;
      for (int i = 6; i >= 0; i--) {
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
          steps =
              await widget.health.getTotalStepsInInterval(startDate, endDate);
        } catch (error) {
          print("Caught exception in getTotalStepsInInterval: $error");
        }
        Point newPoint = Point(x: j.toDouble(), y: steps!.toDouble());
        listOfSteps.add(newPoint);
        print("Day:  $j  Steps:  $steps");
        j += 1;
      }
      setState(() {
        pointsToChart = listOfSteps;
      });
    } else {
      print("Authorization not granted - error in authorization");
    }
  }
}

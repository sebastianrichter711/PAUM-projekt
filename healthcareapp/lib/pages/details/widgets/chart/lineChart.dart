import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:health/health.dart';

class LineChartWidget extends StatelessWidget {
  const LineChartWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Expanded(
      child: SizedBox(
        width: double.infinity,
        child: LineChartDraw(),
      ),
    );
  }
}

class LineChartDraw extends StatefulWidget {
  const LineChartDraw({super.key});

  @override
  State<LineChartDraw> createState() => _LineChartDrawState();
}

class _LineChartDrawState extends State<LineChartDraw> {
  List<Point> points = [];
  @override
  Widget build(BuildContext context) {
    fetchStepData();
    return AspectRatio(
      aspectRatio: 5,
      child: LineChart(LineChartData(
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: true)),
            rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: true)),
            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          ),
          lineBarsData: [
            LineChartBarData(
                spots: points.map((point) => FlSpot(point.x, point.y)).toList(),
                isCurved: true,
                dotData: FlDotData(show: true))
          ])),
    );
  }

  Future<void> fetchStepData() async {
    List<Point> listOfSteps = [];
    int? steps = 0;

    HealthFactory health = HealthFactory();

    // get steps for today (i.e., since midnight)
    final now = DateTime.now();
    DateTime midnight = DateTime(now.year, now.month, now.day);

    bool requested = await health.requestAuthorization([HealthDataType.STEPS]);

    if (requested) {
      // final startDate = now.subtract(Duration(days: 3));
      // final endDate = now.subtract(Duration(days: 2));

      // try {
      //   steps = await health.getTotalStepsInInterval(startDate, endDate);
      // } catch (error) {
      //   print("Caught exception in getTotalStepsInInterval: $error");
      // }

      // Point newPoint = Point(x: 0.toDouble(), y: steps!.toDouble());
      // listOfSteps.add(newPoint);

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
          steps = await health.getTotalStepsInInterval(startDate, endDate);
        } catch (error) {
          print("Caught exception in getTotalStepsInInterval: $error");
        }
        Point newPoint = Point(x: j.toDouble(), y: steps!.toDouble());
        listOfSteps.add(newPoint);
        print("Day:  $j  Steps:  $steps");
        j += 1;
      }
      setState(() {
        points = listOfSteps;
      });
    } else {
      print("Authorization not granted - error in authorization");
    }
  }
}

class Point {
  final double x;
  final double y;
  Point({required this.x, required this.y});
}

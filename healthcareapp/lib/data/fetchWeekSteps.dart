import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:health/health.dart';
import 'package:healthcareapp/pages/details/widgets/chart/lineChart.dart';
import 'package:intl/intl.dart';

class DataHelper {
  static Future<List<Point>> fetchStepData(HealthFactory health) async {
    List<Point> listOfSteps = [];
    int? steps = 0;

    HealthFactory health = HealthFactory();

    // get steps for today (i.e., since midnight)
    final now = DateTime.now();
    DateTime midnight = DateTime(now.year, now.month, now.day);

    bool requested = await health.requestAuthorization([HealthDataType.STEPS]);

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
          steps = await health.getTotalStepsInInterval(startDate, endDate);
        } catch (error) {
          print("Caught exception in getTotalStepsInInterval: $error");
        }
        Point newPoint = Point(x: j.toDouble(), y: steps!.toDouble());
        listOfSteps.add(newPoint);
        print("Day:  $j  Steps:  $steps");
        j += 1;
      }
      return listOfSteps;
    } else {
      print("Authorization not granted - error in authorization");
      return [];
    }
  }
}

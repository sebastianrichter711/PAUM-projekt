import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:health/health.dart';
import 'package:healthcareapp/pages/details/widgets/chart/lineChart.dart';
import 'package:intl/intl.dart';

class DataFactory {
  final HealthFactory health = HealthFactory();

  Future<List<Point>> fetchStepData() async {
    List<Point> listOfSteps = [];
    int? steps = 0;

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

  Future<double> fetchTodayCalories() async {
    List<HealthDataPoint> gotCalories = [];
    double sum = 0.0;

    //HealthFactory health = HealthFactory();

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

      double tmp;
      for (int i = 0; i < gotCalories.length; i++) {
        tmp = double.parse(gotCalories[i].value.toString());
        sum += tmp;
      }
      return sum;
    } else {
      print("Authorization not granted - error in authorization");
      return sum;
    }
  }

  Future<double> fetchWeekCalories() async {
    List<HealthDataPoint> gotCalories = [];
    double sum = 0.0;

    //HealthFactory health = HealthFactory();

    // get steps for today (i.e., since midnight)
    final now = DateTime.now();
    final midnight = DateTime(now.year, now.month, now.day);
    final weekBegin = midnight.subtract(Duration(days: midnight.weekday - 1));

    final types = [HealthDataType.ACTIVE_ENERGY_BURNED];

    bool requested = await health
        .requestAuthorization([HealthDataType.ACTIVE_ENERGY_BURNED]);

    if (requested) {
      try {
        gotCalories =
            await health.getHealthDataFromTypes(weekBegin, now, types);
      } catch (error) {
        print("Caught exception in getHealthDataTypes: $error");
      }

      gotCalories = HealthFactory.removeDuplicates(gotCalories);

      double tmp;
      for (int i = 0; i < gotCalories.length; i++) {
        tmp = double.parse(gotCalories[i].value.toString());
        sum += tmp;
      }
      return sum;
    } else {
      print("Authorization not granted - error in authorization");
      return sum;
    }
  }
}

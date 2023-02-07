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

    final now = DateTime.now();
    DateTime midnight = DateTime(now.year, now.month, now.day);

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
      listOfSteps.add(Point(x: j.toDouble(), y: steps!.toDouble()));
      j += 1;
    }
    return listOfSteps;
  }

  Future<double> fetchTodayCalories() async {
    List<HealthDataPoint> gotCalories = [];
    double sum = 0.0;

    final now = DateTime.now();
    final midnight = DateTime(now.year, now.month, now.day);

    try {
      gotCalories = await health.getHealthDataFromTypes(
          midnight, now, [HealthDataType.ACTIVE_ENERGY_BURNED]);
    } catch (error) {
      print("Caught exception in getHealthDataTypes: $error");
    }

    gotCalories = HealthFactory.removeDuplicates(gotCalories);

    gotCalories.forEach((x) => sum += double.parse(x.value.toString()));
    return sum;
  }

  Future<double> fetchWeekCalories() async {
    List<HealthDataPoint> gotCalories = [];
    double sum = 0.0;

    final now = DateTime.now();
    final midnight = DateTime(now.year, now.month, now.day);
    final weekBegin = midnight.subtract(Duration(days: midnight.weekday - 1));

    try {
      gotCalories = await health.getHealthDataFromTypes(
          weekBegin, now, [HealthDataType.ACTIVE_ENERGY_BURNED]);
    } catch (error) {
      print("Caught exception in getHealthDataTypes: $error");
    }

    gotCalories = HealthFactory.removeDuplicates(gotCalories);

    gotCalories.forEach((x) => sum += double.parse(x.value.toString()));

    return sum;
  }
}

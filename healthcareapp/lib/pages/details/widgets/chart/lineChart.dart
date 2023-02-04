import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:health/health.dart';
import 'package:healthcareapp/data/fetchWeekSteps.dart';
import 'package:intl/intl.dart';

class LineChartWidget extends StatelessWidget {
  final HealthFactory health;
  final List<Point> points;
  const LineChartWidget(
      {super.key, required this.health, required this.points});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SizedBox(
        width: double.infinity,
        child: LineChartDraw(health: health, points: points),
      ),
    );
  }
}

class LineChartDraw extends StatefulWidget {
  final HealthFactory health;
  List<Point> points;
  LineChartDraw({super.key, required this.health, required this.points});

  @override
  State<LineChartDraw> createState() => _LineChartDrawState();
}

class _LineChartDrawState extends State<LineChartDraw> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: double.infinity,
      child: LineChart(LineChartData(
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(
                sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 35,
            )),
            rightTitles: AxisTitles(
                sideTitles: SideTitles(showTitles: false, reservedSize: 35)),
            bottomTitles: AxisTitles(sideTitles: _bottomTitles),
            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          ),
          borderData: FlBorderData(
            show: true,
            border: Border.all(color: const Color(0xff37434d), width: 1),
          ),
          lineBarsData: [
            LineChartBarData(
                spots: widget.points
                    .map((point) => FlSpot(point.x, point.y))
                    .toList(),
                isCurved: true,
                dotData: FlDotData(show: true))
          ])),
    );
  }

  String polishWeekday(String engWeekDay) {
    String polishWeekDay = "";
    switch (engWeekDay) {
      case "Monday":
        polishWeekDay = "Pon";
        break;
      case "Tuesday":
        polishWeekDay = "Wt";
        break;
      case "Wednesday":
        polishWeekDay = "Śr";
        break;
      case "Thursday":
        polishWeekDay = "Czw";
        break;
      case "Friday":
        polishWeekDay = "Pt";
        break;
      case "Saturday":
        polishWeekDay = "Sb";
        break;
      case "Sunday":
        polishWeekDay = "Nd";
        break;
    }

    return polishWeekDay;
  }

  SideTitles get _bottomTitles => SideTitles(
        showTitles: true,
        reservedSize: 35,
        getTitlesWidget: (value, meta) {
          String text = '';
          DateTime now = DateTime.now();
          double fraction = value - value.truncate();
          if (fraction != 0) {
            return Text("");
          } else {
            switch (value.toInt()) {
              case 0:
                text = polishWeekday(
                    DateFormat('EEEE').format(now.subtract(Duration(days: 6))));
                break;
              case 1:
                text = polishWeekday(
                    DateFormat('EEEE').format(now.subtract(Duration(days: 5))));
                break;
              case 2:
                text = polishWeekday(
                    DateFormat('EEEE').format(now.subtract(Duration(days: 4))));
                break;
              case 3:
                text = polishWeekday(
                    DateFormat('EEEE').format(now.subtract(Duration(days: 3))));
                break;
              case 4:
                text = polishWeekday(
                    DateFormat('EEEE').format(now.subtract(Duration(days: 2))));
                break;
              case 5:
                text = polishWeekday(
                    DateFormat('EEEE').format(now.subtract(Duration(days: 1))));
                break;
              case 6:
                text = polishWeekday(DateFormat('EEEE').format(now));
                break;
            }

            return Text(text);
          }
        },
      );
}

class Point {
  final double x;
  final double y;
  Point({required this.x, required this.y});
}

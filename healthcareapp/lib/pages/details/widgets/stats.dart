import 'package:flutter/material.dart';
import 'package:health/health.dart';

class Stats extends StatelessWidget {
  const Stats({super.key});
  @override
  Widget build(BuildContext context) {
    return const Expanded(
      child: SizedBox(
        width: double.infinity,
        child: StatsWidget(),
      ),
    );
  }
}

class StatsWidget extends StatefulWidget {
  const StatsWidget({super.key});

  @override
  State<StatsWidget> createState() => _StatsWidgetState();
}

class _StatsWidgetState extends State<StatsWidget> {
  double temperature = 0.0;
  String bloodPressure = "";
  String pulse = "";
  HealthFactory health = HealthFactory();
  @override
  Widget build(BuildContext context) {
    fetchBodyTemperature(health);
    fetchPulse(health);
    fetchBloodPressure(health);
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Row(
            children: const [
              Text('Statystyki',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                  )),
              SizedBox(width: 8),
              Icon(Icons.pie_chart_rounded, size: 15, color: Color(0xff3bc6fa))
            ],
          ),
        ),
        const SizedBox(height: 15),
        SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                SizedBox(width: 30),
                InfoStat(
                    icon: Icons.device_thermostat,
                    iconColor: Color(0xff535bed),
                    iconBackground: Color(0xffe4e7ff),
                    time: '+5s',
                    label: 'Temperatura ciała',
                    value: temperature.toStringAsFixed(1) + " ℃"),
                SizedBox(width: 15),
                InfoStat(
                    icon: Icons.favorite_outline,
                    iconColor: Color(0xffe11e6c),
                    iconBackground: Color(0xffffe4fb),
                    time: '+5s',
                    label: 'Tętno',
                    value: pulse + ' bpm'),
                SizedBox(width: 15),
                InfoStat(
                  icon: Icons.bloodtype,
                  iconColor: Color(0xffd3b50f),
                  iconBackground: Color(0xfffb4be4),
                  time: '+5s',
                  label: 'Ciśnienie krwi',
                  value: bloodPressure + ' mmHg',
                ),
                SizedBox(width: 30),
              ],
            ))
      ],
    );
  }

  Future<void> fetchBodyTemperature(HealthFactory health) async {
    List<HealthDataPoint> gotTemperature = [];

    //HealthFactory health = HealthFactory();

    // get steps for today (i.e., since midnight)
    final now = DateTime.now();
    final midnight = DateTime(2022, 11, 1);

    final types = [HealthDataType.BODY_TEMPERATURE];

    bool requested =
        await health.requestAuthorization([HealthDataType.BODY_TEMPERATURE]);

    if (requested) {
      try {
        gotTemperature =
            await health.getHealthDataFromTypes(midnight, now, types);
      } catch (error) {
        print("Caught exception in getHealthDataTypes: $error");
      }

      //print('Temperature data: $gotTemperature');

      setState(() {
        temperature = double.parse(
            gotTemperature[gotTemperature.length - 1].value.toString());
      });
    } else {
      print("Authorization not granted - error in authorization");
    }
  }

  Future<void> fetchPulse(HealthFactory health) async {
    List<HealthDataPoint> gotPulse = [];

    //HealthFactory health = HealthFactory();

    // get steps for today (i.e., since midnight)
    final now = DateTime.now();
    final midnight = DateTime(2022, 11, 1);

    final types = [HealthDataType.HEART_RATE];

    bool requested =
        await health.requestAuthorization([HealthDataType.HEART_RATE]);

    if (requested) {
      try {
        gotPulse = await health.getHealthDataFromTypes(midnight, now, types);
      } catch (error) {
        print("Caught exception in getHealthDataTypes: $error");
      }

      //print('Temperature data: $gotPulse');
      gotPulse.forEach((x) => print(x.value));

      setState(() {
        pulse = gotPulse[gotPulse.length - 1].value.toString();
      });
    } else {
      print("Authorization not granted - error in authorization");
    }
  }

  Future<void> fetchBloodPressure(HealthFactory health) async {
    List<HealthDataPoint> gotSystolicBloodPressure = [];
    List<HealthDataPoint> gotDiastolicBloodPressure = [];

    String systolicBloodPressure = "";
    String diastolicBloodPressure = "";

    //HealthFactory health = HealthFactory();

    // get steps for today (i.e., since midnight)
    final now = DateTime.now();
    final midnight = DateTime(2022, 11, 1);

    List<HealthDataType> types = [HealthDataType.BLOOD_PRESSURE_SYSTOLIC];

    bool requested = await health
        .requestAuthorization([HealthDataType.BLOOD_PRESSURE_SYSTOLIC]);

    if (requested) {
      try {
        gotSystolicBloodPressure =
            await health.getHealthDataFromTypes(midnight, now, types);
      } catch (error) {
        print("Caught exception in getHealthDataTypes: $error");
      }

      print('Temperature data: $gotSystolicBloodPressure');

      systolicBloodPressure =
          gotSystolicBloodPressure[gotSystolicBloodPressure.length - 1]
              .value
              .toString();
    } else {
      print("Authorization not granted - error in authorization");
    }

    types = [HealthDataType.BLOOD_PRESSURE_DIASTOLIC];

    requested = await health
        .requestAuthorization([HealthDataType.BLOOD_PRESSURE_DIASTOLIC]);

    if (requested) {
      try {
        gotDiastolicBloodPressure =
            await health.getHealthDataFromTypes(midnight, now, types);
      } catch (error) {
        print("Caught exception in getHealthDataTypes: $error");
      }

      print('Temperature data: $gotDiastolicBloodPressure');

      diastolicBloodPressure =
          gotDiastolicBloodPressure[gotDiastolicBloodPressure.length - 1]
              .value
              .toString();
    } else {
      print("Authorization not granted - error in authorization");
    }

    setState(() {
      bloodPressure = systolicBloodPressure + "/" + diastolicBloodPressure;
    });
  }
}

class InfoStat extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final Color iconBackground;
  final String time;
  final String label;
  final String value;

  const InfoStat(
      {super.key,
      required this.icon,
      required this.iconColor,
      required this.iconBackground,
      required this.time,
      required this.label,
      required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 110,
        width: 110,
        padding: const EdgeInsets.all(8),
        margin: const EdgeInsets.symmetric(vertical: 5),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            border: Border.all(
              color: const Color(0xffe1e1e1),
            ),
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                offset: Offset(3, 3),
                blurRadius: 3,
              )
            ]),
        child: Stack(children: [
          StatIcon(
              icon: icon, iconColor: iconColor, iconBackground: iconBackground),
          Align(
            alignment: Alignment.bottomLeft,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: const TextStyle(fontSize: 10)),
                Text(value,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w800)),
              ],
            ),
          )
        ]));
  }
}

class Change extends StatelessWidget {
  const Change({
    Key? key,
    required this.time,
  }) : super(key: key);

  final String time;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topRight,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 1, horizontal: 4),
        decoration: BoxDecoration(
          color: Colors.green,
          borderRadius: BorderRadius.circular(500),
        ),
        child: Text(
          time,
          style: const TextStyle(fontSize: 10, color: Colors.white),
        ),
      ),
    );
  }
}

class StatIcon extends StatelessWidget {
  const StatIcon({
    Key? key,
    required this.icon,
    required this.iconColor,
    required this.iconBackground,
  }) : super(key: key);

  final IconData icon;
  final Color iconColor;
  final Color iconBackground;

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          color: iconBackground,
          borderRadius: BorderRadius.circular(9),
        ),
        child: Icon(icon, size: 15, color: iconColor));
  }
}

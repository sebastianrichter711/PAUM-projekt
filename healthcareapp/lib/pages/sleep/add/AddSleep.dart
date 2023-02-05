import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:health/health.dart';
import 'package:flutter/material.dart';
import 'package:healthcareapp/widgets/bottom_navigation.dart';

class AddSleepPage extends StatelessWidget {
  final HealthFactory health;
  const AddSleepPage({super.key, required this.health});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [AddSleep(health: health), BottomNavigation()],
      ),
    );
  }
}

class AddSleep extends StatefulWidget {
  final HealthFactory health;
  AddSleep({super.key, required this.health});

  @override
  State<AddSleep> createState() => _AddSleepState();
}

class _AddSleepState extends State<AddSleep> {
  bool measurementStarted = false;
  DateTime sleepStartTime = DateTime.now();
  int currentIndex = 0;
  String result = "";
  double height = 0;
  double weight = 0;
  bool isAdded = false;
  int flag = 0;
  TextEditingController weightController = TextEditingController();
  TextEditingController heightController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Scaffold(
          appBar: AppBar(
            title: const Text(
              "Dodaj pomiar snu",
              style: TextStyle(color: Colors.black),
            ),
            elevation: 0.0,
            backgroundColor: Colors.white,
          ),
          body: SingleChildScrollView(
            child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Czas trwania snu: ",
                        style: TextStyle(fontSize: 18.0)),
                    SizedBox(height: 8.0),
                    Container(
                      width: double.infinity,
                      height: 50.0,
                      child: TextButton(
                        style: TextButton.styleFrom(
                          backgroundColor: Colors.blue,
                        ),
                        child: Text(
                            (!measurementStarted)
                                ? "Rozpocznij pomiar czasu trwania snu"
                                : "Zakończ pomiar czasu trwania snu",
                            style: TextStyle(color: Colors.white)),
                        onPressed: () {
                          if (!measurementStarted) {
                            measurementStarted = true;
                            sleepStartTime = DateTime.now();
                          } else {
                            measurementStarted = false;
                            addSleepMeasurement(sleepStartTime)
                                .then((bool result) {
                              setState(() {
                                isAdded = result;
                                if (isAdded == true) {
                                  showDialog(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                              title: Text(
                                                  "Dodano pomiar czasu trwania snu"),
                                              actions: [
                                                TextButton(
                                                  child: Text("OK"),
                                                  onPressed: () =>
                                                      Navigator.of(context)
                                                          .pushNamed("/sleep"),
                                                )
                                              ]));
                                } else {
                                  showDialog(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                              title: Text(
                                                  "Nie udało się dodać pomiaru"),
                                              actions: [
                                                TextButton(
                                                    child: Text("OK"),
                                                    onPressed: () =>
                                                        Navigator.pop(context))
                                              ]));
                                }
                              });
                            });
                          }
                        },
                      ),
                    ),
                    SizedBox(height: 20.0),
                  ],
                )),
          )),
    );
  }

  Future<bool> addSleepMeasurement(DateTime sleepStartTime) async {
    final types = [HealthDataType.SLEEP_IN_BED];
    final rights = [HealthDataAccess.WRITE];
    final permissions = [HealthDataAccess.READ_WRITE];

    bool? hasPermissions =
        await HealthFactory.hasPermissions(types, permissions: rights);
    if (hasPermissions == false) {
      await widget.health.requestAuthorization(types, permissions: permissions);
    }
    Duration sleepLength = sleepStartTime.difference(DateTime.now());
    double sleepLengthMinutes = sleepLength.inMinutes.toDouble();
    bool success = await widget.health.writeHealthData(sleepLengthMinutes,
        HealthDataType.SLEEP_IN_BED, sleepStartTime, DateTime.now());

    if (success == true)
      return true;
    else {
      return false;
    }
  }
}

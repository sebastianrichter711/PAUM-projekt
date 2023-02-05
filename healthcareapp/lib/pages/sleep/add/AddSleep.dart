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
  DateTime sleepStartDateTime = DateTime(2022, 12, 24, 5, 30);
  DateTime sleepEndDateTime = DateTime(2022, 12, 24, 5, 30);
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
    final sleepStartHours = sleepStartDateTime.hour.toString().padLeft(2, '0');
    final sleepStartMinutes =
        sleepStartDateTime.minute.toString().padLeft(2, '0');
    final sleepEndHours = sleepEndDateTime.hour.toString().padLeft(2, '0');
    final sleepEndMinutes = sleepEndDateTime.minute.toString().padLeft(2, '0');
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
                    Row(
                      children: [
                        Text("Początek snu: ",
                            style: TextStyle(fontSize: 18.0)),
                        SizedBox(width: 10.0),
                        Container(
                          width: 150.0,
                          height: 50.0,
                          child: ElevatedButton(
                            style: TextButton.styleFrom(
                              backgroundColor: Colors.blue,
                            ),
                            child: Text(
                                '${sleepStartDateTime.year}/${sleepStartDateTime.month}/${sleepStartDateTime.day}',
                                style: TextStyle(color: Colors.white)),
                            onPressed: () async {
                              final date = await pickDate();
                              if (date == null) {
                                return;
                              } else {
                                final newDateTime = DateTime(
                                    date.year,
                                    date.month,
                                    date.day,
                                    sleepStartDateTime.hour,
                                    sleepStartDateTime.minute);
                                setState(
                                    () => sleepStartDateTime = newDateTime);
                              }
                              // sleepStartTime = DateTime.now();
                              // addSleepMeasurement(sleepStartTime)
                              //     .then((bool result) {
                              //   setState(() {
                              //     isAdded = result;
                              //     if (isAdded == true) {
                              //       showDialog(
                              //           context: context,
                              //           builder: (context) => AlertDialog(
                              //                   title: Text(
                              //                       "Dodano pomiar czasu trwania snu"),
                              //                   actions: [
                              //                     TextButton(
                              //                       child: Text("OK"),
                              //                       onPressed: () =>
                              //                           Navigator.of(context)
                              //                               .pushNamed("/sleep"),
                              //                     )
                              //                   ]));
                              //     } else {
                              //       showDialog(
                              //           context: context,
                              //           builder: (context) => AlertDialog(
                              //                   title: Text(
                              //                       "Nie udało się dodać pomiaru"),
                              //                   actions: [
                              //                     TextButton(
                              //                         child: Text("OK"),
                              //                         onPressed: () =>
                              //                             Navigator.pop(context))
                              //                   ]));
                              //     }
                              //   });
                              // });
                            },
                          ),
                        ),
                        SizedBox(width: 10.0),
                        Container(
                          width: 100.0,
                          height: 50.0,
                          child: ElevatedButton(
                            style: TextButton.styleFrom(
                              backgroundColor: Colors.blue,
                            ),
                            child: Text('$sleepStartHours:$sleepStartMinutes',
                                style: TextStyle(color: Colors.white)),
                            onPressed: () async {
                              final time = await pickTime();
                              if (time == null) {
                                return;
                              } else {
                                final newDateTime = DateTime(
                                    sleepStartDateTime.year,
                                    sleepStartDateTime.month,
                                    sleepStartDateTime.day,
                                    time.hour,
                                    time.minute);
                                setState(
                                    () => sleepStartDateTime = newDateTime);
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20.0),
                    Row(
                      children: [
                        Text("Koniec snu: ", style: TextStyle(fontSize: 18.0)),
                        SizedBox(width: 10.0),
                        Container(
                          width: 150.0,
                          height: 50.0,
                          child: ElevatedButton(
                            style: TextButton.styleFrom(
                              backgroundColor: Colors.blue,
                            ),
                            child: Text(
                                '${sleepEndDateTime.year}/${sleepEndDateTime.month}/${sleepEndDateTime.day}',
                                style: TextStyle(color: Colors.white)),
                            onPressed: () async {
                              final date = await pickDate();
                              if (date == null) {
                                return;
                              } else {
                                final newDateTime = DateTime(
                                    date.year,
                                    date.month,
                                    date.day,
                                    sleepEndDateTime.hour,
                                    sleepEndDateTime.minute);
                                setState(() => sleepEndDateTime = newDateTime);
                              }
                              // sleepStartTime = DateTime.now();
                              // addSleepMeasurement(sleepStartTime)
                              //     .then((bool result) {
                              //   setState(() {
                              //     isAdded = result;
                              //     if (isAdded == true) {
                              //       showDialog(
                              //           context: context,
                              //           builder: (context) => AlertDialog(
                              //                   title: Text(
                              //                       "Dodano pomiar czasu trwania snu"),
                              //                   actions: [
                              //                     TextButton(
                              //                       child: Text("OK"),
                              //                       onPressed: () =>
                              //                           Navigator.of(context)
                              //                               .pushNamed("/sleep"),
                              //                     )
                              //                   ]));
                              //     } else {
                              //       showDialog(
                              //           context: context,
                              //           builder: (context) => AlertDialog(
                              //                   title: Text(
                              //                       "Nie udało się dodać pomiaru"),
                              //                   actions: [
                              //                     TextButton(
                              //                         child: Text("OK"),
                              //                         onPressed: () =>
                              //                             Navigator.pop(context))
                              //                   ]));
                              //     }
                              //   });
                              // });
                            },
                          ),
                        ),
                        SizedBox(width: 10.0),
                        Container(
                          width: 100.0,
                          height: 50.0,
                          child: ElevatedButton(
                            style: TextButton.styleFrom(
                              backgroundColor: Colors.blue,
                            ),
                            child: Text('$sleepEndHours:$sleepEndMinutes',
                                style: TextStyle(color: Colors.white)),
                            onPressed: () async {
                              final time = await pickTime();
                              if (time == null) {
                                return;
                              } else {
                                final newDateTime = DateTime(
                                    sleepEndDateTime.year,
                                    sleepEndDateTime.month,
                                    sleepEndDateTime.day,
                                    time.hour,
                                    time.minute);
                                setState(() => sleepEndDateTime = newDateTime);
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20.0),
                    Container(
                      width: 150.0,
                      height: 50.0,
                      child: TextButton(
                        style: TextButton.styleFrom(
                          backgroundColor: Colors.blue,
                        ),
                        child: Text("Dodaj pomiar",
                            style: TextStyle(color: Colors.white)),
                        onPressed: () {
                          addSleepMeasurement(
                                  sleepStartDateTime, sleepEndDateTime)
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
                        },
                      ),
                    ),
                  ],
                )),
          )),
    );
  }

  Future<DateTime?> pickDate() => showDatePicker(
      context: context,
      initialDate: sleepStartDateTime,
      firstDate: DateTime(1900),
      lastDate: DateTime(2100));

  Future<TimeOfDay?> pickTime() => showTimePicker(
      context: context,
      initialTime: TimeOfDay(
          hour: sleepStartDateTime.hour, minute: sleepStartDateTime.minute));

  Future<bool> addSleepMeasurement(
      DateTime sleepStartDateTime, DateTime sleepEndDateTime) async {
    Duration sleepLength = sleepEndDateTime.difference(sleepStartDateTime);
    double sleepLengthMinutes = sleepLength.inMinutes.toDouble();
    if (sleepLengthMinutes <= 0 || sleepLengthMinutes >= 1440) {
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                  title: Text(
                      "Nieprawidłowy czas snu. Sen nie może trwać mniej niż minutę ani więcej niż dobę"),
                  actions: [
                    TextButton(
                        child: Text("OK"),
                        onPressed: () => Navigator.pop(context))
                  ]));
      return false;
    }

    final types = [HealthDataType.SLEEP_IN_BED];
    final rights = [HealthDataAccess.WRITE];
    final permissions = [HealthDataAccess.READ_WRITE];

    bool? hasPermissions =
        await HealthFactory.hasPermissions(types, permissions: rights);
    if (hasPermissions == false) {
      await widget.health.requestAuthorization(types, permissions: permissions);
    }
    bool success = await widget.health.writeHealthData(sleepLengthMinutes,
        HealthDataType.SLEEP_IN_BED, sleepStartDateTime, sleepEndDateTime);

    if (success == true)
      return true;
    else {
      return false;
    }
  }
}

import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:health/health.dart';
import 'package:flutter/material.dart';
import 'package:healthcareapp/widgets/bottom_navigation.dart';

class AddBloodGlucosePage extends StatelessWidget {
  final HealthFactory health;
  const AddBloodGlucosePage({super.key, required this.health});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [AddBloodGlucose(health: health), BottomNavigation()],
      ),
    );
  }
}

class AddBloodGlucose extends StatefulWidget {
  final HealthFactory health;
  AddBloodGlucose({super.key, required this.health});

  @override
  State<AddBloodGlucose> createState() => _AddBloodGlucoseState();
}

class _AddBloodGlucoseState extends State<AddBloodGlucose> {
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
              "Dodaj pomiar poziomu glukozy ",
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
                    Text("Poziom glukozy we krwi [mg/dl]: ",
                        style: TextStyle(fontSize: 18.0)),
                    SizedBox(height: 8.0),
                    TextField(
                        keyboardType: TextInputType.number,
                        controller: heightController,
                        textAlign: TextAlign.center,
                        decoration: InputDecoration(
                            hintText: "Podaj wartość:",
                            filled: true,
                            fillColor: Colors.grey[200],
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0),
                                borderSide: BorderSide.none))),
                    SizedBox(height: 15),
                    Container(
                      width: double.infinity,
                      height: 50.0,
                      child: TextButton(
                        style: TextButton.styleFrom(
                          backgroundColor: Colors.blue,
                        ),
                        child: Text("Dodaj",
                            style: TextStyle(color: Colors.white)),
                        onPressed: () {
                          setState(() {
                            height = double.parse(heightController.value.text);
                          });
                          addBloodGlucoseMeasurement(height)
                              .then((bool result) {
                            setState(() {
                              isAdded = result;
                              if (isAdded == true) {
                                showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                            title: Text(
                                                "Dodano pomiar poziomu glukozy we krwi"),
                                            actions: [
                                              TextButton(
                                                child: Text("OK"),
                                                onPressed: () =>
                                                    Navigator.of(context)
                                                        .pushReplacementNamed(
                                                            "/blood-glucose"),
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
                    SizedBox(height: 20.0)
                  ],
                )),
          )),
    );
  }

  Future<bool> addBloodGlucoseMeasurement(double height) async {
    bool success = await widget.health.writeHealthData(
        height, HealthDataType.BLOOD_GLUCOSE, DateTime.now(), DateTime.now());

    if (success == true)
      return true;
    else
      return false;
  }
}

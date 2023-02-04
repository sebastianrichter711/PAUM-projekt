import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:health/health.dart';
import 'package:flutter/material.dart';
import 'package:healthcareapp/widgets/bottom_navigation.dart';

class AddPulsePage extends StatelessWidget {
  final HealthFactory health;
  const AddPulsePage({super.key, required this.health});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [AddPulse(health: health), BottomNavigation()],
      ),
    );
  }
}

class AddPulse extends StatefulWidget {
  final HealthFactory health;
  AddPulse({super.key, required this.health});

  @override
  State<AddPulse> createState() => _AddPulseState();
}

class _AddPulseState extends State<AddPulse> {
  int currentIndex = 0;
  String result = "";
  double height = 0;
  double weight = 0;
  TextEditingController weightController = TextEditingController();
  TextEditingController heightController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Scaffold(
          appBar: AppBar(
            title: const Text(
              "Dodaj wartość pulsu",
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
                    Text("Puls [bpm]: ", style: TextStyle(fontSize: 18.0)),
                    SizedBox(height: 8.0),
                    TextField(
                        keyboardType: TextInputType.number,
                        controller: heightController,
                        textAlign: TextAlign.center,
                        decoration: InputDecoration(
                            hintText: "Podaj wartość pulsu",
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
                        child: Text("Oblicz",
                            style: TextStyle(color: Colors.white)),
                        onPressed: () {
                          setState(() {
                            height = double.parse(heightController.value.text);
                          });
                          addPulseMeasurement(height);
                        },
                      ),
                    ),
                    SizedBox(height: 20.0),
                    Container(
                      width: double.infinity,
                      child: Text("Twoje BMI wynosi: ",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 24.0,
                            fontWeight: FontWeight.bold,
                          )),
                    ),
                    SizedBox(height: 20.0),
                    Container(
                      width: double.infinity,
                      child: Text("$result",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 40.0,
                            fontWeight: FontWeight.bold,
                          )),
                    ),
                  ],
                )),
          )),
    );
  }

  Future<void> addPulseMeasurement(double height) async {
    final types = [HealthDataType.HEART_RATE];
    final rights = [HealthDataAccess.WRITE];
    final permissions = [HealthDataAccess.READ_WRITE];

    bool? hasPermissions =
        await HealthFactory.hasPermissions(types, permissions: rights);
    if (hasPermissions == false) {
      await widget.health.requestAuthorization(types, permissions: permissions);

      bool success = await widget.health.writeHealthData(
          height, HealthDataType.HEART_RATE, DateTime.now(), DateTime.now());

      if (success == true)
        print("added pulse");
      else {
        print("not added pulse");
      }
    }
  }
}

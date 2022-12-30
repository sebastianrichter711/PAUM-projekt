import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

enum Gender{
  male,
  female,
}

class BmiPage extends StatelessWidget {
  const BmiPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class BmiCalculator extends StatefulWidget {
  const BmiCalculator({super.key});

  @override
  State<BmiCalculator> createState() => _BmiCalculatorState();
}

class _BmiCalculatorState extends State<BmiCalculator> {
  Color inactiveColor= Color(0xFF24232F);
  Color activeColor=Colors.blueGrey;
  int height=180;
  int weight=30;
  int age=15;
  Gender selectedGender = Gender.male;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            "BMI"
          ),
        ),
      ),
      body:Column(
        children: [
          Row(
            children: [
              GestureDetector(
                onTap:(){
                  setState(() {
                    selectedGender=Gender.male;
                  });

                },
                child: Container(
                  decoration: BoxDecoration(
                    color: selectedGender==Gender.male?activeColor:inactiveColor
                  ),
                  child: Column(
                    children: [
                      Icon(
                        FontAwesomeIcons.male,
                        color:Colors.white,
                        size: 45.0
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      Text("male",
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 20.0,
                        fontWeight: FontWeight.w500,
                      ),
                      ),

                    ],
                    )
                ),
              ),
              GestureDetector(
                onTap:(){
                  setState(() {
                    selectedGender=Gender.female;
                  });

                },
                child: Container(
                  decoration: BoxDecoration(
                    color: selectedGender==Gender.female?activeColor:inactiveColor
                  ),
                  child: Column(
                    children: [
                      Icon(
                        FontAwesomeIcons.female,
                        color:Colors.white,
                        size: 45.0
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      Text("female",
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 20.0,
                        fontWeight: FontWeight.w500,
                      ),
                      ),

                    ],
                    )
                ),
              ),
            ]
          ),
          SizedBox(
            height: 10.0,
          ),
          Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text("HEIGHT",
                style: TextStyle(
                  fontSize: 16.0,
                  color:Colors.white,
                ),
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  mainAxisAlignment: MainAxisAlignment.center,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Text(
                      height.toString(),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 35.0,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      "cm",
                      style: TextStyle(
                        fontSize: 18.0,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                SliderTheme(data: SliderTheme.of(context).copyWith(
                  activeTrackColor: Colors.white,
                  overlayColor: Color(0x291DE986),
                  inactiveTrackColor: Colors.grey,
                  thumbShape: RoundSliderThumbShape(
                    enabledThumbRadius:16.0
                  ),
                  overlayShape: RoundSliderOverlayShape(overlayRadius: 30.0),
                  thumbColor: Color(0xFF1DE986),
                ), 
                child: Slider(
                  value: height.toDouble(),
                  min: 100.0,
                  max: 250.0,
                  onChanged: (double v){
                    setState(() {
                      height=v.round();
                    });
                  }
                ))
              ],
            )
          ),
          Row(
            children: [
              Container(
                child:Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Weight"
                    ),
                    SizedBox(
                      height: 8.0,
                    ),
                    Text(
                      weight.toString(),
                      style: TextStyle(color:Colors.white, fontWeight: FontWeight.bold),

                    ),
                    SizedBox(
                      height: 8.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          backgroundColor: Colors.blueGrey,
                          child: IconButton(
                            icon: Icon(
                              Icons.add,
                              color:Colors.white,
                          ),
                          onPressed: (){
                            setState(() {
                              weight++;
                            });
                          },
                          )

                        ),
                        SizedBox(
                          width: 10.0,
                        ),
                        CircleAvatar(
                            backgroundColor: Colors.blueGrey,
                            child: IconButton(
                                icon: Icon(
                                  Icons.remove,
                                  color:Colors.white,
                              ),
                              onPressed: (){
                                setState(() {
                                  if(weight>10){
                                  weight--;
                                }
                                });
                              },
                              )
                            ),
                      ],
                    )
                  ],
                  )
              )
            ],)
        ],
        )
    );
  }
}
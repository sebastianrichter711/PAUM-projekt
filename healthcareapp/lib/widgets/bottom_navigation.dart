import 'package:flutter/material.dart';

class BottomNavigation extends StatelessWidget {
  const BottomNavigation({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.infinity,
        height: 60,
        color: const Color(0xfff8f8f8),
        child: IconTheme(
          data: const IconThemeData(color: Color(0xffabadb4)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              GestureDetector(
                  onTap: () {
                    Navigator.of(context).pushNamed('/activity-page');
                  },
                  child: const Icon(Icons.analytics)),
              GestureDetector(
                  onTap: () {
                    Navigator.of(context).pushNamed('/life-params');
                  },
                  child: const Icon(Icons.health_and_safety)),
              Transform.translate(
                offset: const Offset(0, -15),
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).pushReplacementNamed('/details');
                  },
                  child: Container(
                      padding: const EdgeInsets.all(13),
                      decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              colors: [Color(0xff92e2ff), Color(0xff1ebdf8)]),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.black12,
                                offset: Offset(3, 3),
                                blurRadius: 3)
                          ]),
                      child: const Icon(Icons.home, color: Colors.white)),
                ),
              ),
              GestureDetector(
                  onTap: () {
                    Navigator.of(context).pushNamed('/sleep');
                  },
                  child: const Icon(Icons.bedtime)),
              GestureDetector(
                  onTap: () {
                    Navigator.of(context).pushNamed('/bmi');
                  },
                  child: const Icon(Icons.settings)),
            ],
          ),
        ));
  }
}

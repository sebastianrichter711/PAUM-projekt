import 'package:flutter/material.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:healthcareapp/widgets/bottom_navigation.dart';

class ActivityPage extends StatelessWidget {
  const ActivityPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: const [ActivityMenu(), BottomNavigation()],
      ),
    );
  }
}

class ActivityMenu extends StatelessWidget {
  const ActivityMenu({super.key});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width - 80;
    return Expanded(
        child: Center(
            child: Padding(
      padding: const EdgeInsets.fromLTRB(0, 40, 0, 20),
      child:
          Column(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
        Column(children: [
          Text(
            'Aktywność',
            style: TextStyle(
              fontFamily: 'Manrope',
              fontWeight: FontWeight.bold,
              fontSize: 42,
              decoration: TextDecoration.none,
            ),
          ),
        ]),
        Wrap(
          runSpacing: 16,
          children: [
            modeButton('Kroki', 'Kroki', FontAwesomeIcons.shoePrints,
                Color(0xFFFE7F00), width),
            modeButton('Kalorie', 'Kalorie', FontAwesomeIcons.bolt,
                Color(0xFFFE7F00), width),
            modeButton('Dystans', 'Dystans', FontAwesomeIcons.personWalking,
                Color(0xFFFE7F00), width),
          ],
        )
      ]),
    )));
  }

  Padding circButton(IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: RawMaterialButton(
          onPressed: () {},
          fillColor: Colors.white,
          shape: CircleBorder(),
          constraints: BoxConstraints(minHeight: 35, minWidth: 35),
          child: FaIcon(icon, size: 22, color: Color(0xFF2F3041))),
    );
  }

  GestureDetector modeButton(
      String title, String subtitle, IconData icon, Color color, double width) {
    return GestureDetector(
        child: Container(
            width: width,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.all(Radius.circular(16)),
            ),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 22.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(title,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.none,
                              fontFamily: 'Manrope',
                              color: Colors.white,
                              fontSize: 24,
                            )),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30, vertical: 18),
                    child: FaIcon(icon, size: 35, color: Colors.white),
                  )
                ])));
  }
}

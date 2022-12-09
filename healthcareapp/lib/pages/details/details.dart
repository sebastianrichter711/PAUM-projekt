import 'package:flutter/material.dart';
import 'package:healthcareapp/pages/details/widgets/appbar.dart';
import 'package:healthcareapp/pages/details/widgets/dates.dart';
import 'package:healthcareapp/pages/details/widgets/graph.dart';
import 'package:healthcareapp/pages/details/widgets/info.dart';
import 'package:healthcareapp/pages/details/widgets/stats.dart';
import 'package:healthcareapp/pages/details/widgets/steps.dart';
import 'package:healthcareapp/widgets/bottom_navigation.dart';

class DetailsPage extends StatelessWidget {
  const DetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MainAppBar(appBar:AppBar()),
      body:Column(
        children: [
          Dates(),
          Steps(),
          Graph(),
          Info(),
          Stats(),
          BottomNavigation(),
        ],
      ),
    );
  }
}


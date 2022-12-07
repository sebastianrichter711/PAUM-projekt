import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:healthcareapp/pages/details/details.dart';
import 'package:healthcareapp/pages/home/home.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Health Care App",
      theme: ThemeData(
        fontFamily:'Roboto',
        textTheme: TextTheme(
          headline1: TextStyle(
            fontSize: 14,
            color: Colors.black,
            fontWeight: FontWeight.w900,
          ),
          ),
      ),
      debugShowCheckedModeBanner: false,
      routes: {
        '/': (context) => HomePage(),
        '/details': (context) => DetailsPage(),
      },
      initialRoute: '/',
    );
  }
}
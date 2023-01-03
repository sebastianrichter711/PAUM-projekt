
import 'package:flutter/material.dart';

class Info extends StatelessWidget {
  const Info({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: const [
        Stats(value: '345', unit: 'kcal', label: 'Kalorie'),
        Stats(value: '3.6', unit: 'km', label: 'Odległość'),
        Stats(value: '1.5', unit: 'h', label: 'Czas'),

      ],
    );
  }
}

class Stats extends StatelessWidget {

  final String value;
  final String unit;
  final String label;

  const Stats({super.key, required this.value, required this.unit, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text.rich(
          TextSpan(text: value,
          style: const TextStyle(
            fontSize:20, fontWeight: FontWeight.w900
            ),
          children: [
            const TextSpan(text: ' '),
            TextSpan(text: unit, 
            style: const TextStyle(
              fontSize:10,
              fontWeight: FontWeight.w500,
              )
              )
          ]
          ),
        ),
        const SizedBox(height:6),
        Text(label, style: const TextStyle(fontSize:10, fontWeight: FontWeight.w500)),
      ],
    );
  }
}
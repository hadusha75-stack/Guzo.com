// ignore_for_file: file_names

import 'package:flutter/material.dart';

class Active extends StatefulWidget {
  const Active({super.key});

  @override
  State<Active> createState() => _ActiveState();
}

class _ActiveState extends State<Active> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(30.0),
              child: Image.asset('assets/image_2.png', width: 200, height: 150),
            ),
            Text(
              'Where to next ?',
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
            ),
            Text(
              "\n You haven't started a trip yet. Once you make a \n                    booking, it'll appear here.",
            ),
          ],
        ),
      ],
    );
  }
}

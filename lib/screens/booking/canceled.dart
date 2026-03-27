import 'package:flutter/material.dart';

class Canceled extends StatefulWidget {
  const Canceled({super.key});

  @override
  State<Canceled> createState() => _CanceledState();
}

class _CanceledState extends State<Canceled> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(30.0),
              child: Image.asset('assets/image_4.png', width: 200, height: 150),
            ),
            Text(
              'Change of Plan ?',
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
            ),
            Text("\n Here you can refer to all canceled trips."),
          ],
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';

class Past extends StatefulWidget {
  const Past({super.key});

  @override
  State<Past> createState() => _PastState();
}

class _PastState extends State<Past> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(30.0),
              child: Image.asset('assets/image_3.png', width: 200, height: 150),
            ),
            Text(
              'Revisit Past Trips',
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
            ),
            Text(
              "\n Here you can refer to all past trips and get\n         inspiration for your upcoming tips.",
            ),
          ],
        ),
      ],
    );
  }
}

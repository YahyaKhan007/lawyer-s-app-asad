// ignore_for_file: file_names

import 'package:flutter/material.dart';

class NewScreen extends StatelessWidget {
  const NewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.blue,
      body: ListView(children: [
        const SizedBox(
          height: 120,
        ),
        Row(
          children: [
            Container(
              height: size.height,
              width: size.width * 0.44,
              decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(200),
                      topLeft: Radius.circular(20)),
                  color: Colors.white),
            ),
            SizedBox(
              height: size.height,
              width: size.width * 00.12,
              child: Column(children: [
                const SizedBox(
                  height: 60,
                ),
                Container(
                  color: Colors.white,
                  height: size.height,
                )
              ]),
            ),
            Container(
              height: size.height,
              width: size.width * 0.44,
              decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(200),
                      topRight: Radius.circular(20)),
                  color: Colors.white),
            ),
          ],
        )
      ]),
    );
  }
}

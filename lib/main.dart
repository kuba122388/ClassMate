import 'dart:ffi';

import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  Widget buildContainer(String text, BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.all(15),
      width: screenWidth * 0.55,
      decoration: BoxDecoration(
        color: const Color.fromRGBO(49, 62, 80, 1.0),
        borderRadius: BorderRadius.circular(40),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontFamily: 'Asap',
          fontSize: 18,
          letterSpacing: 0.5,
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Color.fromRGBO(71, 82, 98, 1.0),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              buildContainer('LOGOWANIE', context),
              SizedBox(height: screenHeight * 0.05),
              buildContainer('REJESTRACJA', context)
            ],
          ),
        )
      ),
    );
  }
}

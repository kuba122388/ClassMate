import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../consts/consts.dart';

class ShedulePage extends StatefulWidget {
  const ShedulePage({super.key});

  @override
  State<ShedulePage> createState() => _ShedulePageState();
}

class _ShedulePageState extends State<ShedulePage> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: COLOR_BACKGROUND,
        appBar: BuildTopNav(context),
        body: BuildBody(context),
        bottomNavigationBar: BuildBackButton(context));
  }

  Center BuildBody(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Center(

    );
  }



  PreferredSizeWidget BuildTopNav(BuildContext context) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(kToolbarHeight),
      child: Container(
        padding: const EdgeInsets.only(top: 10, bottom: 10),
        decoration: const BoxDecoration(
            color: COLOR_BACKGROUND_DARKER,
            borderRadius: BorderRadius.vertical(
              bottom: BORDER_RADIUS,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.white,
                offset: Offset(0, 2.0),
                blurRadius: 4.0,
              )
            ]),
        child: Center(
          child: Text(
            'Plan dnia',
            textAlign: TextAlign.center,
            style: TextStyle(
            color: Colors.white,
            fontSize: 30,
            fontWeight: FontWeight.bold,
            fontFamily: 'Asap',
          ),
          ),
      ),
      ),
    );
  }

  BottomAppBar BuildBackButton(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return BottomAppBar(
      color: Colors.transparent,
      padding: EdgeInsets.zero,
      child: Container(
        decoration: const BoxDecoration(
            color: COLOR_BACKGROUND_DARKER,
            borderRadius: BorderRadius.vertical(top: BORDER_RADIUS)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: Image.asset('././images/back_icon.png',
                  height: screenHeight * 0.06),
            )
          ],
        ),
      ),
    );

  }
}

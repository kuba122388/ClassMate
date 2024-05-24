import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../consts/consts.dart';

class SalesPage extends StatefulWidget {
  const SalesPage({super.key});

  @override
  State<SalesPage> createState() => _SalesPageState();
}

class _SalesPageState extends State<SalesPage> {


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
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeigh = MediaQuery.of(context).size.height;
    double imageSpacing = screenHeigh * 0.05;

    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: screenWidth * 0.9,
            margin: EdgeInsets.only( top: imageSpacing),
            child: Image.asset(
              './images/Sales_MaxBurger.png',
              fit: BoxFit.contain,
            ),
          ),
          Container(
            width: screenWidth * 0.9,
            margin: EdgeInsets.only( top: imageSpacing),
            child: Image.asset(
              './images/Sales_Python.png',
              fit: BoxFit.contain,
            ),
          ),
          Container(
            width: screenWidth * 0.9,
            margin: EdgeInsets.only( top: imageSpacing),
            child: Image.asset(
              './images/Sales_Indeks.png',
              fit: BoxFit.contain,
            ),
          ),
        ],
      ),
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
        child: const Center(
          child: Text(
            'Promocje',
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

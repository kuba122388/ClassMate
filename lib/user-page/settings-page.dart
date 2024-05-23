import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../consts/consts.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {

  void _navigateToSettings(BuildContext context) {
    // Nawigacja do reszty ustawień
    // Navigator.push(context, MaterialPageRoute(builder: (context) => RestOfSettingsPage()));
  }

  void _logout(BuildContext context) {
    FirebaseAuth.instance.signOut();
    Navigator.of(context).popUntil((route) => route.isFirst);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: COLOR_BACKGROUND,
      appBar: BuildTopNav(context),
      body: BuildBody(context),
      bottomNavigationBar: BuildBackButton(context),
    );
  }

  Center BuildBody(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          SizedBox(height: screenHeight * 0.2),
          BuildNavButton('Reszta ustawień', context, _navigateToSettings),
          SizedBox(height: screenHeight * 0.05),
          BuildNavButton('Wyloguj', context, _logout),
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
          ],
        ),
        child: Center(
          child: Text(
            'Ustawienia',
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
          borderRadius: BorderRadius.vertical(top: BORDER_RADIUS),
        ),
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

  Widget BuildNavButton(String text, BuildContext context, Function(BuildContext) onPressed) {
    final screenWidth = MediaQuery.of(context).size.width;

    return ElevatedButton(
      onPressed: () {
        onPressed(context);
      },
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(Colors.transparent), // Ustawienie przezroczystego tła przycisku
        padding: MaterialStateProperty.all<EdgeInsetsGeometry>(EdgeInsets.zero), // Ustawienie paddingu przycisku na zero
        tapTargetSize: MaterialTapTargetSize.shrinkWrap, // Zwinięcie przycisku, aby dopasować się do jego zawartości
      ),
      child: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.all(15),
        width: screenWidth * 0.55,
        decoration: BoxDecoration(
          color: COLOR_BACKGROUND_DARKER,
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
      ),
    );
  }
}
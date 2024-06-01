import 'package:flutter/material.dart';
import '../consts/consts.dart';
import '../login-page/login-page.dart';

class RegisterApproved extends StatefulWidget {
  const RegisterApproved({super.key});

  @override
  State<RegisterApproved> createState() => _RegisterApprovedState();
}

class _RegisterApprovedState extends State<RegisterApproved> {
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
        backgroundColor: COLOR_BACKGROUND,
        appBar: PreferredSize(
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
            child: Image.asset('././images/register_logo.png'),
          ),
        ),
        body: Center(
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.only(
                    top: screenHeight * 0.05, bottom: screenHeight * 0.03),
                child: Text(
                  "CLASSMATE",
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'Croissant One',
                    fontSize: screenWidth * 0.09,
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.only(top: screenHeight * 0.05, bottom: screenHeight * 0.02),
                child: Image.asset('././images/approved_icon.png',
                    width: screenWidth * 0.4),
              ),
              Container(
                padding: EdgeInsets.only(bottom: screenHeight * 0.03),
                width: screenWidth * 0.66,
                child: const Text(
                  'Konto zostało pomyślnie utworzone!',
                  style: TextStyle(
                    fontFamily: 'Architects Daughter',
                    color: Colors.white,
                    fontSize: 24,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              BuildNavButton('ZALOGUJ', context),
            ],
          ),
        ),
        bottomNavigationBar: BuildBackButton(context));
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
                Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
              },
              icon: Image.asset('././images/back_icon.png',
                  height: screenHeight * 0.06),
            )
          ],
        ),
      ),
    );
  }

  Widget BuildNavButton(String text, BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return ElevatedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const LoginPage()),
          );
        },
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(Colors.transparent), // Ustawienie przezroczystego tła przycisku
          padding: MaterialStateProperty.all<EdgeInsetsGeometry>(EdgeInsets.zero), // Ustawienie paddingu przycisku na zero
          tapTargetSize: MaterialTapTargetSize.shrinkWrap, // Zwinięcie przycisku, aby dopasować się do jego zawartości
        ),
        child: Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(vertical: 10),
          width: screenWidth * 0.55,
          decoration: BoxDecoration(
            color: COLOR_BACKGROUND_DARKER,
            borderRadius: BorderRadius.circular(40),
          ),
          child: Text(
            text,
            style: const TextStyle(
              fontFamily: 'Asap',
              fontSize: 22,
              letterSpacing: 0.5,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        )
    );
  }
}

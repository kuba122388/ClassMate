import 'package:classmate/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'consts/consts.dart';
import 'register-page/register-page.dart';
import 'login-page/login-page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
          '/home': (context) => const MyHome(),
          '/login': (context) => const LoginPage(),
          '/registerpage' : (context) => const RegisterPage(),
        },
        home: const MyHome(),
      debugShowCheckedModeBanner: false,
    );
  }
}

void _navigateTo(BuildContext context, String text) {

  if(text == 'LOGOWANIE') {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()),
    );
  }

  if(text=='REJESTRACJA') {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const RegisterPage()),
    );
  }
}

class MyHome extends StatelessWidget {
  const MyHome({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
          backgroundColor: COLOR_BACKGROUND,
          body: Center(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Container(
                  padding: EdgeInsets.only(
                    top: screenHeight*0.2,
                    bottom: screenHeight*0.05,
                  ),
                  child: Image.asset(
                    './images/logo.png',
                    width: screenWidth*0.8,
                  ),
                ),

                BuildNavButton('LOGOWANIE', context),
                SizedBox(height: screenHeight * 0.05),
                BuildNavButton('REJESTRACJA', context),
              ],
            ),
          )
      );
  }

  Widget BuildNavButton(String text, BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return ElevatedButton(
        onPressed: () {
          _navigateTo(context, text);
        },
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.all<Color>(Colors.transparent), // Ustawienie przezroczystego tła przycisku
          padding: WidgetStateProperty.all<EdgeInsetsGeometry>(EdgeInsets.zero), // Ustawienie paddingu przycisku na zero
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
        )
    );
  }
}

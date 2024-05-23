import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../consts/consts.dart';
import 'schedule-page.dart';
import 'sales-page.dart';
import 'announcements-page.dart';
import 'settings-page.dart';

class MainUserPage extends StatefulWidget {
  const MainUserPage({super.key});

  @override
  State<MainUserPage> createState() => _MainUserPageState();
}

class _MainUserPageState extends State<MainUserPage> {


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
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.only(top: 15.0),
            child: Image.asset('././images/logo.png'),
            width: screenWidth*0.6,
          ),
          const Divider(
            color: Colors.white, // Kolor biały
            thickness: 4, // Grubość linii
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SizedBox(width: screenWidth*0.14),
              const Text(
                'TO DO:',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              IconButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon: Image.asset(
                  '././images/plus.png',
                  height: screenHeight * 0.06,
                  width: screenWidth * 0.06, 
                ),
              ),
            ],
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
        // child: Image.asset('././images/person_icon.png'),
        child: Row(
          children: [
            Container(
              width: MediaQuery.of(context).size.width/2,
              // padding: const EdgeInsets.only(top: 10, bottom: 10),
              child: const Column(
            children: [
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(top: 8.0),
                  child: Text(
                      '16.05.2024',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      )
                  ),
                ),
              ),
              Expanded(
                child: Text(
                    'Czwartek',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    )
                ),
              ),
            ],
        ),
              // alignment: Alignment.centerLeft,

            ),
            Container(
              width: MediaQuery.of(context).size.width/2,
              padding: const EdgeInsets.only(top: 3, bottom: 3, right:40),
              alignment: Alignment.centerRight,
              child: IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SettingsPage()),
                  );
                },
                icon: Image.asset('././images/settings.png'),
            ),
            ),
          ],
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
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ShedulePage()));
              },
              icon: Image.asset('././images/calendar.png',
                  height: screenHeight * 0.06),
            ),
            IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AnnouncementsPage()));
              },
              icon: Image.asset('././images/announcements.png',
                  height: screenHeight * 0.06),
            ),
            IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SalesPage()));
              },
              icon: Image.asset('././images/sale.png',
                  height: screenHeight * 0.06),
            )
          ],
        ),
      ),
    );
  }
}

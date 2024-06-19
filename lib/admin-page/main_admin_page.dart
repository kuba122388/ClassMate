import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import '../consts/consts.dart';
import '../database-features/DatabaseFeatures.dart';
import 'sales-page.dart';
import 'announcements-page.dart';
import 'settings-page.dart';
import 'users-page.dart';

class MainAdminPage extends StatefulWidget {
  final String email;

  const MainAdminPage({super.key, required this.email});

  @override
  State<MainAdminPage> createState() => _MainAdminPageState();
}

class _MainAdminPageState extends State<MainAdminPage> {
  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    DatabaseUser? retrievedUser;
    String email = widget.email;
    DatabaseUser? user = await getUserData(email);
    setState(() {
      retrievedUser = user;
    });
    if (retrievedUser != null) {
      print(
          'Pobrano dane użytkownika: ${retrievedUser?.firstName} ${retrievedUser?.lastName}');
    }
  }

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

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: screenWidth * 0.8,
                child: Image.asset('././images/logo.png'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  PreferredSizeWidget BuildTopNav(BuildContext context) {
    final AssetSource assetSource = AssetSource('../sounds/click.mp3');
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
              width: MediaQuery.of(context).size.width / 2,
              // padding: const EdgeInsets.only(top: 10, bottom: 10),
              child: const Column(
                children: [
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(top: 8.0),
                      child: Text('16.05.2024',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          )),
                    ),
                  ),
                  Expanded(
                    child: Text('Czwartek',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        )),
                  ),
                ],
              ),
              // alignment: Alignment.centerLeft,
            ),
            Container(
              width: MediaQuery.of(context).size.width / 2,
              padding: const EdgeInsets.only(top: 3, bottom: 3, right: 40),
              alignment: Alignment.centerRight,
              child: IconButton(
                onPressed: () {
                  AudioPlayer().play(assetSource).then((_) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SettingsPage()),
                    );
                  });
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
    final AssetSource assetSource = AssetSource('../sounds/click.mp3');

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
                AudioPlayer().play(assetSource).then((_) {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => UsersPage()));
                });
              },
              icon: Image.asset('././images/user.png',
                  height: screenHeight * 0.06),
            ),
            IconButton(
              onPressed: () {
                AudioPlayer().play(assetSource).then((_) {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => AnnouncementsPage()));
                });
              },
              icon: Image.asset('././images/announcements.png',
                  height: screenHeight * 0.06),
            ),
            IconButton(
              onPressed: () {
                AudioPlayer().play(assetSource).then((_) {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => SalesPage()));
                });
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

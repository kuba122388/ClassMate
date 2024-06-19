import 'package:audioplayers/audioplayers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../consts/consts.dart';

class SettingsPage extends StatefulWidget {
  final String email;

  const SettingsPage({Key? key, required this.email}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  Map<String, dynamic>? _userData;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;
    try {
      QuerySnapshot snapshot = await _firestore
          .collection('users')
          .where('email', isEqualTo: widget.email)
          .get();

      if (snapshot.docs.isNotEmpty) {
        setState(() {
          _userData = snapshot.docs.first.data() as Map<String, dynamic>;
        });
      } else {
        setState(() {
          _userData = {};
        });
      }
    } catch (e) {
      print("Error fetching user data: $e");
      setState(() {
        _userData = {};
      });
    }
  }

  String _formatDate(dynamic date) {
    if (date is Timestamp) {
      DateTime dateTime = date.toDate();
      return DateFormat('yyyy-MM-dd').format(dateTime);
    } else if (date is String) {
      DateTime dateTime = DateTime.parse(date);
      return DateFormat('yyyy-MM-dd').format(dateTime);
    } else {
      return 'Invalid date';
    }
  }

  void _logout(BuildContext context) {
    FirebaseAuth.instance.signOut();
    Navigator.of(context).popUntil((route) => route.isFirst);
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
            ),
          ],
        ),
        child: const Center(
          child: Text(
            'USTAWIENIA',
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
              icon: Image.asset(
                '././images/back_icon.png',
                height: screenHeight * 0.06,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: COLOR_BACKGROUND,
      appBar: BuildTopNav(context),
      body: _userData != null
          ? Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 60),
                  Container(
                    width: screenWidth * 0.9,
                    padding: const EdgeInsets.all(20.0),
                    decoration: BoxDecoration(
                      color: const Color(0xFF313E50),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 10.0,
                          offset: Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text.rich(
                          TextSpan(
                            children: [
                              const TextSpan(
                                text: 'Email: ',
                                style: TextStyle(
                                  color: Color(0xFFF6FFF8),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                              TextSpan(
                                text: _userData!['email'],
                                style: const TextStyle(
                                  color: Color(0xFFF6FFF8),
                                  fontSize: 18,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text.rich(
                          TextSpan(
                            children: [
                              const TextSpan(
                                text: 'Imię: ',
                                style: TextStyle(
                                  color: Color(0xFFF6FFF8),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                              TextSpan(
                                text: _userData!['firstName'],
                                style: const TextStyle(
                                  color: Color(0xFFF6FFF8),
                                  fontSize: 18,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text.rich(
                          TextSpan(
                            children: [
                              const TextSpan(
                                text: 'Nazwisko: ',
                                style: TextStyle(
                                  color: Color(0xFFF6FFF8),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                              TextSpan(
                                text: _userData!['lastName'],
                                style: const TextStyle(
                                  color: Color(0xFFF6FFF8),
                                  fontSize: 18,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text.rich(
                          TextSpan(
                            children: [
                              const TextSpan(
                                text: 'Data urodzenia: ',
                                style: TextStyle(
                                  color: Color(0xFFF6FFF8),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                              TextSpan(
                                text: _formatDate(_userData!['dateOfBirth']),
                                style: const TextStyle(
                                  color: Color(0xFFF6FFF8),
                                  fontSize: 18,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text.rich(
                          TextSpan(
                            children: [
                              const TextSpan(
                                text: 'Uczelnia: ',
                                style: TextStyle(
                                  color: Color(0xFFF6FFF8),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                              TextSpan(
                                text: _userData!['university'],
                                style: const TextStyle(
                                  color: Color(0xFFF6FFF8),
                                  fontSize: 18,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30), // Zwiększony odstęp
                  SizedBox(height: screenHeight * 0.05),
                  BuildNavButton('Wyloguj', context, _logout),
                ],
              ),
            )
          : const Center(child: CircularProgressIndicator()),
      bottomNavigationBar: BuildBackButton(context),
    );
  }

  Widget BuildNavButton(
      String text, BuildContext context, Function(BuildContext) onPressed) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final AssetSource assetSource = AssetSource('../sounds/approved.mp3');

    return ElevatedButton(
      onPressed: () async {
        await Future.delayed(const Duration(milliseconds: 150));
        AudioPlayer().play(assetSource);
        await Future.delayed(const Duration(milliseconds: 300));
        onPressed(context);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: const Text("Pomyślnie wylogowano!",
                textAlign: TextAlign.center),
            behavior: SnackBarBehavior.floating,
            margin: EdgeInsets.only(
                bottom: screenHeight * 0.05,
                left: screenWidth * 0.05,
                right: screenWidth * 0.05),
            duration: const Duration(milliseconds: 2500)));
      },
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(Colors.transparent),
        // Ustawienie przezroczystego tła przycisku
        padding: MaterialStateProperty.all<EdgeInsetsGeometry>(EdgeInsets.zero),
        // Ustawienie paddingu przycisku na zero
        tapTargetSize: MaterialTapTargetSize
            .shrinkWrap, // Zwinięcie przycisku, aby dopasować się do jego zawartości
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

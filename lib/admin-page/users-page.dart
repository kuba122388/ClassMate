import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../consts/consts.dart';

class UsersPage extends StatefulWidget {
  const UsersPage({super.key});

  @override
  State<UsersPage> createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<String> _userEmails = [];

  @override
  void initState() {
    super.initState();
    _fetchUserEmails();
  }

  Future<void> _fetchUserEmails() async {
    try {
      QuerySnapshot snapshot = await _firestore.collection('users').get();
      List<String> emails = snapshot.docs
          .map((doc) => doc['email'].toString())
          .where((email) => email != 'admin@classmate.com')
          .toList();
      setState(() {
        _userEmails = emails;
      });
    } catch (e) {
      print("Error fetching user emails: $e");
    }
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

  Widget BuildBody(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Center(
      child: _userEmails.isEmpty
          ? CircularProgressIndicator()
          : ListView.builder(
        padding: EdgeInsets.only(top: 50.0), // Większy odstęp od góry
        itemCount: _userEmails.length,
        itemBuilder: (context, index) {
          return Center(
            child: Card(
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0), // Ustaw radius 20
              ),
              margin: EdgeInsets.symmetric(vertical: 10.0),
              child: Container(
                width: screenWidth * 0.8, // Ustaw szerokość karty
                padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0), // Zmniejsz wysokość prostokątów
                child: Center( // Wyśrodkuj tekst w karcie
                  child: Text(
                    _userEmails[index],
                    style: TextStyle(
                      fontSize: 18.0,
                      color: Color(0xFF313E50), // Ustaw kolor tekstu
                    ),
                  ),
                ),
              ),
            ),
          );
        },
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
            ),
          ],
        ),
        child: Center(
          child: Text(
            'UZYTKOWINCY',
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
                height: screenHeight * 0.06,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

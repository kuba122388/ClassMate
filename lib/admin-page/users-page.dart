import 'package:audioplayers/audioplayers.dart';

import 'user-detail-page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../consts/consts.dart';

class UsersPage extends StatefulWidget {
  const UsersPage({Key? key}) : super(key: key);

  @override
  State<UsersPage> createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late List<String> userEmails = [];

  @override
  void initState() {
    super.initState();
    _updateUserList();
  }

  Future<List<String>> _fetchUserEmails() async {
    try {
      QuerySnapshot snapshot = await _firestore.collection('users').get();
      return snapshot.docs
          .map((doc) => doc['email'].toString())
          .where((email) => email != 'admin@classmate.com')
          .toList();
    } catch (e) {
      print("Error fetching user emails: $e");
      return [];
    }
  }

  Future<void> _updateUserList() async {
    List<String> newUserEmails = await _fetchUserEmails();
    setState(() {
      userEmails = newUserEmails;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: COLOR_BACKGROUND,
      appBar: _buildTopNav(context),
      body: _buildBody(context),
      bottomNavigationBar: _buildBackButton(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final AssetSource assetSource = AssetSource('../sounds/click.mp3');

    return Center(
      child: ListView.builder(
        padding: const EdgeInsets.only(top: 50.0),
        itemCount: userEmails.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () async {
              AudioPlayer().play(assetSource);
              final isDeleted = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => UserDetailPage(
                    email: userEmails[index],
                  ),
                ),
              );

            if(isDeleted) {
              setState(() {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text("Pomyślnie usunięto użytkownika!", textAlign: TextAlign.center),
                    behavior: SnackBarBehavior.floating,
                    duration: Duration(seconds: 2)));
                  _updateUserList();
                });
            }

            },
            child: Center(
              child: Card(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
                margin: const EdgeInsets.symmetric(vertical: 10.0),
                child: Container(
                  width: screenWidth * 0.8,
                  padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
                  child: Center(
                    child: Text(
                      userEmails[index],
                      style: const TextStyle(
                        fontSize: 18.0,
                        color: Color(0xFF313E50),
                      ),
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

  PreferredSizeWidget _buildTopNav(BuildContext context) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(kToolbarHeight),
      child: Container(
        padding: const EdgeInsets.only(top: 10, bottom: 10),
        decoration: const BoxDecoration(
          color: COLOR_BACKGROUND_DARKER,
          borderRadius: BorderRadius.vertical(bottom: BORDER_RADIUS),
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
            'UZYTKOWNICY',
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

  Widget _buildBackButton(BuildContext context) {
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
}

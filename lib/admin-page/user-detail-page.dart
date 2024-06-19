import 'package:audioplayers/audioplayers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../consts/consts.dart';

class UserDetailPage extends StatefulWidget {
  final String email;

  UserDetailPage({super.key, required this.email});

  @override
  State<UserDetailPage> createState() => _UserDetailPageState();
}

class _UserDetailPageState extends State<UserDetailPage> {
  bool deleted = false;

  Future<Map<String, dynamic>> _fetchUserData() async {
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;
    try {
      QuerySnapshot snapshot = await _firestore.collection('users').where('email', isEqualTo: widget.email).get();

      if (snapshot.docs.isNotEmpty) {
        return snapshot.docs.first.data() as Map<String, dynamic>;
      } else {
        return {};
      }
    } catch (e) {
      print("Error fetching user data: $e");
      return {};
    }
  }

  Future<void> _deleteUser(BuildContext context) async {
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;
    final AssetSource assetSource = AssetSource('../sounds/approved.mp3');

    try {
      QuerySnapshot snapshot = await _firestore.collection('users').where('email', isEqualTo: widget.email).get();

      for (var doc in snapshot.docs) {
        await _firestore.collection('users').doc(doc.id).delete();
        AudioPlayer().play(assetSource);
      }
    } catch (e) {
      print("Error deleting user: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error deleting user: $e')),
      );
    }
  }

  Future<void> _showDeleteConfirmationDialog(BuildContext context) async {
    AssetSource assetSource = AssetSource('../sounds/click.mp3');
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Potwierdzenie usunięcia'),
          content: const Text('Czy na pewno chcesz usunąć tego użytkownika?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Nie'),
              onPressed: () {
                AudioPlayer().play(assetSource);
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Tak'),
              onPressed: () async {
                await _deleteUser(context);
                deleted = true;
                Navigator.pop(context, true);
              },
            ),
          ],
        );
      },
    );
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

  PreferredSizeWidget BuildTopNav(BuildContext context) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(kToolbarHeight),
      child: Container(
        padding: const EdgeInsets.only(top: 10, bottom: 10),
        decoration: const BoxDecoration(
          color: COLOR_BACKGROUND_DARKER,
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(20),
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
          child: Image.asset(
            ('././images/user.png'),
            height: 50,
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
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
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
    AssetSource assetSource = AssetSource('../sounds/click.mp3');

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: COLOR_BACKGROUND,
      appBar: BuildTopNav(context),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _fetchUserData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No data found for this user'));
          } else {
            final userData = snapshot.data!;
            return Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 40),
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
                                text: userData['email'],
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
                                text: 'Imie: ',
                                style: TextStyle(
                                  color: Color(0xFFF6FFF8),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                              TextSpan(
                                text: userData['firstName'],
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
                                text: userData['lastName'],
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
                                text: _formatDate(userData['dateOfBirth']),
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
                                text: userData['university'],
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
                  ElevatedButton(
                    onPressed: () async {
                      AudioPlayer().play(assetSource);
                      await _showDeleteConfirmationDialog(context);
                      if(deleted) Navigator.pop(context, true);
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(Colors.transparent), // Ustawienie przezroczystego tła przycisku
                      padding: MaterialStateProperty.all<EdgeInsetsGeometry>(EdgeInsets.zero), // Ustawienie paddingu przycisku na zero
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap, // Zwinięcie przycisku, aby dopasować się do jego zawartości
                    ),
                    child: Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.all(15),
                      width: screenWidth * 0.50,
                      decoration: BoxDecoration(
                        color: COLOR_BACKGROUND_DARKER,
                        borderRadius: BorderRadius.circular(40),
                      ),
                      child: const Text(
                        'USUN',
                        style: TextStyle(
                          fontFamily: 'Asap',
                          fontSize: 18,
                          letterSpacing: 0.5,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }
        },
      ),
      bottomNavigationBar: BuildBackButton(context),
    );
  }
}

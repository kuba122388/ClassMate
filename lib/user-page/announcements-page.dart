import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../consts/consts.dart';

class AnnouncementsPage extends StatefulWidget {
  const AnnouncementsPage({Key? key}) : super(key: key);

  @override
  State<AnnouncementsPage> createState() => _AnnouncementsPageState();
}

class _AnnouncementsPageState extends State<AnnouncementsPage> {
  Future<List<Map<String, dynamic>>> fetchAnnouncements() async {
    List<Map<String, dynamic>> announcements = [];
    var collection = FirebaseFirestore.instance.collection('announcements');

    var snapshot = await collection.get();
    for (var doc in snapshot.docs) {
      announcements.add(doc.data());
    }
    return announcements;
  }

  @override
  Widget build(BuildContext context) {


    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: COLOR_BACKGROUND,
      appBar: BuildTopNav(context),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: fetchAnnouncements(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No announcements found'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                var announcement = snapshot.data![index];
                var timestamp = announcement['date'] as Timestamp;
                var date = timestamp.toDate();
                var formattedDate = '${date.year}-${date.month}-${date.day}';
                return Card(
                  child: ListTile(
                    leading: FutureBuilder<String>(
                      future: _getImageUrl(announcement['imageLink']),
                      builder: (context, imageSnapshot) {
                        if (imageSnapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const CircularProgressIndicator();
                        } else if (imageSnapshot.hasError) {
                          return const Icon(Icons.error);
                        } else {
                          return Image.network(imageSnapshot.data!);
                        }
                      },
                    ),
                    title: Text('Event Date: $formattedDate'),
                  ),
                );
              },
            );
          }
        },
      ),
      bottomNavigationBar: BuildBackButton(context),
    );
  }

  Future<String> _getImageUrl(String? imageUrl) async {
    if (imageUrl != null) {
      final ref = FirebaseStorage.instance.ref().child('announcements').child(imageUrl);
      var url = await ref.getDownloadURL() as String;
      print('TTUAJ JEST LINK!: $url');
      return url;
    } else {
      print('Nie działa');
      return ''; // Zwracamy pusty ciąg, jeśli nie ma linku obrazu
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
            'Ogłoszenia',
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
            ),
          ],
        ),
      ),
    );
  }
}
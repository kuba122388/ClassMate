import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/widgets.dart';
import '../consts/consts.dart';
import 'announcements-add.dart';

class AnnouncementsPage extends StatefulWidget {
  const AnnouncementsPage({Key? key}) : super(key: key);

  @override
  State<AnnouncementsPage> createState() => _AnnouncementsPageState();
}

class _AnnouncementsPageState extends State<AnnouncementsPage> {
  bool deleteOption = false;

  Future<List<Map<String, dynamic>>> fetchAnnouncements() async {
    List<Map<String, dynamic>> announcements = [];
    var collection = FirebaseFirestore.instance.collection('announcements').orderBy('date', descending: false);

    var snapshot = await collection.get();
    for (var doc in snapshot.docs) {
      Map<String, dynamic> temp = doc.data();
      temp.addAll({'ID': doc.id});
      announcements.add(temp);
    }

    return announcements;
  }

  Future<void> _navigateToAddAnnouncement(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AnnouncementAdd()),
    );

    if (result == true) {
      setState(() {
        fetchAnnouncements();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: COLOR_BACKGROUND,
      appBar: BuildTopNav(context),
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(
                child: FutureBuilder<List<Map<String, dynamic>>>(
                  future: fetchAnnouncements(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator(color: Colors.white));
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Center(
                          child: Text(
                        'Brak dodanych ogłoszeń',
                        style: TextStyle(color: Colors.white, fontSize: 24, fontFamily: 'Asap'),
                      ));
                    } else {
                      return ListView.builder(
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          var announcement = snapshot.data![index];
                          var timestamp = announcement['date'] as Timestamp;
                          var date = timestamp.toDate();
                          var formattedDate = '${date.day}-${date.month}-${date.year}';
                          var weekdayIndex = date.weekday;

                          Map<int, String> dayNames = {
                            1: 'Poniedziałek',
                            2: 'Wtorek',
                            3: 'Środa',
                            4: 'Czwartek',
                            5: 'Piątek',
                            6: 'Sobota',
                            7: 'Niedziela',
                          };

                          var dayOfWeek = dayNames[weekdayIndex];

                          return Container(
                            margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                            padding: const EdgeInsets.all(8.0),
                            decoration: BoxDecoration(
                              color: Colors.transparent,
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '$dayOfWeek, $formattedDate',
                                  style: const TextStyle(
                                    fontFamily: 'Croissant One',
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white, // Kolor tekstu
                                  ),
                                ),
                                const SizedBox(height: 8.0),
                                FutureBuilder<String>(
                                  future: _getImageUrl(announcement['imageLink']),
                                  builder: (context, imageSnapshot) {
                                    if (imageSnapshot.connectionState == ConnectionState.waiting) {
                                      return const Center(child: CircularProgressIndicator(color: Colors.white));
                                    } else if (imageSnapshot.hasError) {
                                      return const Center(child: Icon(Icons.error));
                                    } else {
                                      return Container(
                                        child: Stack(
                                          children: [
                                            ColorFiltered(
                                              colorFilter: deleteOption
                                                  ? ColorFilter.mode(
                                                      COLOR_BACKGROUND_DARKER.withOpacity(0.4),
                                                      BlendMode.dstATop,
                                                    )
                                                  : ColorFilter.mode(
                                                      Colors.transparent.withOpacity(0),
                                                      BlendMode.darken,
                                                    ),
                                              child: Image.network(imageSnapshot.data!),
                                            ),
                                            Visibility(
                                              visible: deleteOption,
                                              child: Positioned.fill(
                                                child: Center(
                                                  child: ElevatedButton(
                                                    onPressed: () async {
                                                      try {
                                                        await FirebaseFirestore.instance
                                                            .collection('announcements')
                                                            .doc(announcement['ID'])
                                                            .delete();

                                                        setState(() {
                                                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                                            duration: Duration(milliseconds: 1500),
                                                            behavior: SnackBarBehavior.floating,
                                                            content: Text("Ogłoszenie zostało pomyślnie usunięte!",
                                                                textAlign: TextAlign.center),
                                                          ));
                                                        });
                                                      } catch (e) {
                                                        setState(() {});
                                                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                                          duration: Duration(milliseconds: 1500),
                                                          behavior: SnackBarBehavior.floating,
                                                          content: Text("Wystąpił problem z usunięciem ogłoszenia",
                                                              textAlign: TextAlign.center),
                                                        ));
                                                      }
                                                    },
                                                    style: ElevatedButton.styleFrom(
                                                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                                      backgroundColor: COLOR_BACKGROUND_DARKER,
                                                    ),
                                                    child: const Text(
                                                      'USUN',
                                                      style: TextStyle(
                                                        fontSize: 24,
                                                        fontFamily: 'Asap',
                                                        fontWeight: FontWeight.bold,
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      );
                                    }
                                  },
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    }
                  },
                ),
              ),
            ],
          ),
          Visibility(
              visible: deleteOption ? false : true,
              child: Positioned(
                left: 24.0,
                bottom: 16.0,
                child: Material(
                  elevation: 20,
                  shadowColor: Colors.black,
                  borderRadius: BorderRadius.circular(25.0),
                  color: Colors.transparent,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.25),
                          spreadRadius: 0,
                          blurRadius: 4,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: ElevatedButton(
                      onPressed: () {
                        _navigateToAddAnnouncement(context);
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                        backgroundColor: COLOR_BACKGROUND_DARKER,
                      ),
                      child: const Text(
                        'DODAJ',
                        style: TextStyle(
                          fontSize: 24,
                          fontFamily: 'Asap',
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              )),
          Visibility(
              visible: deleteOption ? false : true,
              child: Positioned(
                right: 24.0,
                bottom: 16.0,
                child: Material(
                  elevation: 20,
                  shadowColor: Colors.black,
                  borderRadius: BorderRadius.circular(25.0),
                  color: Colors.transparent,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.25),
                          spreadRadius: 0,
                          blurRadius: 4,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          deleteOption = !deleteOption;
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                        backgroundColor: COLOR_BACKGROUND_DARKER,
                      ),
                      child: const Text(
                        'USUN',
                        style: TextStyle(
                          fontSize: 24,
                          fontFamily: 'Asap',
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ))
        ],
      ),
      bottomNavigationBar: BuildBackButton(context),
    );
  }

  Future<String> _getImageUrl(String? imageUrl) async {
    if (imageUrl != null) {
      final ref = FirebaseStorage.instance.ref().child('announcements').child(imageUrl);
      var url = await ref.getDownloadURL() as String;
      await Future.delayed(const Duration(seconds: 1));
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
        child: Center(
          child: deleteOption ? 
          Image.asset('images/announcements.png') : const Text(
            'OGŁOSZENIA',
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
                if (deleteOption == false) {
                  Navigator.of(context).pop();
                  return;
                }
                setState(() {
                  deleteOption = !deleteOption;
                });
              },
              icon: Image.asset('././images/back_icon.png', height: screenHeight * 0.06),
            ),
          ],
        ),
      ),
    );
  }
}

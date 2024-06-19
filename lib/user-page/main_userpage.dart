import 'package:audioplayers/audioplayers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../consts/consts.dart';
import '../database-features/DatabaseFeatures.dart';
import 'schedule-page.dart';
import 'sales-page.dart';
import 'announcements-page.dart';
import 'settings-page.dart';
import '../database-features/Task.dart';

class MainUserPage extends StatefulWidget {
  final String email;

  const MainUserPage({super.key, required this.email});

  @override
  State<MainUserPage> createState() => _MainUserPageState();
}

class _MainUserPageState extends State<MainUserPage> {
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
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final taskController = TextEditingController();
    final AssetSource assetSource = AssetSource('../sounds/click.mp3');

    return Center(
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.only(top: 15.0),
            width: screenWidth * 0.6,
            child: Image.asset('././images/logo.png'),
          ),
          const Divider(
            color: Colors.white,
            thickness: 4,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SizedBox(width: screenWidth * 0.14),
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
                  AudioPlayer().play(assetSource).then((_) {
                    _showAddTaskDialog(taskController);
                  });
                },
                icon: Image.asset(
                  '././images/plus.png',
                  height: screenHeight * 0.06,
                  width: screenWidth * 0.06,
                ),
              ),
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: screenWidth * 0.8,
                height: screenHeight * 0.42,
                child: TaskList(userEmail: widget.email),
              )
            ],
          )
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
        child: Row(
          children: [
            Container(
              width: MediaQuery.of(context).size.width / 2,
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
                      MaterialPageRoute(
                          builder: (context) =>
                              SettingsPage(email: widget.email)),
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
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => SchedulePage(
                                email: widget.email,
                              )));
                });
              },
              icon: Image.asset('././images/calendar.png',
                  height: screenHeight * 0.06),
            ),
            IconButton(
              onPressed: () {
                AudioPlayer().play(assetSource).then((_) {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const AnnouncementsPage()));
                });
              },
              icon: Image.asset('././images/announcements.png',
                  height: screenHeight * 0.06),
            ),
            IconButton(
              onPressed: () {
                AudioPlayer().play(assetSource).then((_) {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => const SalesPage()));
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

  void _showAddTaskDialog(taskController) {
    AssetSource assetSource = AssetSource('../sounds/approved.mp3');
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: COLOR_BACKGROUND_DARKER,
            titleTextStyle: const TextStyle(
                color: Colors.white, fontSize: 24, fontFamily: 'Asap'),
            title: const Text('Dodaj task', textAlign: TextAlign.center),
            content: Container(
              margin: const EdgeInsets.only(top: 20, bottom: 10),
              padding: const EdgeInsets.symmetric(horizontal: 10),
              decoration: const BoxDecoration(
                  color: COLOR_INPUT_FIELDS,
                  borderRadius: BorderRadius.all(BORDER_RADIUS_INPUTS),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.white,
                      offset: Offset(0, 0.0),
                      blurRadius: 3.0,
                    )
                  ]),
              child: TextFormField(
                controller: taskController,
                textAlign: TextAlign.center,
                decoration: const InputDecoration(
                    hintText: 'Tutaj wpisz swoje zadanie',
                    hintStyle: TextStyle(
                        fontFamily: 'Asap', fontStyle: FontStyle.italic),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide.none,
                    ),
                    border: InputBorder.none),
                style: const TextStyle(
                  color: Colors.white,
                  fontFamily: 'Asap',
                ),
              ),
            ),
            actions: [
              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: COLOR_BACKGROUND,
                    foregroundColor: Colors.white,
                    elevation: 10,
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 50),
                  ),
                  onPressed: () async {
                    if (taskController.text.isNotEmpty) {
                      Task newTask = Task(
                          task: taskController.text,
                          timestamp: Timestamp.now());
                      try {
                        await newTask.saveTask(widget.email);
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text("Dodano nowe zadanie do listy!",
                                    textAlign: TextAlign.center),
                                behavior: SnackBarBehavior.floating,
                                duration: Duration(milliseconds: 2500)));
                        AudioPlayer().play(assetSource);
                      } catch (e) {
                        print(e);
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text("Wystąpił błąd",
                                    textAlign: TextAlign.center),
                                behavior: SnackBarBehavior.floating,
                                duration: Duration(milliseconds: 2500)));
                      }
                      Navigator.pop(context);
                      taskController.clear();
                    } else {
                      assetSource = AssetSource('../sounds/click.mp3');
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text("Nie wprowadzono żadnej treści",
                              textAlign: TextAlign.center),
                          behavior: SnackBarBehavior.floating,
                          duration: Duration(milliseconds: 2500)));
                      AudioPlayer().play(assetSource).then((_) {
                        Navigator.pop(context);
                      });
                    }
                  },
                  child: const Text('Zapisz'),
                ),
              ),
            ],
          );
        });
  }
}

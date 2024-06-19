import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/date_symbol_data_local.dart';

import '../consts/consts.dart';

class SchedulePage extends StatefulWidget {
  final String email;

  const SchedulePage({super.key, required this.email});

  @override
  State<SchedulePage> createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  late CollectionReference _eventsCollection;
  late TextEditingController _titleController;

  late CalendarFormat _calendarFormat;
  late DateTime _focusedDay;
  late DateTime _selectedDay;
  late Map<DateTime, List<dynamic>> _events;

  @override
  void initState() {
    super.initState();
    _initializeUser();
    _titleController = TextEditingController();
    initializeDateFormatting('pl_PL');
    _calendarFormat = CalendarFormat.month;
    _focusedDay = DateTime.now();
    _selectedDay = DateTime.now();
    _events = {};
  }

  void _initializeUser() {
    _eventsCollection =
        _firestore.collection('users').doc(widget.email).collection('events');
  }

  bool isSameDate(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    AssetSource assetSource = AssetSource('../sounds/click.mp3');

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: COLOR_BACKGROUND,
      appBar: _buildTopNav(context),
      body: Stack(
        children: [
          Column(
            children: [
              _buildCalendar(),
              Column(
                children: [
                  SizedBox(
                    height: screenHeight * 0.22, // Ustaw wysokość kontenera
                    child: Column(
                      children: [_buildEventList()],
                    ),
                  ),
                ],
              )
            ],
          ),
          Positioned(
            bottom: 16,
            right: 16,
            child: FloatingActionButton(
              heroTag: null,
              onPressed: () {
                AudioPlayer().play(assetSource);
                _showAddEventDialog(context);
              },
              backgroundColor: COLOR_BACKGROUND_DARKER,
              child: const Icon(Icons.add, color: Colors.white),
            ),
          ),
          Positioned(
            bottom: 16,
            left: 16,
            child: FloatingActionButton(
              heroTag: null,
              onPressed: () {
                if (!isSameDate(_selectedDay, DateTime.now())) {
                  setState(() {
                    AudioPlayer().play(assetSource);
                    _selectedDay = DateTime.now();
                  });
                }
              },
              backgroundColor: COLOR_BACKGROUND_DARKER,
              child: Image.asset('images/today.png', height: 32,),
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buildBackButton(context),
    );
  }

  Widget _buildCalendar() {
    return TableCalendar(
      daysOfWeekHeight: 20,
      locale: 'pl_PL',
      calendarFormat: _calendarFormat,
      startingDayOfWeek: StartingDayOfWeek.monday,
      focusedDay: _focusedDay,
      firstDay: DateTime.utc(2021, 1, 1),
      lastDay: DateTime.utc(2030, 12, 31),
      selectedDayPredicate: (day) {
        return isSameDay(_selectedDay, day);
      },
      onDaySelected: (selectedDay, focusedDay) {
        setState(() {
          _selectedDay = selectedDay;
          _focusedDay = focusedDay;
        });
      },
      eventLoader: (day) {
        return _events[day] ?? [];
      },
      calendarStyle: const CalendarStyle(
        todayDecoration: BoxDecoration(
          color: COLOR_BACKGROUND_DARKER,
          shape: BoxShape.circle,
        ),
        selectedDecoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
        ),
        outsideDaysVisible: false,
        todayTextStyle: TextStyle(
            fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
        selectedTextStyle: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: COLOR_BACKGROUND_DARKER),
      ),
      daysOfWeekStyle: const DaysOfWeekStyle(
        weekdayStyle: TextStyle(color: Colors.white),
        weekendStyle: TextStyle(color: Colors.red),
      ),
      headerStyle: const HeaderStyle(
        titleTextStyle: TextStyle(
            fontSize: 25, fontWeight: FontWeight.bold, color: Colors.white),
        formatButtonVisible: false,
        leftChevronIcon:
            Icon(Icons.chevron_left, color: Colors.white, size: 40),
        rightChevronIcon:
            Icon(Icons.chevron_right, color: Colors.white, size: 40),
        titleCentered: true,
      ),
      calendarBuilders: CalendarBuilders(
        defaultBuilder: (context, date, events) {
          final isWeekend = date.weekday == 6 || date.weekday == 7;
          final isToday = isSameDay(DateTime.now(), date);
          return Container(
            margin: const EdgeInsets.all(4.0),
            alignment: Alignment.center,
            child: Text(
              '${date.day}',
              style: TextStyle(
                fontSize: 20,
                color: isToday
                    ? Colors.white
                    : (isWeekend ? Colors.red : Colors.white),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildEventList() {
    AssetSource assetSource = AssetSource('../sounds/click.mp3');
    return Expanded(
      child: StreamBuilder<QuerySnapshot>(
        stream: _eventsCollection.snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Wystąpił błąd: ${snapshot.error}');
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Container();
          }
          List<DocumentSnapshot> eventsForSelectedDay =
              snapshot.data!.docs.where((DocumentSnapshot document) {
            Map<String, dynamic> data = document.data() as Map<String, dynamic>;
            DateTime eventDate = (data['date'] as Timestamp).toDate();
            return isSameDay(eventDate, _selectedDay);
          }).toList();

          return ListView.builder(
            itemCount: eventsForSelectedDay.length,
            itemBuilder: (context, index) {
              DocumentSnapshot eventDoc = eventsForSelectedDay[index];
              Map<String, dynamic> data =
                  eventDoc.data() as Map<String, dynamic>;
              return Container(
                margin:
                    const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
                padding: const EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                  color: COLOR_BACKGROUND_DARKER,
                  borderRadius: BorderRadius.circular(10.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      data['title'],
                      style: const TextStyle(fontSize: 18, color: Colors.white),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.white),
                      onPressed: () {
                        AudioPlayer().play(assetSource);
                        _showDeleteConfirmationDialog(eventDoc.id);
                      },
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  Future<void> _showDeleteConfirmationDialog(String eventId) async {
    AssetSource assetSource = AssetSource('../sounds/click.mp3');
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: COLOR_BACKGROUND_DARKER,
          title: const Text(
            'Potwierdź usunięcie',
            style: TextStyle(color: Colors.white),
          ),
          content: const Text(
            'Czy na pewno chcesz usunąć to wydarzenie?',
            style: TextStyle(color: Colors.white),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text(
                'Anuluj',
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () {
                AudioPlayer().play(assetSource);
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text(
                'Usuń',
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () {
                assetSource = AssetSource('../sounds/click.mp3');
                AudioPlayer().play(assetSource);
                _deleteEvent(eventId);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _deleteEvent(String eventId) {
    _eventsCollection.doc(eventId).delete().then((_) {
      print('Event deleted');
    }).catchError((error) {
      print('Failed to delete event: $error');
    });
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
            )
          ],
        ),
        child: const Center(
          child: Text(
            'PLAN DNIA',
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

  BottomAppBar _buildBackButton(BuildContext context) {
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
            )
          ],
        ),
      ),
    );
  }

  Future<void> _showAddEventDialog(BuildContext context) async {
    AssetSource assetSource = AssetSource('../sounds/click.mp3');
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return Theme(
          data: Theme.of(context).copyWith(
            dialogBackgroundColor: COLOR_BACKGROUND,
          ),
          child: AlertDialog(
            title: const Text(
              'Dodaj wydarzenie',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _titleController,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    labelText: 'Tytuł',
                    labelStyle: TextStyle(color: Colors.white),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    _selectDate(context);
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                        COLOR_BACKGROUND_DARKER),
                    foregroundColor:
                        MaterialStateProperty.all<Color>(Colors.white),
                  ),
                  child: const Text('Wybierz datę'),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  AudioPlayer().play(assetSource);
                  Navigator.of(context).pop();
                  _titleController.clear();
                },
                child: const Text(
                  'Anuluj',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              TextButton(
                onPressed: () {
                  assetSource = AssetSource('../sounds/approved.mp3');
                  addEvent(_titleController.text, _selectedDay);
                  AudioPlayer().play(assetSource);
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    behavior: SnackBarBehavior.floating,
                    content: Text("Dodano zadanie!", textAlign: TextAlign.center),
                    duration: Duration(milliseconds: 2000),

                  ));
                  _titleController.clear();
                  Navigator.of(context).pop();
                },
                child: const Text(
                  'Dodaj',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final ThemeData themeData = Theme.of(context);
    const ColorScheme colorScheme = ColorScheme.dark(
      surface: COLOR_BACKGROUND,
      onPrimary: Colors.black,
      primary: Colors.white,
    );

    final ThemeData dialogTheme = themeData.copyWith(
      colorScheme: colorScheme,
    );

    final DateTime? picked = await showDatePicker(
      locale: const Locale('pl', 'PL'),
      context: context,
      initialDate: _selectedDay,
      firstDate: DateTime(2021),
      lastDate: DateTime(2030),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: dialogTheme,
          child: child ?? const SizedBox(),
        );
      },
    );

    if (picked != null && picked != _selectedDay) {
      setState(() {
        _selectedDay = picked;
      });
    }
  }

  void addEvent(String title, DateTime date) {
    _eventsCollection.add({'title': title, 'date': date});
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }
}

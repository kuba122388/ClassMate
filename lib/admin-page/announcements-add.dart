import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:intl/intl.dart';
import 'dart:io';
import '../database-features/Announcement.dart';

import '../consts/consts.dart';

class AnnouncementAdd extends StatefulWidget {
  const AnnouncementAdd({super.key});

  @override
  State<AnnouncementAdd> createState() => _AnnouncementAddState();
}

class _AnnouncementAddState extends State<AnnouncementAdd> {
  final _eventDate = TextEditingController();
  DateTime? _selectedDate;
  File? _image;

  Future<void> _pickDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = pickedDate;
        _eventDate.text = DateFormat('dd.MM.yyyy').format(_selectedDate!);
      });
    }
  }

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      }
    });
  }

  Future<void> _uploadImage() async {
    AssetSource assetSource = AssetSource('../sounds/click.mp3');

    if(_image == null && _selectedDate == null){
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Proszę podać datę i wybrać obraz promocji", textAlign: TextAlign.center),
          behavior: SnackBarBehavior.floating,
          duration: Duration(seconds: 2)));

      AudioPlayer().play(assetSource);
      return;
    }

    if (_image == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Proszę wybrać obraz promocji", textAlign: TextAlign.center),
          behavior: SnackBarBehavior.floating,
          duration: Duration(seconds: 2)));

      AudioPlayer().play(assetSource);
      return;
    }

    if(_selectedDate == null){
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Proszę wybrać datę wydarzenia", textAlign: TextAlign.center),
          behavior: SnackBarBehavior.floating,
          duration: Duration(seconds: 2)));

      AudioPlayer().play(assetSource);
      return;
    }

    final fileName = _image!.path.split('/').last;
    final ref = FirebaseStorage.instance.ref().child('announcements').child(fileName);

    await ref.putFile(_image!);
    final url = await ref.getDownloadURL();

    Announcement announcement = Announcement(_selectedDate!, fileName);
    announcement.saveAnnouncement();

    assetSource = AssetSource('../sounds/approved.mp3');
    AudioPlayer().play(assetSource);
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Ogłoszenie zostało pomyślnie dodane!", textAlign: TextAlign.center),
        behavior: SnackBarBehavior.floating,
        duration: Duration(seconds: 2)));

    print('Image URL: $url');
    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: COLOR_BACKGROUND,
      appBar: BuildTopNav(context),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            SizedBox(height: screenHeight * 0.06),
            InputWithTitle(context, 'Data'),
            Column(
              children: [
                Container(
                  width: screenWidth * 0.65,
                  padding: const EdgeInsets.only(top: 10, bottom: 10),
                  child: Text(
                    'Grafika',
                    style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'Architects Daughter',
                        fontSize: screenWidth * 0.06),
                  ),
                ),
                Container(
                  width: screenWidth * 0.75,
                  decoration: const BoxDecoration(
                    color: COLOR_INPUT_FIELDS,
                    borderRadius: BorderRadius.all(BORDER_RADIUS_INPUTS),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 0),
                  margin: const EdgeInsets.only(bottom: 25),
                  child: _image == null
                      ? ElevatedButton(
                    style: ButtonStyle(
                        padding: MaterialStateProperty.all(EdgeInsets.all(3)),
                        backgroundColor: MaterialStateProperty.all(COLOR_INPUT_FIELDS),
                        elevation: MaterialStateProperty.all(0)),
                    onPressed: _pickImage,
                    child: SizedBox(
                      width: double.infinity,
                      child: Center(
                        child: Image.asset('././images/upload_img.png',
                            height: screenHeight * 0.05),
                      ),
                    ),
                  )
                      : GestureDetector(
                    onTap: _pickImage,
                    child: SizedBox(
                      width: double.infinity,
                      child: Image.file(
                        _image!,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                )

              ],
            ),
            ElevatedButton(
              onPressed: () async {
                await _uploadImage();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: COLOR_BACKGROUND_DARKER,
                foregroundColor: COLOR_BACKGROUND,
                padding:
                const EdgeInsets.symmetric(vertical: 10, horizontal: 80),
              ),
              child: Text(
                "DODAJ",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: screenWidth * 0.05,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BuildBackButton(context),
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
        child: const Center(
          child: Text(
            'Dodaj ogłoszenie',
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

  Widget InputWithTitle(BuildContext context, String title) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Column(
      children: [
        Container(
          width: screenWidth * 0.65,
          padding: const EdgeInsets.only(top: 10, bottom: 10),
          child: Text(
            title,
            style: TextStyle(
                color: Colors.white,
                fontFamily: 'Architects Daughter',
                fontSize: screenWidth * 0.06),
          ),
        ),
        Container(
          width: screenWidth * 0.75,
          decoration: const BoxDecoration(
            color: COLOR_INPUT_FIELDS,
            borderRadius: BorderRadius.all(BORDER_RADIUS_INPUTS),
          ),
          padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 20),
          margin: const EdgeInsets.only(bottom: 25),
          child: TextFormField(
            onTap: () {
              FocusScope.of(context).requestFocus(FocusNode());
              _pickDate(context);
            },
            controller: _eventDate,
            decoration: InputDecoration(
                hintText: title,
                hintStyle: const TextStyle(
                    fontFamily: 'Asap', fontStyle: FontStyle.italic),
                focusedBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.transparent))),
            style: const TextStyle(
              color: Colors.white,
              fontFamily: "Croissant One",
            ),
          ),
        ),
      ],
    );
  }
}

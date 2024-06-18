import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import '../database-features/Sale.dart';

import '../consts/consts.dart';

class SalesAdd extends StatefulWidget {
  const SalesAdd({super.key});

  @override
  State<SalesAdd> createState() => _SalesAddState();
}

class _SalesAddState extends State<SalesAdd> {
  final code = TextEditingController();
  final description = TextEditingController();
  File? _image;
  final text = TextEditingController();
  AutovalidateMode autovalidateMode = AutovalidateMode.disabled;

  Map<String, bool> fieldErrors = {
    'Tytuł': false,
    'Tekst promocji': false,
    'Grafika': false,
  };

  final _formKey = GlobalKey<FormState>();

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
        fieldErrors['Grafika'] = true;
      }
    });
  }

  Future<void> _uploadImage() async {
    if (_image == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Proszę wrzucić obraz promocji", textAlign: TextAlign.center),
          behavior: SnackBarBehavior.floating,
          duration: Duration(seconds: 2)));
      return;
    }

    final fileName = _image!.path.split('/').last;
    final ref = FirebaseStorage.instance.ref().child('sales').child(fileName);

    await ref.putFile(_image!);
    final url = await ref.getDownloadURL();

    Sale sale = Sale(code.text, description.text, fileName, text.text);
    sale.saveSale();

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
      body: SingleChildScrollView(child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            SizedBox(height: screenHeight * 0.06),
            Form(
              key: _formKey,
              autovalidateMode: autovalidateMode,
              child: Column(
                children: [
                  InputWithTitle(context, 'Tytuł', description),
                  InputWithTitle(context, 'Kod promocyjny', code),
                  InputWithTitle(context, 'Tekst promocji', text),
                  Container(
                    width: screenWidth * 0.65,
                    padding: const EdgeInsets.only(top: 10, bottom: 10),
                    child: Text(
                      'Grafika',
                      style: TextStyle(
                          color: Colors.white, fontFamily: 'Architects Daughter', fontSize: screenWidth * 0.06),
                    ),
                  ),
                  Container(
                    width: screenWidth * 0.75,
                    decoration: const BoxDecoration(
                      color: COLOR_INPUT_FIELDS,
                      borderRadius: BorderRadius.all(BORDER_RADIUS_INPUTS),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 0),
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
                                child: Image.asset('././images/upload_img.png', height: screenHeight * 0.05),
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
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 30),
              child: ElevatedButton(
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  await _uploadImage();
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: COLOR_BACKGROUND_DARKER,
                foregroundColor: COLOR_BACKGROUND,
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 80),
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
            ),
          ],
        ),
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
            'Dodaj promocję',
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

  Widget InputWithTitle(BuildContext context, String title, TextEditingController controller) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Column(
      children: [
        Container(
          width: screenWidth * 0.65,
          padding: const EdgeInsets.only(top: 10, bottom: 10),
          child: Text(
            title,
            style: TextStyle(color: Colors.white, fontFamily: 'Architects Daughter', fontSize: screenWidth * 0.06),
          ),
        ),
        Container(
          width: screenWidth * 0.75,
          padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 20),
          margin: const EdgeInsets.only(bottom: 10),
          decoration: const BoxDecoration(
            color: COLOR_INPUT_FIELDS,
            borderRadius: BorderRadius.all(BORDER_RADIUS_INPUTS),
          ),
          child: TextFormField(
            controller: controller,
            keyboardType: TextInputType.multiline,
            maxLines: null,
            style: const TextStyle(
              color: Colors.white,
              fontFamily: "Croissant One",
            ),
            decoration: InputDecoration(
                border: const UnderlineInputBorder(borderSide: BorderSide.none),
                hintText: title,
                hintStyle: const TextStyle(fontFamily: 'Asap', fontStyle: FontStyle.italic),
                focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.transparent))),
            onChanged: (value) {
              setState(() {
                fieldErrors[title] = value.isNotEmpty;
              });
            },
            validator: (value) {
              if (fieldErrors[title] == false && title != 'Kod promocyjny') {
                autovalidateMode = AutovalidateMode.always;
                return "Proszę uzupełnić pole";
              }
              return null;
            },
          ),
        ),
      ],
    );
  }
}

import 'package:classmate/register-page/register-approved.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../consts/consts.dart';
import '../database-features/DatabaseFeatures.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  TextEditingController textController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  AutovalidateMode autovalidateMode = AutovalidateMode.disabled;

  final _imieController = TextEditingController();
  final _nazwiskoController = TextEditingController();
  final _emailController = TextEditingController();
  final _dataUrodzeniaController = TextEditingController();
  final _uczelniaController = TextEditingController();
  final _hasloController = TextEditingController();
  late DateTime _selectedDate;

  final List<String> Uczelnie = [
    'Politechnika Łódzka',
    'Politechnika Wrocławska',
    'Politechnika Częstochowska'
  ];

  Map<String, bool> fieldErrors = {
    'Imię': false,
    'Nazwisko': false,
    'E-mail': false,
    'Data urodzenia': false,
    'Uczelnia': false,
    'Hasło': false,
  };

  void _presentDatePicker() {
    DateTime now = DateTime.now();
    DateTime lastDate = DateTime(now.year - 16, now.month, now.day);
    showDatePicker(
      context: context,
      initialDate: lastDate,
      firstDate: DateTime(1900),
      lastDate: lastDate,
    ).then((pickedDate) {
      if (pickedDate == null) {
        return;
      }
      setState(() {
        _selectedDate = pickedDate;
        _dataUrodzeniaController.text =
            DateFormat('dd-MM-yyyy').format(_selectedDate);
        fieldErrors['Data urodzenia'] = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
        backgroundColor: COLOR_BACKGROUND,
        appBar: PreferredSize(
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
            child: Image.asset('././images/person_icon.png'),
          ),
        ),
        body: SingleChildScrollView(
          child: Center(
            child: Form(
              key: _formKey,
              autovalidateMode: autovalidateMode,
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.only(
                        top: screenHeight * 0.05, bottom: screenHeight * 0.03),
                    child: Text(
                      "CLASSMATE",
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'Croissant One',
                        fontSize: screenWidth * 0.09,
                      ),
                    ),
                  ),
                  InputWithTitle(context, 'Imię', _imieController),
                  InputWithTitle(context, 'Nazwisko', _nazwiskoController),
                  InputWithTitle(context, 'E-mail', _emailController),
                  InputWithTitle(context, 'Data urodzenia', _dataUrodzeniaController),
                  DropDownList(context, 'Uczelnia', _uczelniaController),
                  InputWithTitle(context, 'Hasło', _hasloController),
                  Container(
                    margin: const EdgeInsets.only(top: 30, bottom: 40),
                    child: ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          try {
                            ScaffoldMessenger.of(context)
                                .showSnackBar(const SnackBar(
                              content: Text("Przetwarzanie danych"),
                              duration: Duration(seconds: 1),
                            ));

                            await FirebaseAuth.instance.createUserWithEmailAndPassword(
                                    email: _emailController.text,
                                    password: _hasloController.text);

                            List<String> dateParts = _dataUrodzeniaController.text.split('-');
                            DateTime dateOfBirth = DateTime(int.parse(dateParts[2]), int.parse(dateParts[1]), int.parse(dateParts[0]));

                            DatabaseUser User = DatabaseUser(
                                firstName: _imieController.text,
                                lastName: _nazwiskoController.text,
                                email: _emailController.text,
                                dateOfBirth: dateOfBirth,
                                university: _uczelniaController.text);

                            saveUserData(User);

                            await Future.delayed(
                                const Duration(milliseconds: 1200));

                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const RegisterApproved()),
                            );
                          } on FirebaseAuthException catch (e) {
                            if (e.code == 'weak-password') {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(const SnackBar(
                                content:
                                    Text("Wprowadzone hasło jest za słabe"),
                              ));
                            } else if (e.code == 'email-already-in-use') {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(const SnackBar(
                                content: Text("Ten adres E-mail już istnieje"),
                              ));
                            } else {
                              print('UNKNOWN ERROR: ${e.code}');
                            }
                          }
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: COLOR_BACKGROUND_DARKER,
                        foregroundColor: COLOR_BACKGROUND,
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 30),
                      ),
                      child: Text(
                        "ZAREJESTRUJ",
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
        ),
        bottomNavigationBar: BuildBackButton(context));
  }

  BottomAppBar BuildBackButton(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return BottomAppBar(
      color: Colors.transparent,
      padding: EdgeInsets.zero,
      child: Container(
        decoration: const BoxDecoration(
            color: COLOR_BACKGROUND_DARKER,
            borderRadius: BorderRadius.vertical(top: BORDER_RADIUS)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: Image.asset('././images/back_icon.png',
                  height: screenHeight * 0.06),
            )
          ],
        ),
      ),
    );
  }

  Widget InputWithTitle(
      BuildContext context, String title, TextEditingController controller) {
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
          padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 20),
          margin: const EdgeInsets.only(bottom: 10),
          decoration: const BoxDecoration(
            color: COLOR_INPUT_FIELDS,
            borderRadius: BorderRadius.all(BORDER_RADIUS_INPUTS),
          ),
          child: TextFormField(
            onTap: () {
              if (title == 'Data urodzenia') {
                FocusScope.of(context).requestFocus(new FocusNode());
                _presentDatePicker();
              }
            },
            controller: controller,
            obscureText: title == 'Hasło',
            style: const TextStyle(
              color: Colors.white,
              fontFamily: "Croissant One",
            ),
            decoration: InputDecoration(
                border: const UnderlineInputBorder(borderSide: BorderSide.none),
                hintText: title,
                hintStyle: const TextStyle(
                    fontFamily: 'Asap', fontStyle: FontStyle.italic),
                focusedBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.transparent))),
            onChanged: (value) {
              setState(() {
                fieldErrors[title] = value.isNotEmpty;
              });
            },
            validator: (value) {
              if (fieldErrors[title] == false) {
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

  Widget DropDownList(
      BuildContext context, String title, TextEditingController controller) {
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
          padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 15),
          margin: const EdgeInsets.only(bottom: 10, left: 0),
          decoration: const BoxDecoration(
            color: COLOR_INPUT_FIELDS,
            borderRadius: BorderRadius.all(BORDER_RADIUS_INPUTS),
          ),
          child: DropdownButtonFormField<String>(
            padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 5),
            dropdownColor: COLOR_BACKGROUND_DARKER,
            hint: const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Uczelnia',
                style: TextStyle(
                    fontFamily: 'Asap',
                    fontStyle: FontStyle.italic,
                    fontSize: 16),
              ),
            ),
            decoration: const InputDecoration(
                border: UnderlineInputBorder(borderSide: BorderSide.none),
                hintStyle: TextStyle(fontFamily: 'Asap', fontStyle: FontStyle.italic),
                focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.transparent))),
            style: const TextStyle(
              color: Colors.white,
              fontFamily: "Croissant One",
            ),
            value: _uczelniaController.text.isEmpty
                ? null
                : _uczelniaController.text,
            items: Uczelnie.map((String uczelnia) {
              return DropdownMenuItem<String>(
                value: uczelnia,
                child: Text(uczelnia),
              );
            }).toList(),
            onChanged: (String? newValue) {
              setState(() {
                _uczelniaController.text = newValue!;
                fieldErrors[title] = newValue.isNotEmpty;
              });
            },
            validator: (value) {
              if (fieldErrors[title] == false) {
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

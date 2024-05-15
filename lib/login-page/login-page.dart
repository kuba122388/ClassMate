import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../consts/consts.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();

  final _emailController = TextEditingController();
  final _hasloController = TextEditingController();

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
    return Center(
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.only(
                top: screenHeight * 0.1, bottom: screenHeight * 0.05),
            child: Text(
              "CLASSMATE",
              style: TextStyle(
                color: Colors.white,
                fontFamily: 'Croissant One',
                fontSize: screenWidth * 0.09,
              ),
            ),
          ),
          Form(
            key: _formKey,
            child: Column(children: [
              InputWithTitle(context, 'E-mail', _emailController),
              InputWithTitle(context, 'Hasło', _hasloController),
              const SizedBox(height: kToolbarHeight),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    try {
                      UserCredential userCredential = await FirebaseAuth
                          .instance
                          .signInWithEmailAndPassword(
                        email: _emailController.text,
                        password: _hasloController.text,
                      );
                      ScaffoldMessenger.of(context)
                          .showSnackBar(const SnackBar(
                        behavior: SnackBarBehavior.floating,
                        content: Text("Zalogowano",
                            textAlign: TextAlign.center),
                      ));
                      Future.delayed(
                        const Duration(seconds: 2), () => Navigator.push(
                        context, MaterialPageRoute(builder: (context) => const LoginPage()),
                      ),);

                    } on FirebaseAuthException catch (e) {
                      if (e.code == 'invalid-credential') {
                        ScaffoldMessenger.of(context)
                            .showSnackBar(const SnackBar(
                          behavior: SnackBarBehavior.floating,
                          content: Text("Wprowadzone dane są nieprawidłowe",
                              textAlign: TextAlign.center),
                        ));
                      }
                      else if(e.code == 'invalid-email'){
                        ScaffoldMessenger.of(context)
                            .showSnackBar(const SnackBar(
                          behavior: SnackBarBehavior.floating,
                          content: Text("E-mail posiada nieprawidłowy format",
                              textAlign: TextAlign.center),
                        ));
                      }
                      else{
                        ScaffoldMessenger.of(context)
                            .showSnackBar(const SnackBar(
                          behavior: SnackBarBehavior.floating,
                          content: Text("Unknown Error occured",
                              textAlign: TextAlign.center),
                        ));
                      }
                      print('Code: ${e.code}');
                    }
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: COLOR_BACKGROUND_DARKER,
                  foregroundColor: COLOR_BACKGROUND,
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 50),
                ),
                child: Text(
                  "ZALOGUJ",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: screenWidth * 0.05,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ]),
          ),
        ],
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
              )
            ]),
        child: Image.asset('././images/person_icon.png'),
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
          decoration: const BoxDecoration(
            color: COLOR_INPUT_FIELDS,
            borderRadius: BorderRadius.all(BORDER_RADIUS_INPUTS),
          ),
          padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 20),
          margin: const EdgeInsets.only(bottom: 25),
          child: TextFormField(
            controller: controller,
            obscureText: title == 'Hasło',
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
            validator: (value) {
              if (value!.isEmpty) {
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

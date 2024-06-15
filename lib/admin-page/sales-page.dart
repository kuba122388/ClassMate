import 'package:classmate/admin-page/sales-add.dart';
import 'package:classmate/user-page/sales-page-end.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import '../consts/consts.dart';

class SalesPage extends StatefulWidget {
  const SalesPage({super.key});

  @override
  State<SalesPage> createState() => _SalesPageState();
}

class _SalesPageState extends State<SalesPage> {
  bool deleteOption = false;

  Future<List<Map<String, dynamic>>> fetchSales() async {
    List<Map<String, dynamic>> sales = [];
    var collection = FirebaseFirestore.instance.collection('sales');

    var snapshot = await collection.get();
    for (var doc in snapshot.docs) {
      Map<String, dynamic> temp = doc.data();
      temp.addAll({'ID': doc.id});
      sales.add(temp);
    }
    return sales;
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
                    future: fetchSales(),
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
                            var sales = snapshot.data![index];

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
                                  const SizedBox(height: 8.0),
                                  FutureBuilder<String>(
                                    future: _getImageUrl(sales['image']),
                                    builder: (context, imageSnapshot) {
                                      if (imageSnapshot.connectionState == ConnectionState.waiting) {
                                        return const Center(child: CircularProgressIndicator());
                                      } else if (imageSnapshot.hasError) {
                                        return const Center(child: Icon(Icons.error));
                                      } else if (imageSnapshot.hasData && imageSnapshot.data != null) {
                                        String img = imageSnapshot.data!;
                                        String id = sales['ID'];
                                        String code = sales['code'];
                                        String txt = sales['text'];
                                        String description = sales['description'];

                                        return deleteOption
                                            ? Stack(
                                                children: [
                                                  ShaderMask(
                                                    shaderCallback: (bounds) => deleteOption
                                                        ? LinearGradient(
                                                            colors: [
                                                              COLOR_BACKGROUND_DARKER.withOpacity(0.4),
                                                              COLOR_BACKGROUND_DARKER.withOpacity(0.4)
                                                            ],
                                                          ).createShader(bounds)
                                                        : const LinearGradient(
                                                            colors: [Colors.transparent, Colors.transparent],
                                                          ).createShader(bounds),
                                                    blendMode: BlendMode.srcATop,
                                                    child: Image.network(img),
                                                  ),
                                                  Visibility(
                                                    visible: deleteOption,
                                                    child: Positioned.fill(
                                                      child: Center(
                                                        child: ElevatedButton(
                                                          onPressed: () async {
                                                            try {
                                                              await FirebaseFirestore.instance
                                                                  .collection('sales')
                                                                  .doc(id)
                                                                  .delete();

                                                              setState(() {
                                                                ScaffoldMessenger.of(context)
                                                                    .showSnackBar(const SnackBar(
                                                                  duration: Duration(milliseconds: 1500),
                                                                  behavior: SnackBarBehavior.floating,
                                                                  content: Text(
                                                                      "Ogłoszenie zostało pomyślnie usunięte!",
                                                                      textAlign: TextAlign.center),
                                                                ));
                                                              });
                                                            } catch (e) {
                                                              setState(() {});
                                                              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                                                duration: Duration(milliseconds: 1500),
                                                                behavior: SnackBarBehavior.floating,
                                                                content: Text(
                                                                    "Wystąpił problem z usunięciem ogłoszenia",
                                                                    textAlign: TextAlign.center),
                                                              ));
                                                            }
                                                          },
                                                          style: ElevatedButton.styleFrom(
                                                            padding: const EdgeInsets.symmetric(
                                                                horizontal: 20, vertical: 10),
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
                                              )
                                            : GestureDetector(
                                                onTap: () {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) => SalesPageEnd(
                                                            imag: img, code: code, txt: txt, description: description)),
                                                  );
                                                },
                                                child: Image.network(img),
                                              );
                                      } else {
                                        return const Center(child: Text('Brak danych'));
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
                )
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
                    borderRadius: BorderRadius.circular(8.0),
                    color: Colors.transparent,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.7),
                            spreadRadius: 2,
                            blurRadius: 10,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: ElevatedButton(
                        onPressed: () {
                          _navigateToAddSales(context);
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
                    borderRadius: BorderRadius.circular(8.0),
                    color: Colors.transparent,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.7),
                            spreadRadius: 2,
                            blurRadius: 10,
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
        bottomNavigationBar: BuildBackButton(context));
  }

  Future<String> _getImageUrl(String? imageUrl) async {
    if (imageUrl != null) {
      final ref = FirebaseStorage.instance.ref().child('sales').child(imageUrl);
      var url = await ref.getDownloadURL();
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
              )
            ]),
        child: const Center(
          child: Text(
            'Promocje',
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

  Future<void> _navigateToAddSales(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const SalesAdd()),
    );

    if (result == true) {
      setState(() {
        fetchSales();
      });
    }
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
              icon: Image.asset('././images/back_icon.png',
                  height: screenHeight * 0.06),
            ),
          ],
        ),
      ),
    );
  }
}

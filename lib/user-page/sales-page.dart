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
  Future<List<Map<String, dynamic>>> fetchSales() async {
    List<Map<String, dynamic>> sales = [];
    var collection = FirebaseFirestore.instance.collection('sales');

    var snapshot = await collection.get();
    for (var doc in snapshot.docs) {
      sales.add(doc.data());
    }
    await Future.delayed(const Duration(seconds: 2));
    return sales;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: COLOR_BACKGROUND,
        appBar: BuildTopNav(context),
        body: FutureBuilder<List<Map<String, dynamic>>>(
          future: fetchSales(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator(color: Colors.white));
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
                    margin: const EdgeInsets.symmetric(
                        vertical: 8.0, horizontal: 16.0),
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
                              return const Center(child: CircularProgressIndicator(color: Colors.white,));
                            } else if (imageSnapshot.hasError) {
                              return const Center(child: Icon(Icons.error));
                            } else if (imageSnapshot.hasData && imageSnapshot.data != null) {
                              String img = imageSnapshot.data!;
                              String code = sales['code'];
                              String txt = sales['text'];
                              String description = sales['description'];
                              return GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => SalesPageEnd(imag: img, code: code, txt: txt, description: description)),
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
        bottomNavigationBar: BuildBackButton(context));
  }

  Center BuildBody(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeigh = MediaQuery.of(context).size.height;
    double imageSpacing = screenHeigh * 0.05;

    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: screenWidth * 0.9,
            margin: EdgeInsets.only(top: imageSpacing),
            child: Image.asset(
              './images/Sales_MaxBurger.png',
              fit: BoxFit.contain,
            ),
          ),
          Container(
            width: screenWidth * 0.9,
            margin: EdgeInsets.only(top: imageSpacing),
            child: Image.asset(
              './images/Sales_Python.png',
              fit: BoxFit.contain,
            ),
          ),
          Container(
            width: screenWidth * 0.9,
            margin: EdgeInsets.only(top: imageSpacing),
            child: Image.asset(
              './images/Sales_Indeks.png',
              fit: BoxFit.contain,
            ),
          ),
        ],
      ),
    );
  }

  Future<String> _getImageUrl(String? imageUrl) async {
    if (imageUrl != null) {
      final ref = FirebaseStorage.instance.ref().child('sales').child(imageUrl);
      var url = await ref.getDownloadURL();
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
              )
            ]),
        child: const Center(
          child: Text(
            'PROMOCJE',
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
}

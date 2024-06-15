import 'package:cloud_firestore/cloud_firestore.dart';

class Sale {
  final String code;
  final String description;
  final String imageLink;
  final String text;


  Sale(this.code, this.description, this.imageLink, this.text);

  Map<String, dynamic> toMap() {
    return {
      'code' : code,
      'description' : description,
      'image' : imageLink,
      'text' : text
    };
  }

  Future<void> saveSale() async {
    try {
      await FirebaseFirestore.instance
          .collection('sales')
          .add(toMap());
    } catch (e) {
      print('Wystąpił błąd: $e');
    }
  }
}
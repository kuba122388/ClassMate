import 'package:cloud_firestore/cloud_firestore.dart';

class Announcement {
  final DateTime date;
  final String imageLink;

  Announcement(this.date, this.imageLink);

  Map<String, dynamic> toMap() {
    return {
      'date' : date,
      'imageLink' : imageLink
    };
  }

  Future<void> saveAnnouncement() async {
    try {
      await FirebaseFirestore.instance
          .collection('announcements')
          .add(toMap());
    } catch (e) {
      print('Wystąpił błąd: $e');
    }
  }
}
import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseUser {
  String firstName;
  String lastName;
  String email;
  DateTime dateOfBirth;
  String university;

  DatabaseUser({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.dateOfBirth,
    required this.university,
  });

  // Metoda do konwersji obiektu User do mapy (przydatne przy zapisywaniu do Firestore)
  Map<String, dynamic> toMap() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'dateOfBirth': dateOfBirth.toIso8601String(),
      'university': university,
    };
  }

// Metoda do tworzenia obiektu User z mapy (przydatne przy odczytywaniu z Firestore)
  factory DatabaseUser.fromMap(Map<String, dynamic> map) {
    return DatabaseUser(
      firstName: map['firstName'],
      lastName: map['lastName'],
      email: map['email'],
      dateOfBirth: map['dateOfBirth'],
      university: map['university'],
    );
  }
}

// Przykładowe użycie zapisu i odczytu danych użytkownika do/z Firebase Firestore


void saveUserData(DatabaseUser user) async {
  try {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(user.email)  // Używanie e-maila jako identyfikatora dokumentu
        .set(user.toMap());
    print('Dane użytkownika zostały zapisane.');
  } catch (e) {
    print('Wystąpił błąd podczas zapisywania danych użytkownika: $e');
  }
}

Future<DatabaseUser?> getUserData(String email) async {
  try {
    DocumentSnapshot doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(email)
        .get();

    if (doc.exists) {
      return DatabaseUser.fromMap(doc.data() as Map<String, dynamic>);
    } else {
      print('Użytkownik nie został znaleziony.');
      return null;
    }
  } catch (e) {
    print('Wystąpił błąd podczas pobierania danych użytkownika: $e');
    return null;
  }
}


  // Pobieranie danych
  //DatabaseUser? retrievedUser = await getUserData('tutaj e-mail');
 // if (retrievedUser != null) {
 //   print('Pobrano dane użytkownika: ${retrievedUser.firstName} ${retrievedUser.lastName}');
 // }
//}
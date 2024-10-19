

import 'package:firebase_cloud_firestore/firebase_cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

import 'firebase_options.dart';

void main() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  addEmptyPerfume();
}
Future<void> addEmptyPerfume() async {
  // Get a reference to the Firestore collection
  CollectionReference perfumes = FirebaseFirestore.instance.collection('perfumes');

  // Add perfume data with empty/default values
  perfumes
      .add({
    'aroma': '', // Empty string
    'brand': '', // Empty string
    'buyurl': '', // Empty string
    'description': '', // Empty string
    'imageurl': '', // Empty string
    'ml': 0, // Default to zero for numeric value
    'name': '', // Empty string
    'price': 0.0 // Default to 0.0 for price
  })
      .then((value) => print("Empty perfume added"))
      .catchError((error) => print("Failed to add perfume: $error"));


}

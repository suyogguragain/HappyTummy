import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class RestaurantRepository {
  final FirebaseAuth _firebaseAuth;
  final Firestore _firestore;

  RestaurantRepository({FirebaseAuth firebaseAuth, Firestore firestore})
      : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
        _firestore = firestore ?? Firestore.instance;

  Future<void> signInWithEmail(String email, String password) {
    return _firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);
  }

  Future<bool> isFirstTime(String userId) async {
    bool exist;
    await Firestore.instance
        .collection('restaurants')
        .document(userId)
        .get()
        .then((user) {
      exist = user.exists;
    });

    return exist;
  }

  Future<void> signUpWithEmail(String email, String password) async {
    print(_firebaseAuth);
    return await _firebaseAuth.createUserWithEmailAndPassword(
        email: email, password: password);
  }

  Future<void> signOut() async {
    return await _firebaseAuth.signOut();
  }

  Future<bool> isSignedIn() async {
    final currentUser = _firebaseAuth.currentUser();
    return currentUser != null;
  }

  Future<String> getUser() async {
    return (await _firebaseAuth.currentUser()).uid;
  }

  //profile setup
  Future<void> profileSetup(
      File photo,
      String rid,
      String name,
      String cusines,
      String mealtype,
      String outlettype,
      String parking,
      String paymentmethod,
      String billingextra,
      String phone,
      String longitude,
      String latitude,
      String sunday,
      String monday,
      String tuesday,
      String wednesday,
      String thrusday,
      String friday,
      String saturday,
      DateTime age,
      String location) async {
    StorageUploadTask storageUploadTask;
    storageUploadTask = FirebaseStorage.instance
        .ref()
        .child('restaurantProfilePhotos')
        .child(rid)
        .child(rid)
        .putFile(photo);

    return await storageUploadTask.onComplete.then((ref) async {
      await ref.ref.getDownloadURL().then((url) async {
        await _firestore.collection('restaurants').document(rid).setData({
          'rid': rid,
          'name': name,
          'cusines': cusines,
          'mealtype': mealtype,
          'outlettype': outlettype,
          'photo': url,
          'parking': parking,
          'paymentmethod': paymentmethod,
          'billingextra': billingextra,
          "location": location,
          'age': age,
          'phone': phone,
          'longitude': longitude,
          'latitude': latitude,
          'sunday': sunday,
          'monday': monday,
          'tuesday': tuesday,
          'wednesday': wednesday,
          'thrusday': thrusday,
          'friday': friday,
          'saturday': saturday,
        });
      });
    });
  }
}

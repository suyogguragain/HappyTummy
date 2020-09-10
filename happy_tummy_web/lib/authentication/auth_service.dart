
import 'dart:js';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:happy_tummy_web/authentication/login.dart';
import 'package:happy_tummy_web/authentication/signup.dart';
import 'package:happy_tummy_web/website/web_home_screen.dart';

class AuthService {
  //Handle Authentication
  handleAuth() {
    return StreamBuilder(
      // ignore: deprecated_member_use
      stream: FirebaseAuth.instance.onAuthStateChanged,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return WebHomePage();
        } else {
          return SignUp();
        }
      },
    );
  }

  //Sign Out
  signOut() {
    FirebaseAuth.instance.signOut();
  }

  //Sign in
  signIn(email, password) {
    FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password)
        .then((user) {
      print('Signed in');

    }).catchError((e) {
      print(e);
    });
  }

  //create user
  createUser(email, password) {
    FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password)
        .then((user) {
      print('Account created');
    }).catchError((e) {
      print(e);
    });
  }
}
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:happy_tummy/restaurant/bloc/blocDelegate.dart';
import 'package:happy_tummy/restaurant/repositories/restaurantRepository.dart';
import 'package:happy_tummy/src/pages/order/config/config.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'src/app.dart';

//void main() {
//  runApp(App());
//}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  WidgetsFlutterBinding.ensureInitialized();
  final RestaurantRepository _restaurantRepository = RestaurantRepository();

  BlocSupervisor.delegate = SimpleBlocDelegate();

//  HappyTummy.auth = FirebaseAuth.instance;
//  HappyTummy.sharedPreferences = await SharedPreferences.getInstance();
//  HappyTummy.firestore = Firestore.instance;

  runApp(App());
}

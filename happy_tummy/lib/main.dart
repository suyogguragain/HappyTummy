import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:happy_tummy/restaurant/bloc/blocDelegate.dart';
import 'package:happy_tummy/restaurant/repositories/restaurantRepository.dart';
import 'src/app.dart';

//void main() {
//  runApp(App());
//}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  WidgetsFlutterBinding.ensureInitialized();
  final RestaurantRepository _restaurantRepository = RestaurantRepository();

  BlocSupervisor.delegate = SimpleBlocDelegate();
  
  runApp(App());
}

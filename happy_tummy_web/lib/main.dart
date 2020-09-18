import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:happy_tummy_web/bloc/authentication/authentication_bloc.dart';
import 'package:happy_tummy_web/bloc/authentication/authentication_event.dart';
import 'package:happy_tummy_web/repositories/restaurantRepository.dart';
import 'package:happy_tummy_web/ui/pages/home.dart';
import 'package:happy_tummy_web/website/web.dart';
import 'package:happy_tummy_web/website/web_home_screen.dart';

import 'bloc/blocDelegate.dart';

// void main() {
//   runApp(WebApp());
// }


void main() {
  WidgetsFlutterBinding.ensureInitialized();
  final RestaurantRepository _restaurantRepository = RestaurantRepository();

  BlocSupervisor.delegate = SimpleBlocDelegate();

  runApp(BlocProvider(
      create: (context) => AuthenticationBloc(restaurantRepository: _restaurantRepository)
        ..add(AppStarted()),
      child: Home(restaurantRepository: _restaurantRepository,)));
}
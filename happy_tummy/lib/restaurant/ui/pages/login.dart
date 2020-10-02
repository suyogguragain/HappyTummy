import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:happy_tummy/restaurant/bloc/login/bloc.dart';
import 'package:happy_tummy/restaurant/repositories/restaurantRepository.dart';
import 'package:happy_tummy/restaurant/ui/widget/loginForm.dart';

import '../constants.dart';

class Login extends StatelessWidget {
  final RestaurantRepository _restaurantRepository;

  Login({@required RestaurantRepository restaurantRepository})
      : assert(restaurantRepository != null),
        _restaurantRepository = restaurantRepository;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Welcome ",
          style: TextStyle(fontSize: 36.0,color: Colors.black54,fontFamily: 'Lobster'),
        ),
        centerTitle: true,
        backgroundColor: backgroundColor,
        elevation: 0,
      ),
      body: BlocProvider<LoginBloc>(
        create: (context) => LoginBloc(
          restaurantRepository: _restaurantRepository,
        ),
        child: LoginForm(
          restaurantRepository: _restaurantRepository,
        ),
      ),
    );
  }
}
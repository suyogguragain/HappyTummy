import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:happy_tummy/restaurant/bloc/signup/bloc.dart';
import 'package:happy_tummy/restaurant/repositories/restaurantRepository.dart';
import 'package:happy_tummy/restaurant/ui/widget/signUpForm.dart';

import '../constants.dart';

class SignUp extends StatelessWidget {
  final RestaurantRepository _restaurantRepository;

  SignUp({@required RestaurantRepository restaurantRepository})
      : assert(restaurantRepository != null),
        _restaurantRepository = restaurantRepository;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Sign Up",
          style: TextStyle(fontSize: 36.0,fontFamily: 'Lobster',color: Colors.black54),
        ),
        centerTitle: true,
        backgroundColor: backgroundColor,
        elevation: 0,
      ),
      body: BlocProvider<SignUpBloc>(
        create: (context) => SignUpBloc(
          restaurantRepository: _restaurantRepository,
        ),
        child: SignUpForm(
          restaurantRepository: _restaurantRepository,
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:happy_tummy/restaurant/bloc/authentication/bloc.dart';
import 'package:happy_tummy/restaurant/repositories/restaurantRepository.dart';
import 'package:happy_tummy/restaurant/ui/pages/login.dart';
import 'package:happy_tummy/restaurant/ui/pages/profile.dart';
import 'package:happy_tummy/restaurant/ui/pages/splash.dart';
import 'package:happy_tummy/restaurant/ui/widget/tabs.dart';

class RestaurantHomePage extends StatelessWidget {
  final RestaurantRepository _restaurantRepository;

  RestaurantHomePage({@required RestaurantRepository restaurantRepository})
      : assert(restaurantRepository != null),
        _restaurantRepository = restaurantRepository;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: BlocBuilder<AuthenticationBloc, AuthenticationState>(
        builder: (context, state) {
          if (state is Uninitialized) {
            return Splash();
          }
          if (state is Authenticated) {
            return Tabs(
              userId: state.userId,
            );
          }
          if (state is AuthenticatedButNotSet) {
            return Profile(
              restaurantRepository: _restaurantRepository,
              rid: state.userId,
            );
          }
          if (state is Unauthenticated) {
            return Login(
              restaurantRepository: _restaurantRepository,
            );
          } else
            return Container();
        },
      ),
    );
  }
}

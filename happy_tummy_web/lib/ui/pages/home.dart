import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:happy_tummy_web/bloc/authentication/authentication_bloc.dart';
import 'package:happy_tummy_web/bloc/authentication/authentication_state.dart';
import 'package:happy_tummy_web/repositories/restaurantRepository.dart';
import 'package:happy_tummy_web/ui/pages/login.dart';
import 'package:happy_tummy_web/ui/pages/profile.dart';
import 'package:happy_tummy_web/ui/pages/splash.dart';
import 'package:happy_tummy_web/ui/widgets/tabs.dart';

class Home extends StatelessWidget {
  final RestaurantRepository _restaurantRepository;

  Home({@required RestaurantRepository restaurantRepository})
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

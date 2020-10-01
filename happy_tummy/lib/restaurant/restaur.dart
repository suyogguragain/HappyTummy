
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:happy_tummy/restaurant/repositories/restaurantRepository.dart';
import 'package:happy_tummy/restaurant/ui/pages/restauranthome.dart';

import 'bloc/authentication/bloc.dart';

class res extends StatelessWidget {
  final RestaurantRepository _restaurantRepository = RestaurantRepository();
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) =>
        AuthenticationBloc(restaurantRepository: _restaurantRepository)
          ..add(AppStarted()),
        child: RestaurantHomePage(
          restaurantRepository: _restaurantRepository,
        ));
  }
}

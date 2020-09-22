import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:happy_tummy_web/bloc/profile/bloc.dart';
import 'package:happy_tummy_web/repositories/restaurantRepository.dart';
import 'package:happy_tummy_web/ui/widgets/profileForm.dart';

import '../constants.dart';

class Profile extends StatelessWidget {
  final _restaurantRepository;
  final rid;

  Profile({@required RestaurantRepository restaurantRepository, String rid})
      : assert(restaurantRepository != null && rid != null),
        _restaurantRepository = restaurantRepository,
        rid = rid;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Profile Setup"),
        centerTitle: true,
        backgroundColor: backgroundColor,
        elevation: 0,
      ),
      body: BlocProvider<ProfileBloc>(
        create: (context) => ProfileBloc(restaurantRepository: _restaurantRepository),
        child: ProfileForm(
          restaurantRepository: _restaurantRepository,
        ),
      ),
    );
  }
}
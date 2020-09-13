import 'dart:js';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:happy_tummy_web/bloc/authentication/authentication_bloc.dart';
import 'package:happy_tummy_web/bloc/authentication/authentication_event.dart';
import 'package:happy_tummy_web/bloc/authentication/authentication_state.dart';
import 'package:happy_tummy_web/repositories/restaurantRepository.dart';
import 'package:happy_tummy_web/ui/pages/splash.dart';
import 'package:happy_tummy_web/ui/widgets/tabs.dart';

// class Home extends StatelessWidget {
//   final RestaurantRepository _restaurantRepository;

//   Home({@required RestaurantRepository restaurantRepository})
//       : assert(restaurantRepository != null),
//         _restaurantRepository = restaurantRepository;

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: BlocBuilder<AuthenticationBloc, AuthenticationState>(
//         builder: (context, state) {
//           if (state is Uninitialized) {
//             return Splash();
//           }
//           if (state is Authenticated) {
//             return Tabs(
//               userId: state.userId,
//             );
//           }
//           if (state is AuthenticatedButNotSet) {
//             return Profile(
//               userRepository: _restaurantRepository,
//               userId: state.userId,
//             );
//           }
//           if (state is Unauthenticated) {
//             return Login(
//               userRepository: _restaurantRepository,
//             );
//           } else
//             return Container();
//         },
//       ),
//     );
//   }
// }


class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final RestaurantRepository _restaurantRepository = RestaurantRepository();
  AuthenticationBloc _authenticationBloc;

  @override
  void initState() {
    _authenticationBloc = AuthenticationBloc(restaurantRepository: _restaurantRepository);
    _authenticationBloc.add(AppStarted());
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _authenticationBloc,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: BlocBuilder(
          bloc: _authenticationBloc,
          builder: (BuildContext context, AuthenticationState state){
            if (state is Uninitialized) {
            return Splash();
          }
          else{
            return Tabs();
          }
          },
          ),
        ),
      
    );
  }
}
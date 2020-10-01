import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:happy_tummy/restaurant/bloc/authentication/bloc.dart';
import 'package:happy_tummy/restaurant/sections/main.dart';
import 'package:happy_tummy/restaurant/ui/pages/splash.dart';

import '../constants.dart';

final eventsReference = Firestore.instance.collection('events');
final offersReference = Firestore.instance.collection('offers');
final menuReference = Firestore.instance.collection('restarurantMenu');

class Tabs extends StatelessWidget {
  final userId;

  const Tabs({this.userId});

  @override
  Widget build(BuildContext context) {
    List<Widget> pages = [
      MainPage(restaurantProfileId: userId,),
      Splash(),
      Splash(),
      Splash(),
      Splash(),
    ];

    return Theme(
      data: ThemeData(
        primaryColor: backgroundColor,
        accentColor: Colors.white,
      ),
      child: DefaultTabController(
        length: 5,
        child: Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: Text(
              "Happy Tummy",
              style: TextStyle(fontSize: 30.0, fontWeight: FontWeight.bold),
            ),
            actions: <Widget>[
              IconButton(
                icon: Icon(Icons.exit_to_app),
                onPressed: () {
                  print(userId);
                  BlocProvider.of<AuthenticationBloc>(context).add(LoggedOut());
                },
              )
            ],
            bottom: PreferredSize(
              preferredSize: Size.fromHeight(48.0),
              child: Container(
                height: 48.0,
                alignment: Alignment.center,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    TabBar(
                      tabs: <Widget>[
                        Tab(
                          child: Text("Home"),
                        ),
                        Tab(
                          child: Text("Menu"),
                        ),
                        Tab(
                          child: Text("Gallery"),
                        ),
                        Tab(
                          child: Text("Events"),
                        ),
                        Tab(
                          child: Text("Offers"),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
          body: TabBarView(
            children: pages,
          ),
        ),
      ),
    );
  }
}

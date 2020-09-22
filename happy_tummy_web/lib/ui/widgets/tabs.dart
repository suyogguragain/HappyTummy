import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:happy_tummy_web/bloc/authentication/bloc.dart';
import 'package:happy_tummy_web/ui/pages/splash.dart';
import 'package:happy_tummy_web/website/sections/events/foodevents.dart';
import 'package:happy_tummy_web/website/sections/foodmenu/food_menu.dart';
import 'package:happy_tummy_web/website/sections/offers/offer_section.dart';
import 'package:happy_tummy_web/website/web_home_screen.dart';

import '../constants.dart';

final eventsReference = Firestore.instance.collection('events');
final offersReference = Firestore.instance.collection('offers');

class Tabs extends StatelessWidget {
  final userId;

  const Tabs({this.userId});

  @override
  Widget build(BuildContext context) {
    List<Widget> pages = [
      WebHomePage(
        restaurantProfileId: userId,
      ),
      FoodmenuSection(),
      Splash(),
      FoodEventsSection(
        restaurantProfileId: userId,
      ),
      OffersSection(
        restaurantProfileId: userId,
      )
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

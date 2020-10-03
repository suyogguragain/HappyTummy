import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:happy_tummy/restaurant/bloc/authentication/bloc.dart';
import 'package:happy_tummy/restaurant/sections/events.dart';
import 'package:happy_tummy/restaurant/sections/gallery.dart';
import 'package:happy_tummy/restaurant/sections/main.dart';
import 'package:happy_tummy/restaurant/sections/menu.dart';
import 'package:happy_tummy/restaurant/sections/offers.dart';
import 'package:happy_tummy/restaurant/ui/pages/splash.dart';

import '../constants.dart';

final eventsReference = Firestore.instance.collection('events');
final offersReference = Firestore.instance.collection('offers');
final menuReference = Firestore.instance.collection('restarurantMenu');
final gallerysReference = Firestore.instance.collection('gallery');
final StorageReference menustorageReference =
    FirebaseStorage.instance.ref().child('MenuPictures');
final StorageReference gallerystorageReference =
    FirebaseStorage.instance.ref().child('GalleryPictures');

class Tabs extends StatelessWidget {
  final userId;

  const Tabs({this.userId});

  @override
  Widget build(BuildContext context) {
    List<Widget> pages = [
      MainPage(
        restaurantProfileId: userId,
      ),
      MenuPage(
        restaurantProfileId: userId,
      ),
      GalleryPage(
        restaurantProfileId: userId,
      ),
      FoodEventsSection(
        restaurantProfileId: userId,
      ),
      OffersSection(
        restaurantProfileId: userId,
      ),
    ];

    return Theme(
      data: ThemeData(
        primaryColor: Colors.deepOrange,
        accentColor: Colors.white,
      ),
      child: DefaultTabController(
        length: 5,
        child: Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: Text(
              "Happy Tummy",
              style: TextStyle(fontSize: 30.0, fontWeight: FontWeight.bold,fontFamily: "Lobster"),
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

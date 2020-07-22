import 'package:flutter/material.dart';
import 'package:happy_tummy/src/scoped-model/main_model.dart';
import '../pages/event_page.dart';
import '../pages/home_page.dart';
import '../pages/profile_page.dart';
import '../pages/post_page.dart';
import '../pages/offer_page.dart';

class MainScreen extends StatefulWidget {

  final MainModel model;

  MainScreen({this.model});

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {

  int currentTabIndex = 0;

  List<Widget> pages;
  Widget currentPage;

  HomePage homePage;
  ProfilePage profilePage;
  PostPage postPage;
  EventPage eventPage;
  OfferPage offerPage;

  @override
  void initState() {
    widget.model.fetchRestaurants();

    homePage = HomePage();
    profilePage = ProfilePage();
    postPage = PostPage();
    eventPage = EventPage();
    offerPage = OfferPage();
    pages = [postPage,offerPage,homePage,eventPage,profilePage];

    currentPage = homePage;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        onTap: (index) {
          setState(() {
            currentTabIndex = index;
            currentPage = pages[index];
          });
        },
        currentIndex: currentTabIndex,
        type: BottomNavigationBarType.fixed,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(
              Icons.explore,
            ),
            title: Text("Post"),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.local_offer,
            ),
            title: Text("Offers"),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
            ),
            title: Text("Home"),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.event,
            ),
            title: Text("Events"),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.person,
            ),
            title: Text("Profile"),
          ),
        ],
      ),
      body: currentPage,
    );
  }
}

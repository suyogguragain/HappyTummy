import 'package:flutter/material.dart';

import '../../../constants.dart';

class Menu extends StatefulWidget {
  @override
  _MenuState createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: kDefaultPadding * 2.5),
      constraints: BoxConstraints(maxWidth: 1110),
      height: 100,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10),
          topRight: Radius.circular(10),
        ),
        boxShadow: [kDefaultShadow],
      ),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        MaterialButton(
          padding: EdgeInsets.only(left:40, top: 25,bottom: 25,right: 40),
          color: Colors.redAccent,
          splashColor: Colors.teal,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(25.0))),
          onPressed: () {},
          child: Text(
            "Profile",
            style: TextStyle(color: Colors.white,fontSize: 26),
          ),
        ),
       MaterialButton(
          padding: EdgeInsets.only(left:40, top: 25,bottom: 25,right: 40),
          color: Colors.redAccent,
          splashColor: Colors.teal,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(25.0))),
          onPressed: () {},
          child: Text(
            "Profile",
            style: TextStyle(color: Colors.white,fontSize: 26),
          ),
        ),
        MaterialButton(
          padding: EdgeInsets.only(left:40, top: 25,bottom: 25,right: 40),
          color: Colors.redAccent,
          splashColor: Colors.teal,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(25.0))),
          onPressed: () {},
          child: Text(
            "Profile",
            style: TextStyle(color: Colors.white,fontSize: 26),
          ),
        ),
        MaterialButton(
          padding: EdgeInsets.only(left:40, top: 25,bottom: 25,right: 40),
          color: Colors.redAccent,
          splashColor: Colors.teal,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(25.0))),
          onPressed: () {},
          child: Text(
            "Profile",
            style: TextStyle(color: Colors.white,fontSize: 26),
          ),
        ),
        MaterialButton(
          padding: EdgeInsets.only(left:40, top: 25,bottom: 25,right: 40),
          color: Colors.redAccent,
          splashColor: Colors.teal,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(25.0))),
          onPressed: () {},
          child: Text(
            "Profile",
            style: TextStyle(color: Colors.white,fontSize: 26),
          ),
        ),
      ]),
    );
  }
}

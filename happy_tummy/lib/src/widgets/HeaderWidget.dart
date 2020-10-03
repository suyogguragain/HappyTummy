import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

AppBar header (context, {bool isAppTitle=false ,String strTitle, disableBackButton=false})
{
  return AppBar (
    iconTheme: IconThemeData(
      color: Colors.white,
    ),
    automaticallyImplyLeading: disableBackButton ? false : true,
    title: Text(
      isAppTitle ? "HappyTummy" : strTitle,
      style: TextStyle(
        color: Colors.white,
        fontFamily: isAppTitle ? 'PermanentMarker' : "PermanentMarker",
        fontSize: isAppTitle ? 32.0 : 32.0,
      ),
      overflow: TextOverflow.ellipsis,
    ),
    centerTitle: true,
    backgroundColor: Colors.deepOrange,
  );
}
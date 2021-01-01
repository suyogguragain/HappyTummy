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
        fontFamily: isAppTitle ? 'Roboto' : "Roboto",
        fontSize: isAppTitle ? 28.0 : 28.0,
      ),
      overflow: TextOverflow.ellipsis,
    ),
    centerTitle: true,
    backgroundColor: Colors.black,
  );
}
import 'package:flutter/material.dart';
import 'package:happy_tummy/src/widgets/HeaderWidget.dart';

class OfferPage extends StatefulWidget {
  @override
  _OfferPageState createState() => _OfferPageState();
}

class _OfferPageState extends State<OfferPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: header(context,strTitle: "Offers"),
    );
  }
}


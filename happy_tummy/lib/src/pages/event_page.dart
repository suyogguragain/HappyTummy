import 'package:flutter/material.dart';
import 'package:happy_tummy/src/widgets/HeaderWidget.dart';

class EventPage extends StatefulWidget {
  @override
  _EventPageState createState() => _EventPageState();
}

class _EventPageState extends State<EventPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: header(context,strTitle: "Events"),
    );
  }
}

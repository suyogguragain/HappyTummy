import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:happy_tummy/src/widgets/HeaderWidget.dart';

class EventPage extends StatefulWidget {
  @override
  _EventPageState createState() => _EventPageState();
}

class _EventPageState extends State<EventPage> {
  Future _data;

  Future getrestaurants() async {
    var firestore = Firestore.instance;

    QuerySnapshot qn = await firestore.collection('restaurants').getDocuments();

    return qn.documents;
  }
  navigateToDetail(DocumentSnapshot restaurant){
    Navigator.push(context, MaterialPageRoute(builder: (context) => RestaurantDetails(restaurant: restaurant,)));
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _data = getrestaurants();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: header(context, strTitle: "Events"),
      body: Container(
        child: FutureBuilder(
            future: _data,
            builder: (_, snapshot) {
              if (snapshot.connectionState == ConnectionState.active) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else {
                return ListView.builder(
                    itemCount: snapshot.data.length,
                    itemBuilder: (_, index) {
                      return ListTile(
                        title: Text(snapshot.data[index].data['name']),
                        onTap: (){
                          navigateToDetail(snapshot.data[index]);
                        },
                      );
                    });
              }
            }),
//        child: Center(
//          child: ListView(
//            physics: NeverScrollableScrollPhysics(),
//            shrinkWrap: true,
//            children: <Widget>[
//              Icon(Icons.event_busy,color: Colors.lightBlueAccent,size: 150.0,),
//              Text(
//                'No Events Available',
//                textAlign: TextAlign.center,
//                style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w500,fontSize: 22.0,fontFamily:'Lobster',),
//              ),
//
//            ],
//          ),
//        ),
      ),
    );
  }
}

class RestaurantDetails extends StatefulWidget {
  final DocumentSnapshot restaurant;

  RestaurantDetails({this.restaurant});

  @override
  _RestaurantDetailsState createState() => _RestaurantDetailsState();
}

class _RestaurantDetailsState extends State<RestaurantDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.restaurant.data['name']),
      ),
      body: Container(
        child: Card(
          child: ListTile(
            title: Text(widget.restaurant.data['name']),
            subtitle: Text(widget.restaurant.data['parking']),
          ),
        ),
      ),
    );
  }
}

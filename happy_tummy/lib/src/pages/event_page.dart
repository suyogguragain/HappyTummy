import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:happy_tummy/src/pages/book_event/book_event.dart';
import 'package:happy_tummy/src/widgets/HeaderWidget.dart';
import 'package:happy_tummy/src/widgets/ProgressWidget.dart';

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

  navigateToDetail(DocumentSnapshot restaurant) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => RestaurantDetails(
                  restaurant: restaurant,
                )));
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
                if (!snapshot.hasData) {
                  return Center(
                    child: ListView(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      children: <Widget>[
                        circularProgress(),
                        Icon(
                          Icons.event_busy,
                          color: Colors.lightBlueAccent,
                          size: 150.0,
                        ),
                        Text(
                          'No Events Available',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.grey,
                            fontWeight: FontWeight.w500,
                            fontSize: 22.0,
                            fontFamily: 'Lobster',
                          ),
                        ),
                      ],
                    ),
                  );
                }
                return ListView.builder(
                    itemCount: snapshot.data.length,
                    itemBuilder: (_, index) {
                      return ListTile(
                        title: Container(
                          height: 160,
                          margin: EdgeInsets.only(right: 10.0, bottom: 15),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10.0),
                            child: Stack(
                              children: <Widget>[
                                Container(
                                  height: 150.0,
                                  width: 380.0,
                                  child: Image.asset(
                                    'assets/images/back2.jpg',
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                Positioned(
                                  left: 100.0,
                                  bottom: 70.0,
                                  child: Row(
                                    children: <Widget>[
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text(
                                            snapshot.data[index].data['name'],
                                            style: TextStyle(
                                              fontSize: 32.0,
                                              fontFamily: "Lobster",
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        //title: Text(snapshot.data[index].data['name']),
                        onTap: () {
                          navigateToDetail(snapshot.data[index]);
                        },
                      );
                    });
              }
            }),
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
  Future _data;
  Future getevents() async {
    var firestore = Firestore.instance;

    QuerySnapshot qn = await firestore
        .collection('events')
        .document('${widget.restaurant.data['rid']}')
        .collection('userPosts')
        .getDocuments();

    return qn.documents;
  }

  Future<List<DocumentSnapshot>> getProduceID() async {
    var data = await Firestore.instance.collection('events').getDocuments();
    var productId = data.documents;
    print(productId);
    return productId;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _data = getevents();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: header(context, strTitle: "${widget.restaurant.data['name']}"),
      body: Container(
        child: FutureBuilder(
            future: _data,
            builder: (_, snapshot) {
              if (snapshot.connectionState == ConnectionState.active) {
                return Center(
                  child: Text("Loading"),
                );
              } else {
                if (!snapshot.hasData) {
                  return Center(
                    child: ListView(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      children: <Widget>[
                        circularProgress(),
                        Icon(
                          Icons.event_busy,
                          color: Colors.lightBlueAccent,
                          size: 150.0,
                        ),
                        Text(
                          'No Events Available',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.grey,
                            fontWeight: FontWeight.w500,
                            fontSize: 22.0,
                            fontFamily: 'Lobster',
                          ),
                        ),
                      ],
                    ),
                  );
                }
                return ListView.builder(
                    itemCount: snapshot.data.length,
                    itemBuilder: (_, index) {
                      return ListTile(
                        title: Container(
                          height: 180,
                          margin: EdgeInsets.only(bottom: 16),
                          decoration: BoxDecoration(
                              color: Color(0xff29404E),
                              borderRadius: BorderRadius.circular(8)),
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                child: Container(
                                  padding: EdgeInsets.only(left: 16),
                                  width:
                                      MediaQuery.of(context).size.width - 100,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        snapshot.data[index].data['heading'],
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 28,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      SizedBox(
                                        height: 8,
                                      ),
                                      Row(
                                        children: <Widget>[
                                          Text(
                                            snapshot.data[index]
                                                .data['description'],
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 20,
                                                fontWeight: FontWeight.normal),
                                          )
                                        ],
                                      ),
                                      SizedBox(
                                        height: 4,
                                      ),
                                      Row(
                                        children: [
                                          Image.asset(
                                            "assets/images/location.png",
                                            height: 12,
                                          ),
                                          SizedBox(
                                            width: 8,
                                          ),
                                          Image.asset(
                                            "assets/images/calender.png",
                                            height: 12,
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 15,
                                      ),
                                      GestureDetector(
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    ReservePage(),
                                              ),
                                            );
                                          },
                                          child: Text(
                                            'Book Event',
                                            style: TextStyle(
                                              color: Colors.white,
                                            ),
                                          ))
                                    ],
                                  ),
                                ),
                              ),
                              ClipRRect(
                                  borderRadius: BorderRadius.only(
                                      topRight: Radius.circular(8),
                                      bottomRight: Radius.circular(8)),
                                  child: Image.asset(
                                    'assets/images/second.png',
                                    height: 170,
                                    width: 150,
                                    fit: BoxFit.fill,
                                  )),
                            ],
                          ),
                        ),
                      );
                    });
              }
            }),
      ),
    );
  }
}

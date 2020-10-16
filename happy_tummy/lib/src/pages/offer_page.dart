import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:happy_tummy/src/pages/qr_code/qr_code.dart';
import 'package:happy_tummy/src/widgets/HeaderWidget.dart';
import 'package:happy_tummy/src/widgets/ProgressWidget.dart';

class OfferPage extends StatefulWidget {
  @override
  _OfferPageState createState() => _OfferPageState();
}

class _OfferPageState extends State<OfferPage> {
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
        builder: (context) => RestaurantEventDetails(
          restaurant: restaurant,
        ),
      ),
    );
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
      appBar: header(context, strTitle: "Offers"),
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
                          height: 150,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(39),
                            gradient: LinearGradient(colors: [
                              Colors.black,
                              Colors.black
                            ]),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 5,
                                blurRadius: 7,
                                offset:
                                    Offset(0, 3), // changes position of shadow
                              ),
                            ],
                          ),
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => QRCode(),
            ),
          );
        },
        child: Icon(Icons.qr_code_scanner),
      ),
    );
  }
}

class RestaurantEventDetails extends StatefulWidget {
  final DocumentSnapshot restaurant;

  RestaurantEventDetails({this.restaurant});

  @override
  _RestaurantEventDetailsState createState() => _RestaurantEventDetailsState();
}

class _RestaurantEventDetailsState extends State<RestaurantEventDetails> {
  Future _data;
  Future getoffers() async {
    var firestore = Firestore.instance;

    QuerySnapshot qn = await firestore
        .collection('offers')
        .document('${widget.restaurant.data['rid']}')
        .collection('restarurantOffers')
        .getDocuments();

    return qn.documents;
  }

  Future<List<DocumentSnapshot>> getProduceID() async {
    var data = await Firestore.instance.collection('offers').getDocuments();
    var productId = data.documents;
    print(productId);
    return productId;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _data = getoffers();
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
                            borderRadius: BorderRadius.circular(8),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 5,
                                blurRadius: 7,
                                offset:
                                    Offset(0, 3), // changes position of shadow
                              ),
                            ],
                          ),
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
                                        snapshot.data[index].data['title'],
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

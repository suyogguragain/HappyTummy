import 'package:cloud_firestore/cloud_firestore.dart';

class Restaurant {
  String rid;
  String name;
  String cusines;
  String mealtype;
  String outlettype;
  String parking;
  String paymentmethod;
  String billingextra;
  //String photo;
  Timestamp age;
  String location;

  Restaurant({
    this.rid,
    this.name,
    this.cusines,
    this.mealtype,
    //this.photo,
    this.outlettype,
    this.parking,
    this.paymentmethod,
    this.billingextra,
    this.age,
    this.location,
  });

  factory Restaurant.fromDocument(DocumentSnapshot doc) {
    return Restaurant(
      rid: doc.documentID,
      name: doc['name'],
      cusines: doc['cusines'],
      mealtype: doc['mealtype'],
      outlettype: doc['outlettype'],
      parking: doc['parking'],
      paymentmethod: doc['paymentmethod'],
      billingextra: doc['billingextra'],
      age: doc['age'],
      location: doc['location']
    );
  }
}

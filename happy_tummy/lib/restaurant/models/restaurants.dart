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
  String photo;
  Timestamp age;
  String location;
  String phone;
  String long;
  String lat;
  String sun;
  String mon;
  String tue;
  String wed;
  String thru;
  String fri;
  String sat;

  //add
  double avgRating;
  int numRatings;

  //

  Restaurant({
    this.rid,
    this.name,
    this.cusines,
    this.mealtype,
    this.photo,
    this.outlettype,
    this.parking,
    this.paymentmethod,
    this.billingextra,
    this.age,
    this.location,
    this.phone,
    this.long,
    this.lat,
    this.sun,
    this.mon,
    this.tue,
    this.wed,
    this.thru,
    this.fri,
    this.sat,

    //add
    this.avgRating,
    this.numRatings,
    //
  });

  factory Restaurant.fromDocument(DocumentSnapshot doc) {
    return Restaurant(
      rid: doc.documentID,
      name: doc['name'],
      photo: doc['photo'],
      cusines: doc['cusines'],
      mealtype: doc['mealtype'],
      outlettype: doc['outlettype'],
      parking: doc['parking'],
      paymentmethod: doc['paymentmethod'],
      billingextra: doc['billingextra'],
      age: doc['age'],
      location: doc['location'],
      phone: doc['phone'],
      long: doc['longitude'],
      lat: doc['latitude'],
      sun: doc['sunday'],
      mon: doc['monday'],
      tue: doc['tuesday'],
      wed: doc['wednesday'],
      thru: doc['thrusday'],
      fri: doc['friday'],
      sat: doc['saturday'],
      //add
      avgRating: doc['avgRating'].toDouble(),
      numRatings: doc['numRatings'],
      //
    );
  }
}

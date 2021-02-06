import 'package:cloud_firestore/cloud_firestore.dart';

class ProfileItem {
  final String name;
  final String billingextra;
  final String cusines;
  final String location;
  final String mealtype;
  final String parking;
  final String outlettype;
  final String paymentmethod;
  final String phone;
  final String photo;
  final String rid;

  final String sun;
  final String mon;
  final String tue;
  final String thru;
  final String fri;
  final String wed;
  final String sat;

  ProfileItem(
      {this.name,
      this.billingextra,
      this.cusines,
      this.location,
      this.mealtype,
      this.parking,
      this.outlettype,
      this.paymentmethod,
      this.rid,
      this.photo,
      this.phone,
      this.sun,
      this.mon,
      this.tue,
      this.thru,
      this.fri,
      this.sat,
      this.wed});

  factory ProfileItem.fromDocument(DocumentSnapshot documentSnapshot) {
    return ProfileItem(
        name: documentSnapshot['name'],
        billingextra: documentSnapshot['billingextra'],
        cusines: documentSnapshot['cusines'],
        location: documentSnapshot['location'],
        mealtype: documentSnapshot['mealtype'],
        parking: documentSnapshot['parking'],
        outlettype: documentSnapshot['outlettype'],
        paymentmethod: documentSnapshot['paymentmethod'],
        rid: documentSnapshot['rid'],
        photo: documentSnapshot['photo'],
        phone: documentSnapshot['phone'],

    );
  }
}

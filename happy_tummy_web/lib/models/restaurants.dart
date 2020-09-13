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

  Restaurant(
      {this.rid,
      this.name,
      this.age,
      this.billingextra,
      this.cusines,
      this.mealtype,
      this.photo,
      this.age,
      this.location,
      this.outlettype,
      this.parking,
      this.paymentmethod
      });
}
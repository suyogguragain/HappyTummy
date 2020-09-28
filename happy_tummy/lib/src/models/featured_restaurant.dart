import 'package:cloud_firestore/cloud_firestore.dart';

class ItemModel {
  final DocumentReference documentReference;
  String name;
  String billingextra;
  String cusines;
  String location;
  String mealtype;
  String parking;
  String outlettype;
  String paymentmethod;
  String rid;

  ItemModel.data(this.documentReference,
      [this.name,
        this.billingextra,
        this.cusines,
        this.location,
        this.mealtype,
        this.parking,
        this.outlettype,
        this.paymentmethod,
        this.rid]);

  factory ItemModel.from(DocumentSnapshot document) =>
      ItemModel.data(
          document != null ? document.reference : null,
          document.data['name'],
          document.data['billingextra'],
          document.data['cusines'],
          document.data['location'],
          document.data['mealtype'],
          document.data['parking'],
          document.data['outlettype'],
          document.data['paymentmethod'],
          document.data['rid']);

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'bilingextra': billingextra,
      'cusines': cusines,
      'location': location,
      'mealtype': mealtype,
      'parking': parking,
      'outlettype': outlettype,
      'paymentmethod': paymentmethod,
      'rid': rid
    };
  }
}

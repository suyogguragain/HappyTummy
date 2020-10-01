import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

abstract class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object> get props => [];
}

class NameChanged extends ProfileEvent {
  final String name;

  NameChanged({@required this.name});

  @override
  List<Object> get props => [name];
}

 class PhotoChanged extends ProfileEvent {
   final File photo;

   PhotoChanged({@required this.photo});

   @override
   List<Object> get props => [photo];
 }

class CusinesChanged extends ProfileEvent {
  final String cusines;

  CusinesChanged({@required this.cusines});

  @override
  List<Object> get props => [cusines];
}

class MealTypeChanged extends ProfileEvent {
  final String mealtype;

  MealTypeChanged({@required this.mealtype});

  @override
  List<Object> get props => [mealtype];
}

class OutletTypeChanged extends ProfileEvent {
  final String outlettype;

  OutletTypeChanged({@required this.outlettype});

  @override
  List<Object> get props => [outlettype];
}

class ParkingChanged extends ProfileEvent {
  final String parking;

  ParkingChanged({@required this.parking});

  @override
  List<Object> get props => [parking];
}

class PaymentMethodChanged extends ProfileEvent {
  final String paymentmethod;

  PaymentMethodChanged({@required this.paymentmethod});

  @override
  List<Object> get props => [paymentmethod];
}

class BilingExtraChanged extends ProfileEvent {
  final String billingextra;

  BilingExtraChanged({@required this.billingextra});

  @override
  List<Object> get props => [billingextra];
}

class AgeChanged extends ProfileEvent {
  final DateTime age;

  AgeChanged({@required this.age});

  @override
  List<Object> get props => [age];
}

class LocationChanged extends ProfileEvent {
  final String location;

  LocationChanged({@required this.location});

  @override
  List<Object> get props => [location];
}

class Submitted extends ProfileEvent {
  final String name,
      cusines,
      mealtype,
      outlettype,
      parking,
      paymentmethod,
      billingextra,
      location;
  final DateTime age;
  final File photo;
  //final Image photo;

  Submitted({
    @required this.name,
    @required this.cusines,
    @required this.mealtype,
    @required this.outlettype,
    @required this.parking,
    @required this.paymentmethod,
    @required this.billingextra,
    @required this.age,
    @required this.location,
    @required this.photo
  });

  @override
  List<Object> get props => [
        name,
        cusines,
        mealtype,
        outlettype,
        parking,
        paymentmethod,
        billingextra,
        age,
        location,
        photo
      ];
}

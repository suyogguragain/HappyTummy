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

class PhoneChanged extends ProfileEvent {
  final String phone;

  PhoneChanged({@required this.phone});

  @override
  List<Object> get props => [phone];
}

class LongitudeChanged extends ProfileEvent {
  final String long;

  LongitudeChanged({@required this.long});

  @override
  List<Object> get props => [long];
}

class LatitudeChanged extends ProfileEvent {
  final String lat;

  LatitudeChanged({@required this.lat});

  @override
  List<Object> get props => [lat];
}

class SundayChanged extends ProfileEvent {
  final String sun;

  SundayChanged({@required this.sun});

  @override
  List<Object> get props => [sun];
}

class MondayChanged extends ProfileEvent {
  final String mon;

  MondayChanged({@required this.mon});

  @override
  List<Object> get props => [mon];
}

class TuesdayChanged extends ProfileEvent {
  final String tue;

  TuesdayChanged({@required this.tue});

  @override
  List<Object> get props => [tue];
}

class WednesdayChanged extends ProfileEvent {
  final String wed;

  WednesdayChanged({@required this.wed});

  @override
  List<Object> get props => [wed];
}

class ThrusdayChanged extends ProfileEvent {
  final String thrus;

  ThrusdayChanged({@required this.thrus});

  @override
  List<Object> get props => [thrus];
}

class FridayChanged extends ProfileEvent {
  final String fri;

  FridayChanged({@required this.fri});

  @override
  List<Object> get props => [fri];
}

class SaturdayChanged extends ProfileEvent {
  final String sat;

  SaturdayChanged({@required this.sat});

  @override
  List<Object> get props => [sat];
}

class Submitted extends ProfileEvent {
  final String name,
      cusines,
      mealtype,
      outlettype,
      parking,
      paymentmethod,
      billingextra,
      location,
      phone,
      longitude,
      latitude,
      sunday,
      monday,
      tuesday,
      wednesday,
      thrusday,
      friday,
      saturday;
  final DateTime age;
  final File photo;
  //final Image photo;

  Submitted(
      {@required this.name,
      @required this.cusines,
      @required this.mealtype,
      @required this.outlettype,
      @required this.parking,
      @required this.paymentmethod,
      @required this.billingextra,
      @required this.age,
      @required this.location,
      @required this.phone,
      @required this.longitude,
      @required this.latitude,
      @required this.sunday,
      @required this.monday,
      @required this.tuesday,
      @required this.wednesday,
      @required this.thrusday,
      @required this.friday,
      @required this.saturday,
      @required this.photo});

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
        phone,
        longitude,
        latitude,
        sunday,
        monday,
        tuesday,
        wednesday,
        thrusday,
        friday,
        saturday,
        photo
      ];
}

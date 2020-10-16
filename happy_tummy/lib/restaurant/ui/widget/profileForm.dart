import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:geolocator/geolocator.dart';
import 'package:happy_tummy/restaurant/bloc/authentication/bloc.dart';
import 'package:happy_tummy/restaurant/bloc/profile/bloc.dart';
import 'package:happy_tummy/restaurant/repositories/restaurantRepository.dart';
import 'package:happy_tummy/restaurant/ui/widget/Selection.dart';
import 'package:image_picker/image_picker.dart';

import '../constants.dart';

class ProfileForm extends StatefulWidget {
  final RestaurantRepository _restaurantRepository;

  ProfileForm({@required RestaurantRepository restaurantRepository})
      : assert(restaurantRepository != null),
        _restaurantRepository = restaurantRepository;

  @override
  _ProfileFormState createState() => _ProfileFormState();
}

class _ProfileFormState extends State<ProfileForm> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _outlettypeController = TextEditingController();
  final TextEditingController _parkingController = TextEditingController();
  final TextEditingController _paymentmethodController =
      TextEditingController();
  final TextEditingController _billingextraController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _latController = TextEditingController();
  final TextEditingController _longController = TextEditingController();
  final TextEditingController _sunController = TextEditingController();
  final TextEditingController _monController = TextEditingController();
  final TextEditingController _tueController = TextEditingController();
  final TextEditingController _wedController = TextEditingController();
  final TextEditingController _thrusController = TextEditingController();
  final TextEditingController _friController = TextEditingController();
  final TextEditingController _satController = TextEditingController();

  String cusines, mealtype;
  DateTime age;
  File photo;
  ProfileBloc _profileBloc;

  getUserCurrentLocation () async {
    Position position = await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    List<Placemark> placeMarks = await Geolocator().placemarkFromCoordinates(position.latitude, position.longitude);
    Placemark mPlaceMark = placeMarks[0];
    String completeAddressInfo = '${mPlaceMark.subThoroughfare} ${mPlaceMark.thoroughfare},${mPlaceMark.subLocality} ${mPlaceMark.locality},${mPlaceMark.subAdministrativeArea} ${mPlaceMark.administrativeArea},${mPlaceMark.postalCode} ${mPlaceMark.country}';
    String SpecificAddress = '${mPlaceMark.locality}, ${mPlaceMark.country}';
    _locationController.text = SpecificAddress;
    _longController.text = position.longitude.toString();
    _latController.text = position.latitude.toString();
  }


  //UserRepository get _userRepository => widget._userRepository;

  bool get isFilled =>
      _nameController.text.isNotEmpty &&
      _outlettypeController.text.isNotEmpty &&
      _parkingController.text.isNotEmpty &&
      _paymentmethodController.text.isNotEmpty &&
      _billingextraController.text.isNotEmpty &&
      _locationController.text.isNotEmpty &&
      _latController.text.isNotEmpty &&
      _longController.text.isNotEmpty &&
      _phoneController.text.isNotEmpty &&
      _sunController.text.isNotEmpty &&
      _monController.text.isNotEmpty &&
      _tueController.text.isNotEmpty &&
      _wedController.text.isNotEmpty &&
      _thrusController.text.isNotEmpty &&
      _friController.text.isNotEmpty &&
      _satController.text.isNotEmpty &&
      cusines != null &&
      mealtype != null &&
      photo != null &&
      age != null;

  bool isButtonEnabled(ProfileState state) {
    return isFilled && !state.isSubmitting;
  }

  _onSubmitted() async {
    _profileBloc.add(
      Submitted(
          name: _nameController.text,
          location: _locationController.text,
          billingextra: _billingextraController.text,
          outlettype: _outlettypeController.text,
          parking: _parkingController.text,
          paymentmethod: _paymentmethodController.text,

          phone: _phoneController.text,
          longitude: _longController.text,
          latitude: _latController.text,
          sunday: _sunController.text,
          monday: _monController.text,
          tuesday: _tueController.text,
          thrusday: _thrusController.text,
          friday: _friController.text,
          saturday: _satController.text,
          wednesday: _wedController.text,

          age: age,
          photo: photo,
          cusines: cusines,
          mealtype: mealtype),
    );
  }

  @override
  void initState() {
    _profileBloc = BlocProvider.of<ProfileBloc>(context);
    super.initState();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _outlettypeController.dispose();
    _parkingController.dispose();
    _paymentmethodController.dispose();
    _billingextraController.dispose();
    _locationController.dispose();
    _longController.dispose();
    _latController.dispose();
    _phoneController.dispose();
    _sunController.dispose();
    _monController.dispose();
    _tueController.dispose();
    _wedController.dispose();
    _thrusController.dispose();
    _friController.dispose();
    _satController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return BlocListener<ProfileBloc, ProfileState>(
      //bloc: _profileBloc,
      listener: (context, state) {
        if (state.isFailure) {
          print("Failed");
          Scaffold.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text('Profile Creation Unsuccesful'),
                    Icon(Icons.error)
                  ],
                ),
              ),
            );
        }
        if (state.isSubmitting) {
          print("Submitting");
          Scaffold.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text('Submitting'),
                    CircularProgressIndicator()
                  ],
                ),
              ),
            );
        }
        if (state.isSuccess) {
          print("Success!");
          BlocProvider.of<AuthenticationBloc>(context).add(LoggedIn());
        }
      },
      child: BlocBuilder<ProfileBloc, ProfileState>(
        builder: (context, state) {
          return SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Container(
              color: backgroundColor,
              width: size.width,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    width: 200,
                    child: CircleAvatar(
                      radius: 40,
                      backgroundColor: Colors.transparent,
                      child: photo == null
                          ? GestureDetector(
                              onTap: () async {
                                print("click");
                                File getPic = await ImagePicker.pickImage(
                                  source: ImageSource.gallery,
                                );
                                //File getPic = await FilePicker.getFile();
                                if (getPic != null) {
                                  setState(() {
                                    photo = getPic;
                                  });
                                }
                              },
                              child: Image.asset('assets/images/noimage.png'),
                            )
                          : GestureDetector(
                              onTap: () async {
                                //File getPic = await FilePicker.getFile(type: FileType.image);
                                File getPic = await ImagePicker.pickImage(
                                  source: ImageSource.gallery,
                                );
                                if (getPic != null) {
                                  setState(() {
                                    photo = getPic;
                                  });
                                }
                              },
                              child: CircleAvatar(
                                radius: size.width * 0.3,
                                backgroundImage: FileImage(photo),
                              ),
                            ),
                    ),
                  ),
                  textFieldWidget(_nameController, "Name", size),
                  textFieldWidget(_outlettypeController, "Outlet Type", size),
                  textFieldWidget(_parkingController, "Parking", size),
                  textFieldWidget(
                      _paymentmethodController, "PaymentMethod", size),
                  textFieldWidget(
                      _billingextraController, "BillingExtra", size),
                  textFieldWidget(_locationController, "Location", size),
                  Container(
                    width: 220.0,
                    height: 50.0,
                    alignment: Alignment.topLeft,
                    child: RaisedButton.icon(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(35.0)),
                      color: Colors.black54,
                      icon: Icon(Icons.location_on,color: Colors.white,),
                      label: Text('Get Current Location',
                        style: TextStyle(color: Colors.white,fontFamily: "Lobster",fontSize: 20.0),
                      ),
                      onPressed: getUserCurrentLocation,
                    ),
                  ),
                  textFieldWidget(_phoneController, "Phone no", size),
                  Column(
                    children: [
                      Container( alignment: Alignment.topLeft,
                          padding: EdgeInsets.all(20),
                          child: Text(
                        'Opening Hours',
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      )),
                      Container(
                        margin: EdgeInsets.only(bottom: 20),
                        child: Column(
                          children: [
                            OpeningFieldWidget(_monController, "Monday", size),
                            OpeningFieldWidget(_tueController, "Tuesday", size),
                            OpeningFieldWidget(_wedController, "Wednesday", size),
                            OpeningFieldWidget(_thrusController, "Thrusday", size),
                            OpeningFieldWidget(_friController, "Friday", size),
                            OpeningFieldWidget(_satController, "Saturday", size),
                            OpeningFieldWidget(_sunController, "Sunday", size),
                          ],
                        ),
                      )
                    ],
                  ),
                  GestureDetector(
                    onTap: () {
                      DatePicker.showDatePicker(
                        context,
                        showTitleActions: true,
                        onConfirm: (date) {
                          print(date);
                          setState(() {
                            age = date;
                          });
                          print(age);
                        },
                      );
                    },
                    child: Text(
                      "Established Date",
                      style: TextStyle(color: Colors.white, fontSize: 26),
                    ),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: size.height * 0.02),
                        child: Text(
                          "Cusines",
                          style: TextStyle(color: Colors.white, fontSize: 26),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          selectionWidget("Bakery", size, cusines, () {
                            setState(() {
                              cusines = "Bakery";
                            });
                          }),
                          selectionWidget("Beverages", size, cusines, () {
                            setState(() {
                              cusines = "Beverages";
                            });
                          }),
                          selectionWidget("Indian", size, cusines, () {
                            setState(() {
                              cusines = "Indian";
                            });
                          }),
                          selectionWidget("Italian", size, cusines, () {
                            setState(() {
                              cusines = "Italian";
                            });
                          }),
                          selectionWidget(
                            "Chinese",
                            size,
                            cusines,
                            () {
                              setState(
                                () {
                                  cusines = "Chinese";
                                },
                              );
                            },
                          ),
                        ],
                      ),
                      SizedBox(
                        height: size.height * 0.02,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: size.height * 0.02),
                        child: Text(
                          "Meal Type",
                          style: TextStyle(color: Colors.white, fontSize: 26),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          selectionWidget("BreakFast", size, mealtype, () {
                            setState(() {
                              mealtype = "BreakFast";
                            });
                          }),
                          selectionWidget("Lunch", size, mealtype, () {
                            setState(() {
                              mealtype = "Lunch";
                            });
                          }),
                          selectionWidget("Cafe", size, mealtype, () {
                            setState(() {
                              mealtype = "Cafe";
                            });
                          }),
                          selectionWidget("Fastfood", size, mealtype, () {
                            setState(() {
                              mealtype = "Fastfood";
                            });
                          }),
                          selectionWidget(
                            "Dinner",
                            size,
                            mealtype,
                            () {
                              setState(
                                () {
                                  mealtype = "Dinner";
                                },
                              );
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: size.height * 0.02),
                    child: GestureDetector(
                      onTap: () {
                        if (isButtonEnabled(state)) {
                          _onSubmitted();
                        } else {}
                      },
                      child: Container(
                        width: 100,
                        height: 50,
                        decoration: BoxDecoration(
                          color:
                              isButtonEnabled(state) ? Colors.blue : Colors.red,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Center(
                            child: Text(
                          "Save",
                          style: TextStyle(
                              fontSize: 26,
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        )),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

Widget textFieldWidget(controller, text, size) {
  return Padding(
    padding: EdgeInsets.all(size.height * 0.02),
    child: TextField(
      style: TextStyle(color: Colors.white),
      controller: controller,
      decoration: InputDecoration(
        labelText: text,
        labelStyle:
            TextStyle(color: Colors.white, fontSize: size.height * 0.03),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white, width: 1.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white, width: 1.0),
        ),
      ),
    ),
  );
}


Widget OpeningFieldWidget(controller, text, size) {
  return Container(
    padding: EdgeInsets.all(size.height * 0.02),
    width: 300,
    height: 70,
    child: TextField(
      controller: controller,
      style: TextStyle(color: Colors.white),
      decoration: InputDecoration(fillColor: Colors.white,
        labelText: text,
        labelStyle:
        TextStyle(color: Colors.white, fontSize: size.height * 0.03),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white, width: 1.0,),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white, width: 1.0),
        ),
      ),
    ),
  );
}

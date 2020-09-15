import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:happy_tummy_web/bloc/authentication/bloc.dart';
import 'package:happy_tummy_web/bloc/profile/bloc.dart';
import 'package:happy_tummy_web/repositories/restaurantRepository.dart';
import 'package:happy_tummy_web/ui/widgets/Selection.dart';
import 'package:image_picker_web/image_picker_web.dart';

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

  String cusines, mealtype;
  DateTime age;
  File photo;
  ProfileBloc _profileBloc;

  //UserRepository get _userRepository => widget._userRepository;

  bool get isFilled =>
      _nameController.text.isNotEmpty &&
      _outlettypeController.text.isNotEmpty &&
      _parkingController.text.isNotEmpty &&
      _paymentmethodController.text.isNotEmpty &&
      _billingextraController.text.isNotEmpty &&
      _locationController.text.isNotEmpty &&
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
    super.dispose();
  }




  ///imagepicker
  ///
  ///
  //


  Image pickedImage;
  String videoSRC;
   pickImage() async {
    /// You can set the parameter asUint8List to true
    /// to get only the bytes from the image
    /* Uint8List bytesFromPicker =
        await ImagePickerWeb.getImage(outputType: ImageType.bytes);

    if (bytesFromPicker != null) {
      debugPrint(bytesFromPicker.toString());
    } */

    /// Default behavior would be getting the Image.memory
    Image fromPicker = await ImagePickerWeb.getImage(outputType: ImageType.widget);

    if (fromPicker != null) {
      setState(() {
        pickedImage = fromPicker;
      });
    }
  }

  pickVideo() async {
    final videoMetaData = await ImagePickerWeb.getVideo(outputType: VideoType.bytes);

    debugPrint('---Picked Video Bytes---');
    debugPrint(videoMetaData.toString());

    /// >>> Upload your video in Bytes now to any backend <<<
    /// >>> Disclaimer: local files are not working till now! [February 2020] <<<

    if (videoMetaData != null) {
      setState(() {
        videoSRC = 'https://sample-videos.com/video123/mp4/720/big_buck_bunny_720p_1mb.mp4';
      });
    }
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
                                File getPic = await FilePicker.getFile(
                                    type: FileType.image);
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
                                File getPic = await FilePicker.getFile(
                                    type: FileType.image);
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
                          color: isButtonEnabled(state)
                              ? Colors.white
                              : Colors.grey,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Center(
                            child: Text(
                          "Save",
                          style: TextStyle(fontSize: 26, color: Colors.blue),
                        )),
                      ),
                    ),
                  ),


//photo picker

Center(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  AnimatedSwitcher(
                    duration: Duration(milliseconds: 300),
                    switchInCurve: Curves.easeIn,
                    child: SizedBox(
                          width: 200,
                          child: pickedImage,
                        ) ??
                        Container(),
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  
                ],
              ),
              ButtonBar(alignment: MainAxisAlignment.center, children: <Widget>[
                RaisedButton(
                  onPressed: () => pickImage(),
                  child: Text('Select Image'),
                ),
                RaisedButton(
                  onPressed: () => pickVideo(),
                  child: Text('Select Video'),
                ),
              ]),
            ])),

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

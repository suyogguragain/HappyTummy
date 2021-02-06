import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class Checkout extends StatefulWidget {
  final String currentuserid;
  final String restaurantid;

  Checkout({this.currentuserid, this.restaurantid});

  @override
  _CheckoutState createState() => _CheckoutState();
}

class _CheckoutState extends State<Checkout> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _validate = false;
  bool uploading = false;
  String postId = Uuid().v4();
  TextEditingController personnameTextEditingController =
      TextEditingController();
  TextEditingController addressTextEditingController = TextEditingController();
  TextEditingController phonenumberTextEditingController =
      TextEditingController();

  bool validateTextField(String userInput) {
    if (userInput.isEmpty) {
      setState(() {
        _validate = true;
      });
      return false;
    }
    setState(() {
      _validate = false;
    });
    return true;
  }

  bool validatePhone(String userInput) {
    if (userInput.isNotEmpty && userInput.length == 10) {
      setState(() {
        _validate = false;
      });
      return true;
    }
    setState(() {
      _validate = true;
    });
    return false;
  }

  deleteTask(String restaurantId, String currentuserId) {
    Firestore.instance
        .collection("foodcart")
        .document(currentuserId)
        .collection('Cart')
        .document(restaurantId)
        .collection("foodlist")
        .getDocuments()
        .then((snapshot) {
      for (DocumentSnapshot ds in snapshot.documents) {
        ds.reference.delete();
      }
    });
  }

  controlUploadAndSave() async {
    setState(() {
      uploading = true;
    });

    saveCheckoutInfoToFireStore(
        name: personnameTextEditingController.text,
        address: addressTextEditingController.text,
        phone: phonenumberTextEditingController.text);


    personnameTextEditingController.clear();
    addressTextEditingController.clear();
    phonenumberTextEditingController.clear();

    setState(() {
      uploading = false;
      postId = Uuid().v4();
    });
  }

  saveCheckoutInfoToFireStore({String name, String address, String phone}) {
    Firestore.instance
        .collection('order')
        .document(widget.restaurantid)
        .collection('checkout')
        .document(widget.currentuserid)
        .collection('address')
        .document(postId)
        .setData({
      'addressId': postId,
      'timestamp': DateTime.now(),
      'username': name,
      'address': address,
      'phone': phone,
    });

    Firestore.instance
        .collection('order')
        .document(widget.restaurantid)
        .collection('userlist')
        .document(widget.currentuserid)
        .setData({
      'rId': widget.restaurantid,
      'timestamp': DateTime.now(),
      'uId': widget.currentuserid,
      'profileName': name
    });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(
          "CheckOut",
        ),
        backgroundColor: Colors.black,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Price',
                            style: TextStyle(
                              fontSize: 25.0,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 2,
                            )),
                        Text('  ',
                            style: TextStyle(
                              fontSize: 15.0,
                              fontWeight: FontWeight.w300,
                              letterSpacing: 0.5,
                            )),
                      ],
                    ),
                    width: 140,
                    height: 130,
                    margin: EdgeInsets.all(20.0),
                    decoration: BoxDecoration(
                      color: Colors.teal[50],
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Quantity',
                            style: TextStyle(
                              fontSize: 25.0,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 2,
                            )),
                        Text(' ',
                            style: TextStyle(
                              fontSize: 15.0,
                              fontWeight: FontWeight.w300,
                              letterSpacing: 0.5,
                            )),
                      ],
                    ),
                    width: 140,
                    height: 130,
                    margin: EdgeInsets.all(20.0),
                    decoration: BoxDecoration(
                      color: Colors.teal[50],
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ],
            ),
            Container(
              width: 300,
              height: 350,
              decoration: BoxDecoration(
                color: Colors.teal[50],
                borderRadius: BorderRadius.circular(15),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    TextField(
                      decoration: InputDecoration(
                          hintText: "Your Name",
                          labelText: "Name",
                          prefixIcon: Icon(
                            Icons.person,
                            color: Colors.black45,
                          ),
                          errorText:
                              _validate ? 'Please enter a Username' : null,
                          labelStyle:
                              TextStyle(fontSize: 20, color: Colors.blueGrey),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                          )),
                      maxLength: 40,
                      controller: personnameTextEditingController,
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    TextField(
                      decoration: InputDecoration(
                          errorText:
                              _validate ? 'Please enter a Address' : null,
                          hintText: "Your Address",
                          labelText: "Address",
                          prefixIcon: Icon(Icons.location_city),
                          labelStyle:
                              TextStyle(fontSize: 20, color: Colors.blueGrey),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                          )),
                      maxLength: 40,
                      maxLines: 1,
                      controller: addressTextEditingController,
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    TextField(
                      decoration: InputDecoration(
                          hintText: "Contact Number",
                          labelText: "Number",
                          errorText: _validate ? 'Value Can\'t Be Empty' : null,
                          prefixIcon: Icon(Icons.phone),
                          labelStyle:
                              TextStyle(fontSize: 20, color: Colors.blueGrey),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                          )),
                      keyboardType: TextInputType.number,
                      maxLength: 10,
                      controller: phonenumberTextEditingController,
                    ),
                    FlatButton(
                        onPressed: () {
                          setState(() {
                            validateTextField(
                                personnameTextEditingController.text);
                            validateTextField(
                                addressTextEditingController.text);
                            validatePhone(
                                phonenumberTextEditingController.text);
                          });
                          if (validateTextField(
                                      personnameTextEditingController.text) ==
                                  true &&
                              validateTextField(
                                      addressTextEditingController.text) ==
                                  true &&
                              validatePhone(
                                      phonenumberTextEditingController.text) ==
                                  true) {
                            controlUploadAndSave();
                            deleteTask(
                                widget.restaurantid, widget.currentuserid);
                            //Navigator.pop(context);
                          }

                          print("okay");
                          setState(() {
                            final snackBar = SnackBar(
                              backgroundColor: Colors.black,
                              content: Text(
                                'Your Order Has Been Placed Into Restaurant.',
                                style: TextStyle(color: Colors.white),
                              ),
                            );
                            _scaffoldKey.currentState.showSnackBar(snackBar);
                          });
                        },
                        color: Colors.lightGreenAccent,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0),
                            side: BorderSide(color: Colors.blueGrey)),
                        child: Text(
                          "Place Order",
                          style: TextStyle(
                              fontSize: 25, fontWeight: FontWeight.bold),
                        ))
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

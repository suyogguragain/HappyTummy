import 'package:flutter/material.dart';
import 'package:happy_tummy_web/authentication/auth_service.dart';
import 'package:happy_tummy_web/authentication/login.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  String email, password, password1;

  final formKey = new GlobalKey<FormState>();

  checkFields() {
    final form = formKey.currentState;
    if (form.validate()) {
      return true;
    } else {
      return false;
    }
  }

  String validateEmail(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value))
      return 'Enter Valid Email';
    else
      return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[50],
      body: Padding(
        padding:
            EdgeInsets.only(top: 60.0, bottom: 60.0, left: 120.0, right: 120.0),
        child: Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(40.0)),
          elevation: 5.0,
          child: Container(
            child: Row(
              children: <Widget>[
                Container(
                  width: MediaQuery.of(context).size.width / 3.3,
                  height: MediaQuery.of(context).size.height,
                  color: Colors.pinkAccent,
                  child: Padding(
                    padding:
                        EdgeInsets.only(top: 85.0, right: 50.0, left: 50.0),
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Column(
                        children: <Widget>[
                          SizedBox(
                            height: 60.0,
                          ),
                          Container(
                            padding: EdgeInsets.only(top: 5.0, bottom: 5.0),
                            child: Text(
                              "Let's get you set up",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 30.0,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 5.0,
                          ),
                          Container(
                            padding: EdgeInsets.only(top: 5.0, bottom: 5.0),
                            child: Text(
                              "It should only take a couple of minutes to create your account",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18.0,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          SizedBox(
                            height: 50.0,
                          ),
                          FlatButton(
                            color: Colors.lightBlue,
                            onPressed: () {
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) {
                                return new Login();
                              }));
                            },
                            child: Text(
                              "Login",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(
                      top: 140.0, right: 70.0, left: 70.0, bottom: 10.0),
                  child: Column(
                    children: <Widget>[
                      Form(
                        key: formKey,
                        child: Column(
                          children: <Widget>[
                            Text(
                              "Sign Up",
                              style: TextStyle(
                                  color: Colors.lightBlue,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 35.0,
                                  fontFamily: 'Merriweather'),
                            ),
                            const SizedBox(height: 21.0),

                            //email
                            LayoutBuilder(
                              builder: (BuildContext context,
                                  BoxConstraints constraints) {
                                return Row(
                                  children: <Widget>[
                                    Container(
                                      width: 80.0,
                                      child: Text(
                                        "Email",
                                        textAlign: TextAlign.left,
                                        style:
                                            TextStyle(color: Colors.pinkAccent),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 40.0,
                                    ),
                                    Container(
                                      width: MediaQuery.of(context).size.width /
                                          3.7,
                                      color: Colors.blue[50],
                                      child: TextFormField(
                                        style: TextStyle(
                                          fontSize: 15.0,
                                        ),
                                        decoration: InputDecoration(
                                          contentPadding: EdgeInsets.all(10.0),
                                          border: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: Colors.blue[50],
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(5.0),
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: Colors.blue[50],
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(5.0),
                                          ),
                                          hintText: "Email",
                                          fillColor: Colors.blue[50],
                                        ),
                                        onChanged: (value) {
                                          this.email = value;
                                        },
                                        validator: (value) => value.isEmpty
                                            ? 'Email is required'
                                            : validateEmail(value.trim()),
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ),

                            SizedBox(height: 20.0),

                            //Password
                            LayoutBuilder(
                              builder: (BuildContext context,
                                  BoxConstraints constraints) {
                                return Row(
                                  children: <Widget>[
                                    Container(
                                      width: 80.0,
                                      child: Text(
                                        "Password",
                                        textAlign: TextAlign.left,
                                        style:
                                            TextStyle(color: Colors.pinkAccent),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 40.0,
                                    ),
                                    Container(
                                      width: MediaQuery.of(context).size.width /
                                          3.7,
                                      color: Colors.blue[50],
                                      child: TextFormField(
                                        obscureText: true,
                                        style: TextStyle(
                                          fontSize: 15.0,
                                        ),
                                        decoration: InputDecoration(
                                          contentPadding: EdgeInsets.all(10.0),
                                          border: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: Colors.blue[50],
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(5.0),
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: Colors.blue[50],
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(5.0),
                                          ),
                                          hintText: "Password",
                                          fillColor: Colors.blue[50],
                                        ),
                                        onChanged: (value) {
                                          this.password = value;
                                        },
                                        validator: (value) => value.isEmpty
                                            ? 'Password is required'
                                            : null,
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ),

                            SizedBox(height: 20.0),

                            LayoutBuilder(
                              builder: (BuildContext context,
                                  BoxConstraints constraints) {
                                return Row(
                                  children: <Widget>[
                                    Container(
                                      width: 80.0,
                                      child: Text(
                                        "Confirm Password",
                                        textAlign: TextAlign.left,
                                        style:
                                            TextStyle(color: Colors.pinkAccent),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 40.0,
                                    ),
                                    Container(
                                      width: MediaQuery.of(context).size.width /
                                          3.7,
                                      color: Colors.blue[50],
                                      child: TextFormField(
                                        obscureText: true,
                                        style: TextStyle(
                                          fontSize: 15.0,
                                        ),
                                        decoration: InputDecoration(
                                          contentPadding: EdgeInsets.all(10.0),
                                          border: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: Colors.blue[50],
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(5.0),
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: Colors.blue[50],
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(5.0),
                                          ),
                                          hintText: "Password",
                                          fillColor: Colors.blue[50],
                                        ),
                                        onChanged: (value) {
                                          this.password1 = value;
                                        },
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ),

                            SizedBox(
                              height: 40.0,
                            ),

                            Row(
                              children: <Widget>[
                                SizedBox(
                                  width: 170.0,
                                ),
                                FlatButton(
                                  color: Colors.grey[200],
                                  onPressed: () {},
                                  child: Text("Cancel"),
                                ),
                                SizedBox(
                                  width: 20.0,
                                ),
                                FlatButton(
                                  color: Colors.lightBlue,
                                  onPressed: () {
                                    if (checkFields()) {
                                      AuthService().createUser(email, password);
                                    }
                                  },
                                  child: Text(
                                    "Create Account",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

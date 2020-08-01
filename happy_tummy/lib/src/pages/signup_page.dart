import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:happy_tummy/src/pages/TopLevelPage.dart';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {

  final _auth = FirebaseAuth.instance;
  String email;
  String password;
  String username;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[

              //just for vertical spacing
              SizedBox(
                height: 60,
                width: 200,
              ),

              Text('Sign Up',style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 32.0),),

              //just for vertical spacing
              SizedBox(
                height: 40,
                width: 10,
              ),

              //container for textfields user name and password
              Container(
                height: 240,
                width: 350,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(30)),
                    color: Colors.white
                ),

                child: Column(
                  children: <Widget>[
                    TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      textAlign: TextAlign.left,
                      onChanged:(value){
                        email = value;
                        },
                      decoration: InputDecoration(border: InputBorder.none,
                          hintText: "Email",
                          contentPadding: EdgeInsets.all(20)),
                    ),

                    Divider(),

                    TextFormField(
                      textAlign: TextAlign.left,
                      obscureText: true,
                      onChanged:(value){
                        password = value;
                      },
                      decoration: InputDecoration(border: InputBorder.none,
                          hintText: "Password",
                          contentPadding: EdgeInsets.all(20)),
                    )
                  ],
                ),
              ),

              //container for raised button
              Container(
                width: 350,
                height: 70,
                padding: EdgeInsets.only(top: 20),
                child: RaisedButton(
                  color: Colors.pink,
                  child: Text("Sign In", style: TextStyle(color: Colors.white),),
                  shape: RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(30),
                  ),
                  onPressed: () async {
                    try{
                      final newUser = await _auth.createUserWithEmailAndPassword(email: email, password: password);
                      if (newUser != null){
                        setState(() {
                          Navigator.of(context).pushReplacement(MaterialPageRoute(
                              builder: (BuildContext context) => TopLevelPage()));
                        });
                      }
                    }catch(e){
                      print(e);
                    }
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

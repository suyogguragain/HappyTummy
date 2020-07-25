import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

import 'signup_page.dart';

class SignInPage extends StatefulWidget {
  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final _auth = FirebaseAuth.instance;
  bool showSpinner = false;

//  String pass = "admin";
  String email;
  String password;

  String animationType = "idle";

//  final passwordController = TextEditingController();
  final passwordFocusNode = FocusNode();


  @override
  void initState() {
    // TODO: implement initState
    passwordFocusNode.addListener((){
      if(passwordFocusNode.hasFocus){
        setState(() {
          animationType="test";
        });
      }else{
        setState(() {
          animationType="idle";
        });
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: ListView(
          children: <Widget>[
            Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[

              //just for vertical spacing
              SizedBox(
                height: 50,
                width: 200,
              )    ,


              //space for teddy actor
              Center(
                child: Container(
                    height: 250,
                    width: 300,

                    child: CircleAvatar(
                      child: ClipOval(
                        child: new FlareActor("assets/teddy_test.flr", alignment: Alignment.center, fit: BoxFit.contain, animation: animationType,),
                      ),
                      backgroundColor: Colors.black45,
                    )

                ),
              ),


              //just for vertical spacing
              SizedBox(
                height: 20,
                width: 10,
              )    ,


              //container for textfields user name and password
              Container(
                height: 140,
                width: 350,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(30)),
                    color: Colors.white
                ),

                child: Column(
                  children: <Widget>[

                    TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      textAlign: TextAlign.center,
                      onChanged:(value){
                        email = value;
                      },
                      decoration: InputDecoration(border: InputBorder.none, hintText: "Email", contentPadding: EdgeInsets.all(20)),
                    ),

                    Divider(),

                    TextFormField(
                      textAlign: TextAlign.center,
                      onChanged:(value){
                        password = value;
                      },
                      obscureText: true,
                      decoration: InputDecoration(border: InputBorder.none, hintText: "Password", contentPadding: EdgeInsets.all(20)),
//                    controller: passwordController,
                      focusNode: passwordFocusNode,
                    ),

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
                    child: Text("Submit", style: TextStyle(color: Colors.white),),

                    shape: RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(30),
                    ),
                    onPressed: () async {
                      setState(() {
                        showSpinner = true;
                      });
                      try{
                        final user = await _auth.signInWithEmailAndPassword(email: email, password: password);
                        if (user != null){
                          setState(() {
                            Navigator.of(context).pop();
                            Navigator.of(context).pushNamed("/mainscreen");
                          });
                          setState(() {
                            animationType = "success";
                            showSpinner = false;
                          });
                        }else{
                          setState(() {
                            showSpinner = false;
                            animationType = "fail";
                          });
                        }
                      }catch(e){
                        print(e);
                      }

//                    if(passwordController.text.compareTo(pass) == 0){
//                      setState(() {
//                        animationType = "success";
//                        Navigator.of(context).pop();
//                        Navigator.of(context).pushNamed("/mainscreen");
//
//                      });
//
//                    }else{
//                      setState(() {
//                        animationType = "fail";
//                      });
//
//                    }
//
                    },
                ),
              ),
              Center(
                child: Divider(
                  height: 30.0,
                  thickness: 3.0,
                  indent: 80,
                  endIndent:80 ,
                ),
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    "Don't have an account?",
                    style: TextStyle(
                        color: Color(0xFFBDC2CB),
                        fontWeight: FontWeight.bold,
                        fontSize: 18.0),
                  ),
                  SizedBox(width: 10.0),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (BuildContext context) => SignUpPage()));
                    },
                    child: Text(
                      "Sign up",
                      style: TextStyle(
                          color: Colors.blueAccent,
                          fontWeight: FontWeight.bold,
                          fontSize: 18.0),
                    ),
                  ),
                ],
              ),


            ],
          ),
        ],
        ),
      ),
    );
  }
}

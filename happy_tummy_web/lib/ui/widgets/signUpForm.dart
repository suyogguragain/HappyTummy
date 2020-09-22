import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:happy_tummy_web/bloc/authentication/authentication_bloc.dart';
import 'package:happy_tummy_web/bloc/authentication/authentication_event.dart';
import 'package:happy_tummy_web/bloc/signup/bloc.dart';
import 'package:happy_tummy_web/repositories/restaurantRepository.dart';
import 'package:happy_tummy_web/ui/pages/login.dart';

class SignUpForm extends StatefulWidget {
  final RestaurantRepository _restaurantRepository;

  SignUpForm({@required RestaurantRepository restaurantRepository})
      : assert(restaurantRepository != null),
        _restaurantRepository = restaurantRepository;

  @override
  _SignUpFormState createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  SignUpBloc _signUpBloc;
  RestaurantRepository get _restaurantRepository => widget._restaurantRepository;

  bool get isPopulated =>
      _emailController.text.isNotEmpty && _passwordController.text.isNotEmpty;

  bool isSignUpButtonEnabled(SignUpState state) {
    return isPopulated && !state.isSubmitting;
  }

  @override
  void initState() {
    _signUpBloc = BlocProvider.of<SignUpBloc>(context);

    _emailController.addListener(_onEmailChanged);
    _passwordController.addListener(_onPasswordChanged);

    super.initState();
  }

  void _onFormSubmitted() {
    _signUpBloc.add(
      SignUpWithCredentialsPressed(
          email: _emailController.text, password: _passwordController.text),
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return BlocListener<SignUpBloc, SignUpState>(
      listener: (BuildContext context, SignUpState state) {
        if (state.isFailure) {
          Scaffold.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text("Sign Up Failed"),
                    Icon(Icons.error),
                  ],
                ),
              ),
            );
        }
        if (state.isSubmitting) {
          print("isSubmitting");
          Scaffold.of(context)
            ..showSnackBar(
              SnackBar(
                content: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text("Signing up..."),
                    CircularProgressIndicator(),
                  ],
                ),
              ),
            );
        }
        if (state.isSuccess) {
          print("Success");
          BlocProvider.of<AuthenticationBloc>(context).add(LoggedIn());
          Navigator.of(context).pop();
        }
      },
      child: BlocBuilder<SignUpBloc, SignUpState>(
        builder: (context, state) {
          return SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Padding(
              padding: EdgeInsets.only(
                  top: 20.0, bottom: 20.0, left: 120.0, right: 120.0),
              child: Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(40.0)),
                elevation: 5.0,
                child: Container(
                  color: Colors.white,
                  width: size.width,
                  height: 550,
                  child: Row(
                    children: <Widget>[
                      Container(
                        width: MediaQuery.of(context).size.width / 3.3,
                        height: MediaQuery.of(context).size.height,
                        color: Colors.pinkAccent,
                        child: Padding(
                          padding: EdgeInsets.only(
                              top: 85.0, right: 50.0, left: 50.0),
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: Column(
                              children: <Widget>[
                                SizedBox(
                                  height: 60.0,
                                ),
                                Container(
                                  padding:
                                      EdgeInsets.only(top: 5.0, bottom: 5.0),
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
                                  padding:
                                      EdgeInsets.only(top: 5.0, bottom: 5.0),
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
                                      return Login(restaurantRepository: _restaurantRepository,);
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
                        child: Column(children: <Widget>[
                          Text(
                            "Happy Tummy",
                            style: TextStyle(
                                color: Colors.lightBlue,
                                fontWeight: FontWeight.w600,
                                fontSize: 35.0,
                                fontFamily: 'Merriweather'),
                          ),
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
                                    width:
                                        MediaQuery.of(context).size.width / 3.7,
                                    color: Colors.blue[50],
                                    child: TextFormField(
                                      controller: _emailController,
                                      autovalidate: true,
                                      validator: (_) {
                                        return !state.isEmailValid
                                            ? "Invalid Email"
                                            : null;
                                      },
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
                                    width:
                                        MediaQuery.of(context).size.width / 3.7,
                                    color: Colors.blue[50],
                                    child: TextFormField(
                                      controller: _passwordController,
                                      autocorrect: false,
                                      obscureText: true,
                                      autovalidate: true,
                                      validator: (_) {
                                        return !state.isPasswordValid
                                            ? "Invalid Password"
                                            : null;
                                      },
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
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                          SizedBox(height: 20.0),
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
                              GestureDetector(
                                onTap: isSignUpButtonEnabled(state)
                                    ? _onFormSubmitted
                                    : null,
                                child: Container(
                                  width: 100,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    color: isSignUpButtonEnabled(state)
                                        ? Colors.lightBlue
                                        : Colors.grey,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Center(
                                    child: Text(
                                      "Sign Up",
                                      style: TextStyle(
                                          fontSize: 15, color: Colors.white),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ]),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void _onEmailChanged() {
    _signUpBloc.add(
      EmailChanged(email: _emailController.text),
    );
  }

  void _onPasswordChanged() {
    _signUpBloc.add(
      PasswordChanged(password: _passwordController.text),
    );
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _emailController.dispose();

    super.dispose();
  }
}

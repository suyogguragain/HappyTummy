import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:happy_tummy/restaurant/bloc/authentication/bloc.dart';
import 'package:happy_tummy/restaurant/bloc/login/bloc.dart';
import 'package:happy_tummy/restaurant/repositories/restaurantRepository.dart';
import 'package:happy_tummy/restaurant/ui/pages/SignUp.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

import '../constants.dart';

class LoginForm extends StatefulWidget {
  final RestaurantRepository _restaurantRepository;

  LoginForm({@required RestaurantRepository restaurantRepository})
      : assert(restaurantRepository != null),
        _restaurantRepository = restaurantRepository;

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  LoginBloc _loginBloc;
  bool showSpinner = false;
  String animationType = "idle";

  RestaurantRepository get _restaurantRepository =>
      widget._restaurantRepository;

  bool get isPopulated =>
      _emailController.text.isNotEmpty && _passwordController.text.isNotEmpty;

  bool isLoginButtonEnabled(LoginState state) {
    return isPopulated && !state.isSubmitting;
  }

  @override
  void initState() {
    _loginBloc = BlocProvider.of<LoginBloc>(context);

    _emailController.addListener(_onEmailChanged);
    _passwordController.addListener(_onPasswordChanged);

    super.initState();
  }

  void _onEmailChanged() {
    _loginBloc.add(
      EmailChanged(email: _emailController.text),
    );
  }

  void _onPasswordChanged() {
    _loginBloc.add(
      PasswordChanged(password: _passwordController.text),
    );
  }

  void _onFormSubmitted() {
    _loginBloc.add(
      LoginWithCredentialsPressed(
          email: _emailController.text, password: _passwordController.text),
    );
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _emailController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return BlocListener<LoginBloc, LoginState>(
      listener: (context, state) {
        if (state.isFailure) {
          Scaffold.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text("Login Failed"),
                    Icon(Icons.error),
                  ],
                ),
              ),
            );
        }

        if (state.isSubmitting) {
          print("isSubmitting");
          Scaffold.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(" Logging In..."),
                    CircularProgressIndicator(),
                  ],
                ),
              ),
            );
        }

        if (state.isSuccess) {
          print("Success");
          BlocProvider.of<AuthenticationBloc>(context).add(LoggedIn());
        }
      },
      child: BlocBuilder<LoginBloc, LoginState>(
        builder: (context, state) {
          return SingleChildScrollView(
            child: Container(
              color: backgroundColor,
              width: size.width,
              height: size.height,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    height: 220,
                    width: 370,
                    child: ModalProgressHUD(
                      inAsyncCall: showSpinner,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          //space for teddy actor
                          Center(
                            child: Container(
                              height: 210,
                              width: 300,
                              child: CircleAvatar(
                                child: ClipOval(
                                  child: new FlareActor(
                                    "assets/teddy_test.flr",
                                    alignment: Alignment.center,
                                    fit: BoxFit.contain,
                                    animation: animationType,
                                  ),
                                ),
                                backgroundColor: Colors.grey,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Center(
                    child: Text(
                      "Happy Tummy",
                      style: TextStyle(fontSize: 32, color: Colors.white,fontFamily: 'Lobster'),
                    ),
                  ),
                  Container(
                    width: size.width * 0.8,
                    child: Divider(
                      height: size.height * 0.05,
                      color: Colors.white,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(size.height * 0.02),
                    child: TextFormField(
                      cursorColor: Colors.white,
                      style: TextStyle(color: Colors.white),
                      controller: _emailController,
                      autovalidate: false,
                      validator: (_) {
                        return !state.isEmailValid ? "Invalid Email" : null;
                      },
                      decoration: InputDecoration(
                        labelText: "Email",
                        labelStyle: TextStyle(
                            color: Colors.white, fontSize: size.height * 0.03),
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.white, width: 1.0,),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.white, width: 1.0),
                        ),
                        fillColor: Colors.white,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(size.height * 0.02),
                    child: TextFormField(
                      controller: _passwordController,
                      cursorColor: Colors.white,
                      style: TextStyle(color: Colors.white),
                      autocorrect: false,
                      obscureText: true,
                      autovalidate: true,
                      validator: (_) {
                        return !state.isPasswordValid
                            ? "Invalid Password"
                            : null;
                      },
                      decoration: InputDecoration(
                        labelText: "Password",
                        labelStyle: TextStyle(
                            color: Colors.white, fontSize: size.height * 0.03),
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.white, width: 1.0),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.white, width: 1.0),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(size.height * 0.02),
                    child: Column(
                      children: <Widget>[
                        GestureDetector(
                          onTap: isLoginButtonEnabled(state)
                              ? _onFormSubmitted
                              : null,
                          child: Container(
                            width: size.width * 0.8,
                            height: size.height * 0.06,
                            decoration: BoxDecoration(
                              color: isLoginButtonEnabled(state)
                                  ? Colors.blueAccent
                                  : Colors.redAccent,
                              borderRadius:
                                  BorderRadius.circular(size.height * 0.05),
                            ),
                            child: Center(
                              child: Text(
                                "Login",
                                style: TextStyle(
                                    fontSize: size.height * 0.025,
                                    color: Colors.white,fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: size.height * 0.02,
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) {
                                  return SignUp(
                                    restaurantRepository: _restaurantRepository,
                                  );
                                },
                              ),
                            );
                          },
                          child: Text(
                            "Are you new? Get an Account",
                            style: TextStyle(
                                fontSize: size.height * 0.025,
                                color: Colors.white),
                          ),
                        )
                      ],
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

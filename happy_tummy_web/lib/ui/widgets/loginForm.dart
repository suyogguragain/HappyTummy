import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:happy_tummy_web/bloc/authentication/bloc.dart';
import 'package:happy_tummy_web/bloc/login/bloc.dart';
import 'package:happy_tummy_web/repositories/restaurantRepository.dart';
import 'package:happy_tummy_web/ui/pages/SignUp.dart';

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
                                    "Go ahead and Login",
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
                                    "It should only take a couple of minutes to login to your account",
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
                                      return SignUp(restaurantRepository: _restaurantRepository);
                                    }));
                                  },
                                  child: Text(
                                    "SignUp",
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
                                onTap: isLoginButtonEnabled(state)
                                    ? _onFormSubmitted
                                    : null,
                                child: Container(
                                  width: 100,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    color: isLoginButtonEnabled(state)
                                        ? Colors.white
                                        : Colors.grey,
                                    borderRadius: BorderRadius.circular(
                                        size.height * 0.05),
                                  ),
                                  child: Center(
                                    child: Text(
                                      "Login",
                                      style: TextStyle(
                                          fontSize: size.height * 0.025,
                                          color: Colors.blue),
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
}

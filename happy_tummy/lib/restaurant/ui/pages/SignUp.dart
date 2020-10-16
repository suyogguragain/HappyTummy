import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:happy_tummy/restaurant/bloc/signup/bloc.dart';
import 'package:happy_tummy/restaurant/repositories/restaurantRepository.dart';
import 'package:happy_tummy/restaurant/ui/widget/signUpForm.dart';
import 'package:url_launcher/url_launcher.dart';

import '../constants.dart';

class SignUp extends StatelessWidget {
  final RestaurantRepository _restaurantRepository;

  SignUp({@required RestaurantRepository restaurantRepository})
      : assert(restaurantRepository != null),
        _restaurantRepository = restaurantRepository;

  Widget buildButton({
    @required String text,
    @required VoidCallback onClicked,
  }) =>
      Container(
        padding: EdgeInsets.symmetric(vertical: 12),
        child: RaisedButton(
          shape: StadiumBorder(),
          onPressed: onClicked,
          color: Colors.grey,
          textColor: Colors.white,
          child: Text(
            text,
            style: TextStyle(fontSize: 22),
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Sign Up",
          style: TextStyle(
              fontSize: 36.0, fontFamily: 'Lobster', color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: backgroundColor,
        elevation: 0,
      ),
//      body: BlocProvider<SignUpBloc>(
//        create: (context) => SignUpBloc(
//          restaurantRepository: _restaurantRepository,
//        ),
//        child: SignUpForm(
//          restaurantRepository: _restaurantRepository,
//        ),
//      ),
      body: Container(
        color: Colors.black,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 100),
              child: Column(
                children: [
                  Container(
                    child: CircleAvatar(
                      radius: 65,
                      backgroundColor: Colors.grey,
                      child: CircleAvatar(
                        radius: 60,
                        backgroundImage: AssetImage('assets/images/ht.png'),
                      ),
                    ),
                  ),
                  Center(
                    child: Text(
                      "Happy Tummy",
                      style: TextStyle(
                          fontSize: 32,
                          color: Colors.white,
                          fontFamily: 'Lobster'),
                    ),
                  ),
                ],
              ),
            ),
            buildButton(
              text: 'Open Email',
              onClicked: () => Utils.openEmail(
                toEmail: 'happytummy@gmail.com',
                subject: 'Register Email',
                body: 'Your email!!!',
              ),
            ),

          ],
        ),
      ),
    );
  }
}

class Utils {

  static Future openEmail({
    @required String toEmail,
    @required String subject,
    @required String body,
  }) async {
    final url =
        'mailto:$toEmail?subject=${Uri.encodeFull(subject)}&body=${Uri.encodeFull(body)}';

    await _launchUrl(url);
  }

  static Future _launchUrl(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    }
  }
}

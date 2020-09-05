import 'package:flutter/material.dart';
import 'package:happy_tummy_web/website/sections/topSection/components/glass_content.dart';

class LogoAndBlurBox extends StatelessWidget {
  const LogoAndBlurBox({
    Key key,
    @required this.size,
  }) : super(key: key);

  final Size size;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CircleAvatar(
          radius: 60,
          backgroundImage: AssetImage("assets/images/ht.png"),//Image.asset("assets/images/ht.png"),
        ),
        Spacer(),
        GlassContent(size: size),
        Spacer(flex: 3),
      ],
    );
  }
}

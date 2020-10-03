import 'package:flutter/material.dart';

Widget selectionWidget(text, size, selected, onTap) {
  return GestureDetector(
    onTap: onTap,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Text(
          text,
          style: TextStyle(
            color: selected == text ? Colors.blue : Colors.red,
          ),
        )
      ],
    ),
  );
}

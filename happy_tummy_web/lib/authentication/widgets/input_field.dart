import 'package:flutter/material.dart';

class InputField extends StatefulWidget {
  final String label;
  final String content;
  final Function validator;
  final Function onchanged;

  InputField({this.label, this.content, this.validator, this.onchanged});

  @override
  _InputFieldState createState() => _InputFieldState();
}

class _InputFieldState extends State<InputField> {

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return Row(
          children: <Widget>[
            Container(
              width: 80.0,
              child: Text(
                "${widget.label}",
                textAlign: TextAlign.left,
                style: TextStyle(
                        color: Colors.pinkAccent
                      ),
              ),
            ),
            SizedBox(
              width: 40.0,
            ),
            Container(
              width: MediaQuery.of(context).size.width / 3.7,
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
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.blue[50],
                    ),
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  hintText: "${widget.content}",
                  fillColor: Colors.blue[50],
                ),
              
              ),
            ),
          ],
        );
      },
    );
  }
}

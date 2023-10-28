import 'package:flutter/material.dart';

class ProductInputField extends StatefulWidget {
  String hintText;

 ProductInputField({ required this.hintText,});

  @override
  State<ProductInputField> createState() => _ProductInputFieldState();
}

class _ProductInputFieldState extends State<ProductInputField> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 47,
      child: TextField(
        

          cursorColor: Colors.black,
          decoration: InputDecoration(
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Colors.black)),
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Colors.black.withOpacity(0.7))),
              hintText: widget.hintText,
              fillColor: Colors.yellowAccent[200],
              filled: true)),
    );
  }
}

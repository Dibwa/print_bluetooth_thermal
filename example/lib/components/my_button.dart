import 'package:flutter/material.dart';

class MyButton extends StatefulWidget {
  String lable;
  bool isLoading = false;
  
  Color buttoncolor;

  final Function()? buttonFunction;
  MyButton(
      {super.key,
      required this.lable,
      required this.buttonFunction,
      required this.isLoading, required this.buttoncolor});

  @override
  State<MyButton> createState() => _MyButtonState();
}

class _MyButtonState extends State<MyButton> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.buttonFunction,
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
            color: widget.buttoncolor, borderRadius: BorderRadius.circular(30)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (widget.isLoading)
              Container(
                width: 20,
                height: 20,
                child: const CircularProgressIndicator(
                  color: Colors.white,
                ),
              ),
            const SizedBox(
              width: 10,
            ),
            Text(
              widget.lable,
              style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 19),
            ),
          ],
        ),
      ),
    );
  }
}

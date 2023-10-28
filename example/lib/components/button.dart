import 'package:flutter/material.dart';

class MyButton extends StatefulWidget {
  String lable;
  bool isLoading = false;
  Color buttoncolor;
  
  final Function()? function;
  MyButton(
      {super.key,
      required this.lable,
      required this.function,
      required this.isLoading, this.buttoncolor = Colors.black});

  @override
  State<MyButton> createState() => _MyButtonState();
}

class _MyButtonState extends State<MyButton> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.function,
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
            color: widget.buttoncolor, borderRadius: BorderRadius.circular(30)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (widget.isLoading)
              Container(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
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
                  fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}

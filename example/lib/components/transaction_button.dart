import 'package:flutter/material.dart';

class Transaction_Button extends StatefulWidget {
  String lable;
  bool isLoading = false;
  String countDown;
  Color buttoncolor;
  bool count_down_visibility;
  bool checker_visibility;

  final Function()? buttonFunction;
  Transaction_Button(
      {required this.lable,
      required this.buttonFunction,
      required this.countDown,
      required this.isLoading,
      required this.buttoncolor,
      required this.count_down_visibility,
      required this.checker_visibility});

  @override
  State<Transaction_Button> createState() => _Transaction_ButtonState();
}

class _Transaction_ButtonState extends State<Transaction_Button> {
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
              Stack(alignment: Alignment.center, children: [
                Container(
                  width: 25,
                  height: 52,
                  child: const CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                ),
                Visibility(
                    visible: widget.count_down_visibility,
                    child: Text(widget.countDown,
                        style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 10))),
                Visibility(
                    visible: widget.checker_visibility,
                    child: const Icon(
                      Icons.check_circle_rounded,
                      color: Colors.green,
                    ))
              ]),
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

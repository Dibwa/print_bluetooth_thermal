import 'package:flutter/material.dart';

import 'my_button.dart';

class AirtimePurchase extends StatefulWidget {
  bool ischecked = false;
  VoidCallback check;

  AirtimePurchase({super.key, required this.ischecked, required this.check});

  @override
  State<AirtimePurchase> createState() => _AirtimePurchaseState();
}

class _AirtimePurchaseState extends State<AirtimePurchase> {
  var loginerrormessage = 'PAY';
  Color loginerrorcolor = Color(0xFF0022b0);
  bool loadingIcon = false;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(boxShadow: const [
        BoxShadow(
            color: Colors.grey,
            blurRadius: 10,
            spreadRadius: 1,
            offset: Offset(4, 4))
      ], borderRadius: BorderRadius.circular(10), color: Colors.white),
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 60),
      margin: EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Container(
                    child: Row(
                      children: [
                        const Image(
                          image: AssetImage('images/airtel-logo.jpg'),
                          width: 35,
                        ),
                        Checkbox(
                            value: widget.ischecked, onChanged: (value) => {}),
                      ],
                    ),
                  ),
                  Container(
                    child: Row(
                      children: [
                        Image(
                          image: AssetImage('images/New-mtn-logo.jpg'),
                          width: 35,
                        ),
                        Checkbox(
                            value: widget.ischecked, onChanged: (value) => {}),
                      ],
                    ),
                  ),
                  Container(
                    child: Row(
                      children: [
                        Image(
                          image: AssetImage('images/zamtel-logo.png'),
                          width: 35,
                        ),
                        Checkbox(
                            value: widget.ischecked, onChanged: (value) => {}),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
          SizedBox(
            height: 40,
          ),
          Container(
            height: 47,
            child: TextField(
                cursorColor: Colors.black,
                obscureText: true,
                decoration: InputDecoration(
                    prefixIcon: Icon(
                      Icons.money_outlined,
                      color: Colors.grey,
                    ),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide(color: Color(0xFF0022b0))),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide(color: Color(0xFF0022b0))),
                    hintText: 'Amount',
                    fillColor: Color(0xFFf2f2f2),
                    filled: true)),
          ),
          SizedBox(
            height: 10,
          ),
          MyButton(
            buttoncolor: loginerrorcolor,
            isLoading: loadingIcon,
            buttonFunction: () {},
            lable: loginerrormessage,
          )
        ],
      ),
    );
  }
}

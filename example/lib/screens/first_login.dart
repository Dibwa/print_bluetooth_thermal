// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import '../components/send_screen_to_developer_dialog.dart';
import 'package:qr_flutter/qr_flutter.dart';

import 'profile_page.dart';
import 'shop_link.dart';
import '../login_signup_page.dart';

class First_Login_Page extends StatefulWidget {
  final String firstName;
  final String lastName;
  final String token;
  final String business_name;
  final String business_whatsapp_number;
  final String business_phone_number;
  final String business_Id;
  final String phoneNumber;
  First_Login_Page(
      {
      required,
      required this.firstName,
      required this.lastName,
      required this.token,
      required this.phoneNumber,
      required this.business_name,
      required this.business_whatsapp_number,
      required this.business_phone_number,
      required this.business_Id});

  @override
  First_Login_PageState createState() => First_Login_PageState();
}

class First_Login_PageState extends State<First_Login_Page> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          child: Container(
              height: height,
              width: width,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.white,
              ),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 23, vertical: 40),
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage("images/banner.png"),
                              fit: BoxFit.fill)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => LoginPage()));
                            },
                            child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 5),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(color: Colors.black)),
                                child: Text("Logout")),
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: height * 0.2,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 20),
                      child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Create Business: ",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: Colors.grey)),
                            SizedBox(
                              width: 5,
                            ),
                            Expanded(
                                child: Text(
                                    "register a business you will operate by.",
                                    style: TextStyle(fontSize: 14)))
                          ]),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 20),
                      child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Connect business: ",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: Colors.grey)),
                            SizedBox(
                              width: 5,
                            ),
                            Expanded(
                                child: Text(
                                    "connect to business already registered on the platform.",
                                    style: TextStyle(
                                      fontSize: 14,
                                    )))
                          ]),
                    ),
                    SizedBox(
                      height: height * 0.2,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 20),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Shop_Link_Page(
                                              phoneNumber: widget.phoneNumber,
                                              token: widget.token,
                                            )));
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 5),
                                decoration: BoxDecoration(
                                    boxShadow: const [
                                      BoxShadow(
                                          color:
                                              Color.fromARGB(255, 59, 42, 42),
                                          blurRadius: 1,
                                          spreadRadius: 0.8,
                                          offset: Offset(1, 1))
                                    ],
                                    color: Colors.black,
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(color: Colors.black)),
                                child: Text("Connect Business",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        color: Colors.grey)),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => ProfilePage(
                                              firstName: widget.firstName,
                                              lastName: widget.lastName,
                                              phoneNumber: widget.phoneNumber,
                                              token: widget.token,
                                              business_Id: widget.business_Id,
                                              business_name:
                                                  widget.business_name,
                                              business_phone_number:
                                                  widget.business_phone_number,
                                              business_whatsapp_number: widget
                                                  .business_whatsapp_number,
                                            )));
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 5),
                                decoration: BoxDecoration(
                                    boxShadow: const [
                                      BoxShadow(
                                          color:
                                              Color.fromARGB(255, 59, 42, 42),
                                          blurRadius: 1,
                                          spreadRadius: 0.8,
                                          offset: Offset(1, 1))
                                    ],
                                    color: Colors.black,
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(color: Colors.black)),
                                child: Text("Create Business",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      color: Colors.grey,
                                    )),
                              ),
                            )
                          ]),
                    )
                  ])),
        ));
  }
}

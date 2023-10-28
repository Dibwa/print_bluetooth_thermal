// ignore_for_file: non_constant_identifier_names, avoid_init_to_null

import 'dart:async';
import '../components/send_screen_to_developer_dialog.dart';
import 'package:flutter/material.dart';
import '../components/button.dart';
import '../components/text_input.dart';
import 'package:get/get.dart';

import '../components/transaction_button.dart';
import 'credit_screen.dart';

class Wallet extends StatefulWidget {
  final String firstName;
  final String lastName;
  final String token;
  final String phoneNumber;
  var balance;

  var refreshtoken;
  var eventName;
  double creditScore;
  int creditLimit;
  Wallet({
    super.key,
    required this.firstName,
    required this.lastName,
    required this.token,
    required this.phoneNumber,
    required this.balance,
    required this.refreshtoken,
    required this.eventName,
    required this.creditScore,
    required this.creditLimit,
  });

  @override
  State<Wallet> createState() => _WalletState();
}

class _WalletState extends State<Wallet> {
  @override
  void initState() {
    super.initState();
    refresh_account();
  }

  bool ischecked = false;
  final sendmoneyinput = TextEditingController();

  //SEND MONEY CONTROLLER
  final sendmoneyinputPhoneNumber = TextEditingController();
  final sendmoneyinputAmount = TextEditingController();
//DEFALT SETTINGS

  var balance;
  var provider;
  bool? mtn_checkbox = false;
  bool? airtel_checkbox = false;
  bool? zamtel_checkbox = false;
  Color mycolor = Colors.black;
  Timer? timer2;
  Timer? timer;
  bool cardHolder = true;
  bool sendMoneySection = false;
  bool loading = false;
  bool popUp = false;
  bool charge_on_account = false;

  bool isLoading_send_money = false;

  bool requestMoneySection = false;
  String send_money_button_lable = "Transfer";

  final _connect = GetConnect();
  String clientName = '';
  String sendclientName = '';
  static const maxSeconds = 200;
  int seconds = maxSeconds;
  bool checker_visibility = false;
  bool count_down_visibility = false;
  bool checker_visibility_send_money = false;
  bool count_down_visibility_send_money = false;
  Color send_money_color_button = Colors.black;

  final phone_number = TextEditingController();
  final amount = TextEditingController();
  bool loadingIcon = false;
  Color button_color = Colors.black;

  var account_balance = null;
  var account_name = "";
  bool transfer_details_container = true;
  bool error_container = false;
  String error_message = "Error fetching account details";
  bool loading_phone = false;

  //FETCH USER NAME OF THE FUND RECEIVER
  void fetch_account_name() async {
    setState(() {
      loading_phone = true;
    });
    var response = await _connect.get(
        "https://zatuwallet.onrender.com/api/v1/zatu/usernames/${phone_number.text}");
    print("bbb ${response.body}");

    if (response.statusCode == 200) {
      setState(() {
        error_message = "Error fetching account details";
        loading_phone = false;
        transfer_details_container = true;
        error_container = false;
        account_name =
            "${response.body["user"]["firstName"]} ${response.body["user"]["lastName"]}";
      });
    } else if (response.body == null) {
      setState(() {
        account_name = "Fatal Error";
        loading_phone = false;
      });
    } else {
      setState(() {
        loading_phone = false;

        account_name = "${response.body["message"]}";
      });
    }
  }

  //REFRESH ACCOUNT
  void refresh_account() async {
    var response = await _connect
        .post('https://zatuwallet.onrender.com/api/v1/accountbalance', {
      "phoneNumber": widget.phoneNumber,
    }, headers: {
      "Content-Type": "application/json",
      "authorization": "bearer ${widget.token}"
    });
    print("bbb ${response.body}");

    if (response.statusCode == 200) {
      setState(() {
        error_message = "Error fetching account details";
        loadingIcon = false;
        transfer_details_container = true;
        error_container = false;
        account_balance = "${response.body["balance"]}";
      });
    } else if (response.body == null) {
      setState(() {
        error_message = "Error fetching account details";
        loadingIcon = false;
        transfer_details_container = false;
        error_container = true;
      });
    } else {
      setState(() {
        loadingIcon = false;
        transfer_details_container = false;
        error_container = true;
        error_message = "${response.body["message"]}";
      });
    }
  }

  //TRANSFER MONEY FUNCTION
  void transfer_money() async {
    FocusScopeNode currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }

//https://zatuwallet.onrender.com/
    setState(() {
      isLoading_send_money = true;
    });
    if (mtn_checkbox == false &&
        airtel_checkbox == false &&
        zamtel_checkbox == false) {
      final response = await _connect
          .post('https://zatuwallet.onrender.com/api/v1/transfer/zatu', {
        "receiver": sendmoneyinputPhoneNumber.text.trim(),
        "sender": widget.phoneNumber,
        "amount": sendmoneyinputAmount.text.trim()
      }, headers: {
        "Content-Type": "application/json",
        "authorization": "bearer ${widget.token}"
      });
      print(response.body);

      if (response.statusCode == 200) {
        setState(() {
          checker_visibility = true;
          count_down_visibility = false;

          send_money_color_button = Colors.green.shade200;
          isLoading_send_money = false;

          send_money_button_lable = 'Transaction successful';

          Timer(const Duration(seconds: 2), () {
            setState(() {
              checker_visibility = false;
              count_down_visibility = false;

              send_money_color_button = Colors.black;
              isLoading_send_money = false;

              send_money_button_lable = 'Transfer';
            });
          });
        });
      } else if (response.body == null) {
        setState(() {
          isLoading_send_money = false;
          checker_visibility_send_money = false;
          count_down_visibility_send_money = false;
          send_money_color_button = Colors.red;
          send_money_button_lable = "Connection error";
        });
        Timer(const Duration(seconds: 3), () {
          setState(() {
            send_money_color_button = Colors.black;
            checker_visibility_send_money = false;
            count_down_visibility_send_money = false;
            send_money_button_lable = 'Transfer';
          });
        });
      } else {
        setState(() {
          isLoading_send_money = false;
          checker_visibility_send_money = false;
          count_down_visibility_send_money = false;
          send_money_color_button = Colors.red;
          send_money_button_lable = response.body["message"];
        });
        Timer(const Duration(seconds: 3), () {
          setState(() {
            send_money_color_button = Colors.black;
            checker_visibility_send_money = false;
            count_down_visibility_send_money = false;
            send_money_button_lable = 'Transfer';
          });
        });
      }
    } else if (mtn_checkbox == true) {
      final response = await _connect
          .post('https://zatuwallet.onrender.com/api/v1/transfer', {
        "receiver": sendmoneyinputPhoneNumber.text.trim(),
        "sender": widget.phoneNumber,
        "amount": sendmoneyinputAmount.text.trim(),
        "provider": 2
      }, headers: {
        "Content-Type": "application/json",
        "authorization": "bearer ${widget.token}"
      });
      print(response.body);

      if (response.statusCode == 200) {
        setState(() {
          checker_visibility = true;
          count_down_visibility = false;

          send_money_color_button = Colors.green.shade200;
          isLoading_send_money = false;

          send_money_button_lable = 'Transaction successful';

          Timer(const Duration(seconds: 2), () {
            setState(() {
              checker_visibility = false;
              count_down_visibility = false;

              send_money_color_button = Colors.black;
              isLoading_send_money = false;

              send_money_button_lable = 'Transfer';
            });
          });
        });
      } else if (response.body == null) {
        isLoading_send_money = false;
        setState(() {
          checker_visibility_send_money = false;
          count_down_visibility_send_money = false;
          send_money_color_button = Colors.red;
          send_money_button_lable = "Connection error";
        });
        Timer(const Duration(seconds: 3), () {
          setState(() {
            send_money_color_button = Colors.black;
            checker_visibility_send_money = false;
            count_down_visibility_send_money = false;
            send_money_button_lable = 'Transfer';
          });
        });
      } else {
        setState(() {
          isLoading_send_money = false;
          checker_visibility_send_money = false;
          count_down_visibility_send_money = false;
          send_money_color_button = Colors.red;
          send_money_button_lable = response.body["message"];
        });
        Timer(const Duration(seconds: 3), () {
          setState(() {
            send_money_color_button = Colors.black;
            checker_visibility_send_money = false;
            count_down_visibility_send_money = false;
            send_money_button_lable = 'Transfer';
          });
        });
      }
    } else if (airtel_checkbox == true) {
      final response = await _connect
          .post('https://zatuwallet.onrender.com/api/v1/transfer', {
        "receiver": sendmoneyinputPhoneNumber.text.trim(),
        "sender": widget.phoneNumber,
        "amount": sendmoneyinputAmount.text.trim(),
        "provider": 1
      }, headers: {
        "Content-Type": "application/json",
        "authorization": "bearer ${widget.token}"
      });
      print(response.body);

      if (response.statusCode == 200) {
        setState(() {
          checker_visibility = true;
          count_down_visibility = false;

          send_money_color_button = Colors.green.shade200;
          isLoading_send_money = false;

          send_money_button_lable = 'Transaction successful';

          Timer(const Duration(seconds: 2), () {
            setState(() {
              checker_visibility = false;
              count_down_visibility = false;

              send_money_color_button = Colors.black;
              isLoading_send_money = false;

              send_money_button_lable = 'Transfer';
            });
          });
        });
      } else if (response.body == null) {
        setState(() {
          isLoading_send_money = false;
          checker_visibility_send_money = false;
          count_down_visibility_send_money = false;
          send_money_color_button = Colors.red;
          send_money_button_lable = "Connection error";
        });
        Timer(const Duration(seconds: 3), () {
          setState(() {
            send_money_color_button = Colors.black;
            checker_visibility_send_money = false;
            count_down_visibility_send_money = false;
            send_money_button_lable = 'Transfer';
          });
        });
      } else {
        setState(() {
          isLoading_send_money = false;
          checker_visibility_send_money = false;
          count_down_visibility_send_money = false;
          send_money_color_button = Colors.red;
          send_money_button_lable = response.body["message"];

          Timer(const Duration(seconds: 3), () {
            setState(() {
              send_money_color_button = Colors.black;
              checker_visibility_send_money = false;
              count_down_visibility_send_money = false;
              send_money_button_lable = 'Transfer';
            });
          });
        });
      }
    } else if (zamtel_checkbox == true) {
      final response = await _connect
          .post('https://zatuwallet.onrender.com/api/v1/transfer', {
        "receiver": sendmoneyinputPhoneNumber.text.trim(),
        "sender": widget.phoneNumber,
        "amount": sendmoneyinputAmount.text.trim(),
        "provider": 3
      }, headers: {
        "Content-Type": "application/json",
        "authorization": "bearer ${widget.token}"
      });
      print(response.body);

      if (response.statusCode == 200) {
        setState(() {
          checker_visibility = true;
          count_down_visibility = false;

          send_money_color_button = Colors.green.shade200;
          isLoading_send_money = false;

          send_money_button_lable = 'Transaction successful';

          Timer(const Duration(seconds: 2), () {
            setState(() {
              checker_visibility = false;
              count_down_visibility = false;

              send_money_color_button = Colors.black;
              isLoading_send_money = false;

              send_money_button_lable = 'Transfer';
            });
          });
        });
      } else if (response.body == null) {
        setState(() {
          isLoading_send_money = false;
          checker_visibility_send_money = false;
          count_down_visibility_send_money = false;
          send_money_color_button = Colors.red;
          send_money_button_lable = "Connection error";
        });
        Timer(const Duration(seconds: 3), () {
          setState(() {
            send_money_color_button = Colors.black;
            checker_visibility_send_money = false;
            count_down_visibility_send_money = false;
            send_money_button_lable = 'Transfer';
          });
        });
      } else {
        setState(() {
          isLoading_send_money = false;
          checker_visibility_send_money = false;
          count_down_visibility_send_money = false;
          send_money_color_button = Colors.red;
          send_money_button_lable = response.body["message"];
        });
        Timer(const Duration(seconds: 3), () {
          setState(() {
            send_money_color_button = Colors.black;
            checker_visibility_send_money = false;
            count_down_visibility_send_money = false;
            send_money_button_lable = 'Transfer';
          });
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    if (mtn_checkbox == true) {
      zamtel_checkbox = false;
      airtel_checkbox = false;
      charge_on_account = true;
    } else if (airtel_checkbox == true) {
      mtn_checkbox = false;
      zamtel_checkbox = false;
      charge_on_account = true;
    } else if (zamtel_checkbox == true) {
      airtel_checkbox = false;
      mtn_checkbox = false;
      charge_on_account = true;
    } else {
      charge_on_account = false;
    }
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
          elevation: 0,
          title: const Text(
            "Wallet",
            style: TextStyle(fontSize: 25),
          )),
      body: SafeArea(
          child: account_balance == null
              ? Center(
                  child: Container(
                    width: 50,
                    height: 50,
                    child: const CircularProgressIndicator(),
                  ),
                )
              : Container(
                  width: width,
                  height: height,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Visibility(
                        visible: transfer_details_container,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: width * 0.9,
                              child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text("ZMW $account_balance",
                                        style: const TextStyle(
                                            fontSize: 30,
                                            fontWeight: FontWeight.bold)),
                                  ]),
                            ),
                            const SizedBox(height: 5),
                            Container(
                              width: width * 0.9,
                              height: height * 0.6,
                              child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      margin: const EdgeInsets.only(
                                          left: 17, bottom: 10),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Text(account_name.toUpperCase(),
                                              style: const TextStyle(
                                                  color: Colors.grey,
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold)),
                                        ],
                                      ),
                                    ),
                                    Stack(
                                      alignment: Alignment.centerRight,
                                      children: [
                                        InputField(
                                          autofocus: false,
                                          onchanged: (value) {
                                            print(value);

                                            String phoneNumber = value.trim();

                                            if (phoneNumber.length > 5) {
                                              setState(() {
                                                loading_phone = true;
                                              });

                                              if (phoneNumber.length >= 10) {
                                                fetch_account_name();
                                              }
                                            }
                                          },
                                          inputs: phone_number,
                                          keyboarType: TextInputType.phone,
                                          prefixIcon: const Icon(Icons.phone),
                                          secure: false,
                                          textHint: "Phone #",
                                        ),
                                        Visibility(
                                          visible: loading_phone,
                                          child: Container(
                                            margin:
                                                const EdgeInsets.only(right: 5),
                                            width: 30,
                                            height: 30,
                                            child:
                                                const CircularProgressIndicator(),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 7),
                                    InputField(
                                      autofocus: false,
                                      onchanged: (value) {},
                                      inputs: amount,
                                      keyboarType: TextInputType.phone,
                                      prefixIcon: const Icon(Icons.phone),
                                      secure: false,
                                      textHint: "Amount",
                                    ),
                                    Visibility(
                                      visible: charge_on_account,
                                      child: Center(
                                          child: Container(
                                              margin: const EdgeInsets.only(
                                                  top: 10),
                                              child: const Text(
                                                  "You will be charged ZMW 6 for the transfer",
                                                  style: TextStyle(
                                                      fontSize: 12)))),
                                    ),
                                    const SizedBox(height: 15),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        Row(
                                          children: [
                                            const Image(
                                              image: AssetImage(
                                                  'images/airtel-logo.jpg'),
                                              width: 25,
                                            ),
                                            Checkbox(
                                                value: airtel_checkbox,
                                                onChanged: (v) => setState(() {
                                                      airtel_checkbox = v;
                                                    }))
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            const Image(
                                              image: AssetImage(
                                                  'images/zamtel-logo.png'),
                                              width: 25,
                                            ),
                                            Checkbox(
                                                value: zamtel_checkbox,
                                                onChanged: (v) => setState(() {
                                                      zamtel_checkbox = v;
                                                    }))
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            const Image(
                                              image: AssetImage(
                                                  'images/New-mtn-logo.jpg'),
                                              width: 25,
                                            ),
                                            Checkbox(
                                                value: mtn_checkbox,
                                                onChanged: (v) => setState(() {
                                                      mtn_checkbox = v;
                                                    }))
                                          ],
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 10),
                                    Container(
                                      height: 51,
                                      margin:
                                          EdgeInsets.only(bottom: 10, top: 5),
                                      child: Transaction_Button(
                                        checker_visibility:
                                            checker_visibility_send_money,
                                        count_down_visibility:
                                            count_down_visibility_send_money,
                                        countDown: seconds.toString(),
                                        buttoncolor: send_money_color_button,
                                        isLoading: isLoading_send_money,
                                        buttonFunction: transfer_money,
                                        lable: send_money_button_lable,
                                      ),
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(top: 5),
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(30),
                                          color: Colors.transparent),
                                      child: MyButton(
                                        buttoncolor: Colors.green,
                                        isLoading: false,
                                        function: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      Credit_Screen(
                                                        creditLimit:
                                                            widget.creditLimit,
                                                        creditScore:
                                                            widget.creditScore,
                                                        firstName:
                                                            widget.firstName,
                                                        lastName:
                                                            widget.lastName,
                                                        token: widget.token,
                                                        phoneNumber:
                                                            widget.phoneNumber,
                                                      )));
                                        },
                                        lable: "Borrow",
                                      ),
                                    ),
                                  ]),
                            )
                          ],
                        ),
                      ),
                      Visibility(
                        visible: error_container,
                        child: Container(
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.grey.shade200,
                                  blurRadius: 10,
                                  spreadRadius: 1,
                                  offset: const Offset(4, 4))
                            ],
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.red,
                          ),
                          width: width * 0.7,
                          height: height * 0.16,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  const Text("ERROR",
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold)),
                                  const SizedBox(
                                    height: 1,
                                  ),
                                  Text(error_message,
                                      style: const TextStyle(
                                        fontSize: 16,
                                      ))
                                ],
                              ),
                              const SizedBox(
                                height: 15,
                              ),
                              Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Container(
                                        margin:
                                            const EdgeInsets.only(right: 10),
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 20, vertical: 5),
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                              width: 2, color: Colors.black),
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          color: Colors.white,
                                        ),
                                        child: GestureDetector(
                                          onTap: refresh_account,
                                          child: const Text("Refresh",
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold)),
                                        ))
                                  ])
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                )),
    );
  }
}

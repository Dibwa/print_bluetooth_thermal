// ignore_for_file: camel_case_types

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get_connect/connect.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:shop_manager/components/transaction_button.dart';
import 'dart:convert';
import 'my_textfied.dart';

class Bottom_sheet extends StatefulWidget {
  final String firstName;
  final String lastName;
  final String token;

  final String phoneNumber;
  final invoice_data;
  Bottom_sheet({
    super.key,
    required this.firstName,
    required this.lastName,
    required this.token,
    required this.phoneNumber,
    required this.invoice_data,
  });

  @override
  State<Bottom_sheet> createState() => _Bottom_sheetState();
}

class _Bottom_sheetState extends State<Bottom_sheet> {
  static const maxSeconds = 200;
  int seconds = maxSeconds;
  bool checker_visibility = false;
  bool count_down_visibility = false;
  bool checker_visibility_send_money = false;
  bool isLoading_request_money = false;
  bool isLoading_send_money = false;
  Color request_money_button_color = Colors.green;
  bool buyAirTimeSection = false;
  bool requestMoneySection = false;

  String receive_money_button_lable = "INITIATE  TRANSACTION";
  Timer? timer2;
  Timer? timer;
  var provider;
  final _connect_ = GetConnect();
  String clientName = '';

//TIMER
  void startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (seconds > 0) {
        setState(() => seconds--);
      } else {
        timer?.cancel();
        setState(() {
          request_money_button_color = Colors.red;
          isLoading_request_money = false;

          receive_money_button_lable = "Transaction TimedOut";
        });
        Timer(const Duration(milliseconds: 450), () {
          setState(() {
            isLoading_request_money = false;
            checker_visibility = false;
            count_down_visibility = false;
            receive_money_button_lable = "INITIATE  TRANSACTION";
            request_money_button_color = Colors.green;
          });
        });
      }
    });
  }

//TIMER 2
  void startTimer2(id) {
    timer2 = Timer.periodic(const Duration(seconds: 7), (_) async {
      if (seconds > 0) {
        var response = await _connect_.get(
            'https://zatuwallet.onrender.com/api/v1/transactionstatus/${id}');

        print(response.body);

        if (response.body["message"]["status"] == "SUCCESSFUL") {
          timer?.cancel();
          timer2?.cancel();

          setState(() {
            checker_visibility = true;
            count_down_visibility = false;

            request_money_button_color = Colors.green.shade300;

            receive_money_button_lable = "Transaction Successful";
          });
          Timer(const Duration(milliseconds: 450), () {
            setState(() {
              isLoading_request_money = false;
              checker_visibility = false;
              count_down_visibility = false;
              request_money_button_color = Colors.green;
              receive_money_button_lable = "INITIATE  TRANSACTION";
            });
          });
        } else if (response.body["message"]["status"] == "FAILED") {
          timer?.cancel();
          timer2?.cancel();

          setState(() {
            checker_visibility = true;
            count_down_visibility = false;

            request_money_button_color = Colors.red;
            isLoading_request_money = false;

            receive_money_button_lable = "Transaction failed";
          });

          Timer(const Duration(milliseconds: 450), () {
            setState(() {
              isLoading_request_money = false;
              checker_visibility = false;
              count_down_visibility = false;
              receive_money_button_lable = "INITIATE  TRANSACTION";
              request_money_button_color = Colors.green;
            });
          });
        } else {
          print(response.body);
        }
      } else {
        timer?.cancel();
        timer2?.cancel();
        setState(() {});
        Timer(const Duration(seconds: 2), () {
          setState(() {
            checker_visibility = true;
            count_down_visibility = false;

            request_money_button_color = Colors.red;
            isLoading_request_money = false;

            receive_money_button_lable = "connection error";
          });

          Timer(const Duration(milliseconds: 450), () {
            setState(() {
              isLoading_request_money = false;
              checker_visibility = false;
              count_down_visibility = false;
              receive_money_button_lable = "INITIATE  TRANSACTION";
              request_money_button_color = Colors.green;
            });
          });
        });
      }
    });
  }

  //REQUEST MONEY
  requestMoney() async {
    setState(() {
      checker_visibility = false;
      count_down_visibility = true;

      isLoading_request_money = true;
    });
    FocusScopeNode currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }
    final response = await _connect_
        .post('https://zatuwallet.onrender.com/api/v1/collections/invoice', {
      "provider": provider,
      "receiver": widget.phoneNumber,
      "sender": requestmoneyinput.text.trim(),
      "amount": requestmoneyamountInput.text.trim()
    }, headers: {
      "Content-Type": "application/json",
      "authorization": "bearer ${widget.token}"
    });
    print(response.body);
    if (response.body == null) {
      setState(() {
        checker_visibility = false;
        count_down_visibility = false;

        request_money_button_color = Colors.red;
        isLoading_request_money = false;

        receive_money_button_lable = "Connection Error";
      });
      Timer(const Duration(milliseconds: 450), () {
        setState(() {
          isLoading_request_money = false;
          checker_visibility = false;
          count_down_visibility = false;
          request_money_button_color = Colors.green;
          receive_money_button_lable = "INITIATE  TRANSACTION";
        });
      });
    } else if (response.statusCode == 200) {
      setState(() {
        request_money_button_color = Colors.green.shade300;

        receive_money_button_lable = "Loading";
      });
      startTimer();
      startTimer2(response.body["txnId"]);
    } else {
      setState(() {
        request_money_button_color = Colors.red;
        isLoading_request_money = false;

        receive_money_button_lable = response.body["message"];
      });
      Timer(const Duration(milliseconds: 450), () {
        setState(() {
          isLoading_request_money = false;
          checker_visibility = false;
          count_down_visibility = false;
          request_money_button_color = Colors.green;
        });
      });
    }
  }

//FETCH USER NAME (MONEY REQUEST)
  requestfetchuserName() async {
    var response = await _connect_.get(
        'https://zatuwallet.onrender.com/api/v1/userinfor/${requestmoneyinput.text.trim()}');

    print(response.body);
    setState(() {
      clientName =
          '${response.body["message"]["given_name"]} ${response.body["message"]["family_name"]}';
    });

    print(clientName);
  }

  //REQUEST MONEY CONTOLLER
  final requestmoneyinput = TextEditingController();
  final requestmoneyamountInput = TextEditingController();

  @override
  Widget build(BuildContext context) {
    
    var encoded_invoice = base64.encode(utf8.encode(widget.invoice_data));
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Container(
      height: height * 0.8,
      child: Column(
        children: [
          Container(
              height: height * 0.1,
              child: const Center(
                  child: Text("MOBILE PAYMENT",
                      style: TextStyle(
                          fontSize: 19,
                          fontWeight: FontWeight.bold,
                          color: Colors.black54)))),
          SizedBox(
              width: width * 0.95,
              child: const Divider(
                thickness: 1,
                height: 15,
                color: Colors.grey,
              )),
          Container(
            width: width * 0.95,
            child: Column(children: [
              QrImageView(
                  data: encoded_invoice, version: QrVersions.auto, size: 100),
              Container(
                  margin: EdgeInsets.only(top: 3, bottom: 3),
                  child: Text(clientName, style: TextStyle(fontSize: 18))),
              Container(
                child: InputField(
                  onchanged: (value) {
                    print(value);
                    if (requestmoneyinput.text.length == 10) {
                      requestfetchuserName();
                      print('chikala');
                      String phoneNumber = value.trim();
                      if (phoneNumber.length >= 10) {
                        if (int.parse(phoneNumber[2]) == 7) {
                          provider = 1;
                          print("PROVIDER NUMBER $provider");
                        } else if (int.parse(phoneNumber[2]) == 6) {
                          provider = 2;
                          print("PROVIDER NUMBER $provider");
                        } else if (int.parse(phoneNumber[2]) == 5) {
                          provider = 3;
                          print("PROVIDER NUMBER $provider");
                        }
                      }
                    }
                  },
                  keyboarType: TextInputType.phone,
                  prefixIcon: const Icon(Icons.phone),
                  inputs: requestmoneyinput,
                  textHint: 'Customer Phone #',
                  secure: false,
                ),
              ),
              Container(
                height: 53,
                margin: const EdgeInsets.only(bottom: 10, top: 5),
                child: Transaction_Button(
                  checker_visibility: checker_visibility,
                  count_down_visibility: count_down_visibility,
                  countDown: seconds.toString(),
                  buttoncolor: request_money_button_color,
                  isLoading: isLoading_request_money,
                  buttonFunction: requestMoney,
                  lable: receive_money_button_lable,
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    const Image(
                      image: AssetImage('images/airtel-logo.jpg'),
                      width: 25,
                    ),
                    const Image(
                      image: AssetImage('images/zamtel-logo.png'),
                      width: 25,
                    ),
                    const Image(
                      image: AssetImage('images/New-mtn-logo.jpg'),
                      width: 25,
                    ),
                  ],
                ),
              ),
            ]),
          ),
        ],
      ),
    );
  }
}

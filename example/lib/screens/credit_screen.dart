// ignore_for_file: must_be_immutable, non_constant_identifier_names, prefer_typing_uninitialized_variables

import 'dart:async';
import 'package:another_flushbar/flushbar.dart';
import 'package:another_flushbar/flushbar_helper.dart';
import 'package:another_flushbar/flushbar_route.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shake/shake.dart';
import 'package:url_launcher/url_launcher.dart';
import '../components/my_textfied.dart';
import '../components/send_screen_to_developer_dialog.dart';
import '../components/transaction.dart';
import '../components/transaction_button.dart';
import '../components/loan_list_tile.dart';

import '../components/my_button.dart';

// ignore: camel_case_types
class Credit_Screen extends StatefulWidget {
  String? firstName;
  String? lastName;
  String? token;
  var balance;
  String phoneNumber;
  var refreshtoken;
  var eventName;
  double creditScore;
  int creditLimit;

  Credit_Screen(
      {super.key,
      this.firstName,
      this.lastName,
      this.token,
      this.balance,
      required this.phoneNumber,
      this.refreshtoken,
      this.eventName,
      required this.creditScore,
      required this.creditLimit});

  @override
  State<Credit_Screen> createState() => _Credit_ScreenState();
}

// ignore: camel_case_types
class _Credit_ScreenState extends State<Credit_Screen> {
  @override
  void initState() {
    super.initState();
    fetch_loan_list();
    ShakeDetector detector = ShakeDetector.autoStart(
      onPhoneShake: () {
        _show_dialog_(context);
        // ScaffoldMessenger.of(context).showSnackBar(
        //   const SnackBar(
        //     content: Text('Shake!'),
        //   ),
        // );
        // // Do stuff on phone shake
      },
      minimumShakeCount: 2,
      shakeSlopTimeMS: 300,
      shakeCountResetTime: 3000,
      shakeThresholdGravity: 2.7,
    );
  }

  url_direct() {
    final Uri url = Uri.parse('https://shopmanager-cfmh.onrender.com');
    _launchInBrowser(url);
  }

  Future<void> _launchInBrowser(Uri url) async {
    if (!await launchUrl(
      url,
      mode: LaunchMode.externalApplication,
    )) {
      throw Exception('Could not launch $url');
    }
  }
  // @override
  // void initState() {
  //   // TODO: implement initState
  //   super.initState();
  //   fetch_loan_list();
  // }

  var amount_borrowing = TextEditingController();
  var creditor_phone_number = TextEditingController();
  bool fetching_loan_list = false;
  List<Transaction> transactionsx = [];
  final _connect = GetConnect();
  bool checher_visibility = false;
  bool count_down_visibility = false;
  static const maxSeconds = 200;
  int seconds = maxSeconds;
  String pull_credit_button_lable = "PULL CREDIT";
  int charge = 0;
  double returning = 0;
  bool isLoading_pull_credit = false;
  Map<String, dynamic> creditor = {};
  String creditor_button_lable = "SUBMIT";
  List pending_loans = [];
  bool loading_creditor = false;
  @override
  Widget build(BuildContext context) {
    var borrow = widget.creditLimit * widget.creditScore;
    final iskeyBoard = MediaQuery.of(context).viewInsets.bottom != 0;
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
          title: const Center(child: Text("LOANS")),
          elevation: 0,
          backgroundColor: Colors.green),
      body: (creditor.isEmpty)
          ? Container(
              margin: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        child: const Text(
                            "Creditor phone number you wish to borrow from",
                            style: TextStyle(fontSize: 13))),
                    Container(
                        margin: const EdgeInsets.symmetric(horizontal: 10),
                        child: InputField(
                            onchanged: (value) {},
                            keyboarType: TextInputType.phone,
                            prefixIcon: const Icon(Icons.phone),
                            inputs: creditor_phone_number,
                            textHint: 'Creditor phone #',
                            secure: false)),

                    //RESET PASSWORD BUTTON: send pin and phone number to server
                    Container(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                      child: MyButton(
                        buttoncolor: Colors.black,
                        isLoading: loading_creditor,
                        buttonFunction: () => fetch_creditor_details(),
                        lable: creditor_button_lable,
                      ),
                    ),
                  ]),
            )
          : Container(
              height: height,
              width: width,
              child: Column(
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 50),
                    height: height * 0.15,
                    width: width * 0.9,
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: Colors.grey.shade300,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          flex: 2,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                        "Credit Limit ZMW ${widget.creditLimit}",
                                        style: TextStyle(
                                          color: Colors.grey.shade500,
                                          fontSize: 13,
                                        )),
                                  ],
                                ),
                              ),
                              const Text("You are eligible to borrow"),
                              Text("ZMW $borrow",
                                  style: TextStyle(
                                      fontSize: 40,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey.shade700)),
                            ],
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(bottom: 8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text("Credit Score",
                                  style: TextStyle(
                                      color: Colors.grey.shade600,
                                      fontSize: 9,
                                      fontWeight: FontWeight.bold)),
                              Text(widget.creditScore.toString()),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  Container(
                    width: width * 0.9,
                    margin: const EdgeInsets.only(top: 10),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                    ),
                    child: InputField(
                        onchanged: (value) {
                          if (amount_borrowing.text != "") {
                            setState(() {
                              returning = int.parse(amount_borrowing.text) +
                                  (charge / 100) *
                                      int.parse(amount_borrowing.text);
                            });
                          }
                        },
                        keyboarType: TextInputType.phone,
                        prefixIcon: const Icon(Icons.monetization_on),
                        inputs: amount_borrowing,
                        textHint: 'Amount',
                        secure: false),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 10, bottom: 10),
                    width: width * 0.7,
                    child: Column(children: [
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text("Charge"),
                            Text("${(charge).toString()} %")
                          ]),
                      const SizedBox(
                        height: 7,
                      ),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "Borrowing",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              amount_borrowing.text.isEmpty
                                  ? "ZMW 0"
                                  : "ZMW ${amount_borrowing.text}",
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            )
                          ]),
                      const SizedBox(
                        height: 7,
                      ),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "Returning",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              "ZMW $returning",
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            )
                          ])
                    ]),
                  ),
                  Container(
                    height: 51,
                    width: width * 0.9,
                    margin: const EdgeInsets.only(bottom: 10, top: 5),
                    child: Transaction_Button(
                      checker_visibility: checher_visibility,
                      count_down_visibility: count_down_visibility,
                      countDown: seconds.toString(),
                      buttoncolor: Colors.green,
                      isLoading: isLoading_pull_credit,
                      buttonFunction: credit_Pull,
                      lable: pull_credit_button_lable,
                    ),
                  ),
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.only(top: 18),
                      width: width * 0.90,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "Pending Loans",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 22,
                                color: Colors.grey.shade400),
                          ),
                          const Divider(
                            thickness: 2,
                          ),
                          (pending_loans.isEmpty && fetching_loan_list == false)
                              ? Text(
                                  "0",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 92,
                                      color: Colors.grey.shade300),
                                )
                              : Visibility(
                                  visible: fetching_loan_list,
                                  child: Container(
                                      margin: const EdgeInsets.only(
                                          top: 10, bottom: 10),
                                      width: 20,
                                      height: 20,
                                      child: const CircularProgressIndicator(
                                        color: Color(0xFF0022b0),
                                      )),
                                ),
                          Expanded(
                            child: ListView.builder(
                                itemCount: pending_loans.length,
                                itemBuilder: (context, index) {
                                  final loan = pending_loans[index];
                                  print(loan);
                                  final todayDate = DateTime.now();
                                  final daysRemaining = todayDate.difference(
                                      DateTime.parse(loan["payDate"]));
                                  return Loan_Tile(
                                      loanAmount:
                                          loan["totalAmount"].toString(),
                                      pay_date_days_remaining:
                                          daysRemaining.inDays * -1,
                                      loanStatus: loan["loanStatus"],
                                      buttonFunction: () => pay_loan(
                                          index,
                                          loan["_id"],
                                          loan["totalAmount"],
                                          loan["creditor"]));
                                }),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  void send_message_to_support_team(screenshot) async {
    // https://zatuwallet.onrender.com
    //http://192.168.43.250:600

    var response =
        await _connect.post('https://zatuwallet.onrender.com/api/v1/support', {
      "phoneNumber": widget.phoneNumber,
      "screenshot": screenshot,
    }, headers: {
      "Content-Type": "application/json",
    });
    print("bbb ${response.body} ${response.statusCode}");

    if (response.statusCode == 200) {
    } else if (response.body == null) {
      setState(() {});
      Timer(const Duration(seconds: 2), () {
        setState(() {
          ;
        });
      });
    } else if (response.statusCode == 503) {
      setState(() {});
      Timer(const Duration(seconds: 2), () {
        setState(() {});
      });
    } else {
      setState(() {});
      Timer(const Duration(seconds: 2), () {
        setState(() {});
      });
    }
  }

  void showFlashbar(message, Color color) {
    Flushbar(
      isDismissible: true,
      backgroundColor: color,
      duration: const Duration(seconds: 4),
      forwardAnimationCurve: Curves.decelerate,
      reverseAnimationCurve: Curves.easeOut,
      title: "Server Reponse",
      message: message,
    ).show(context);
  }

  void showFlashbar_server_error(message, Color color) {
    Flushbar(
      isDismissible: true,
      backgroundColor: color,
      duration: const Duration(seconds: 10),
      forwardAnimationCurve: Curves.decelerate,
      reverseAnimationCurve: Curves.easeOut,
      title: "Server Reponse",
      mainButton: GestureDetector(
          onTap: fetch_loan_list,
          child: const Text(
            "Refresh",
            style: TextStyle(fontWeight: FontWeight.bold),
          )),
      message: message,
    ).show(context);
  }

  //FETCH CREDITOR DETAILS
  void fetch_creditor_details() async {
    FocusScopeNode currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }

    if (creditor_phone_number.text == widget.phoneNumber) {
      return showFlashbar("Operation not allowed", Colors.black);
    }
    if (creditor_phone_number.text.isEmpty) {
      return showFlashbar("Creditor Phone number missing", Colors.black);
    }
    setState(() {
      loading_creditor = true;
    });

    final response = await _connect.post(
        'https://zatuwallet.onrender.com/api/v1/creditor/details', {
      "phoneNumber": creditor_phone_number.text
    }, headers: {
      "Content-Type": "application/json",
      "authorization": "bearer ${widget.token}"
    });
    print(response.body);

    if (response.statusCode == 200) {
      setState(() {
        isLoading_pull_credit = false;
        creditor = response.body["message"];
        charge = creditor["interestRate"];
      });

      Timer(const Duration(seconds: 2), () {
        setState(() {
          creditor_button_lable = "SUBMIT";
        });
      });
    } else if (response.body == null) {
      setState(() {
        loading_creditor = false;
        creditor_button_lable = "Connection Error";
      });

      Timer(const Duration(seconds: 2), () {
        setState(() {
          loading_creditor = false;
          creditor_button_lable = "SUBMIT";
        });
      });
    } else {
      setState(() {
        loading_creditor = false;
      });
      Timer(const Duration(seconds: 3), () {
        setState(() {
          loading_creditor = false;
          creditor_button_lable = "SUBMIT";
        });
      });
      showFlashbar(response.body["message"], Colors.black);
    }
  }

  //PULL CREDIT
  void credit_Pull() async {
    FocusScopeNode currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }
    if (amount_borrowing.text.isEmpty) {
      return showFlashbar("Amount missing", Colors.red);
    }
    setState(() {
      isLoading_pull_credit = true;
    });

    final response = await _connect.post(
        'https://zatuwallet.onrender.com/api/v1/transfer/zatu/credit/borrow', {
      "borrower": widget.phoneNumber,
      "creditor": creditor["phoneNumber"],
      "amount": amount_borrowing.text
    },
        headers: {
          "Content-Type": "application/json",
          "authorization": "bearer ${widget.token}"
        });
    print(response.body);

    if (response.statusCode == 200) {
      setState(() {
        isLoading_pull_credit = false;
        pull_credit_button_lable = response.body["message"];
      });

      Timer(const Duration(seconds: 2), () {
        setState(() {
          pull_credit_button_lable = "PULL CREDIT";
        });
      });

      fetch_loan_list();
    } else if (response.body == null) {
      setState(() {
        isLoading_pull_credit = false;
        pull_credit_button_lable = "Connection Error";
      });

      Timer(const Duration(seconds: 2), () {
        setState(() {
          isLoading_pull_credit = false;
          pull_credit_button_lable = "PULL CREDIT";
        });
      });
      fetch_loan_list();
    } else {
      setState(() {
        isLoading_pull_credit = false;
      });
      Timer(const Duration(seconds: 3), () {
        setState(() {
          isLoading_pull_credit = false;
          pull_credit_button_lable = "PULL CREDIT";
        });
      });
      showFlashbar(response.body["message"], Colors.black);
      fetch_loan_list();
    }
  }

  //FETCH LOANS
  void fetch_loan_list() async {
    setState(() {
      fetching_loan_list = true;
    });

    final response = await _connect.post(
        'https://zatuwallet.onrender.com/api/v1/transfer/zatu/credit/loans', {
      "phoneNumber": widget.phoneNumber,
    },
        headers: {
          "Content-Type": "application/json",
          "authorization": "bearer ${widget.token}"
        });
    print(response.body);

    if (response.statusCode == 200) {
      setState(() {
        fetching_loan_list = false;
        pending_loans = response.body["message"];
      });
    } else if (response.body == null) {
      setState(() {
        fetching_loan_list = false;
      });
      showFlashbar_server_error(
          "Connection error fetching loan list. check your internet or reboot internet",
          Colors.red);
    } else {
      setState(() {
        fetching_loan_list = false;
      });
      showFlashbar_server_error(response.body["message"], Colors.red);
    }
  }

  //PAY LOANS
  void pay_loan(index, id, amount, phoneNumber) async {
    FocusScopeNode currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }

    setState(() {
      fetching_loan_list = true;
    });
//zatuwallet.onrender.com
    final response = await _connect.post(
        'https://zatuwallet.onrender.com/api/v1/transfer/zatu/credit/payment', {
      "borrower": widget.phoneNumber,
      "creditor": phoneNumber,
      "amount": amount,
      "loanId": id,
    },
        headers: {
          "Content-Type": "application/json",
          "authorization": "bearer ${widget.token}"
        });
    print(response.body);

    if (response.statusCode == 200) {
      setState(() {
        fetching_loan_list = false;
      });
      fetch_loan_list();
      showFlashbar("Loan successfully settled", Colors.green);
    } else if (response.body == null) {
      setState(() {
        fetching_loan_list = false;
      });
      showFlashbar_server_error(
          "Connection error. check your internet or reboot internet",
          Colors.red);
      fetch_loan_list();
    } else {
      setState(() {
        fetching_loan_list = false;
      });
      showFlashbar_server_error(response.body["message"], Colors.red);
      fetch_loan_list();
    }
  }

  _show_dialog_(context) {
    final sc = "";
    showDialog(
        context: context,
        builder: (context) {
          return Customer_Support(
              send_message_to_support_team: () =>
                  send_message_to_support_team(sc),
              url_direct: url_direct);
        });
  }
}

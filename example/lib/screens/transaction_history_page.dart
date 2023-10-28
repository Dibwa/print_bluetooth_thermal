// ignore_for_file: camel_case_types

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../components/dialog_box_product_list.dart';
import '../components/transaction_list_tile.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:get/get.dart';
import 'home_tab.dart';
import '../components/transaction.dart';
import 'package:shake/shake.dart';
import '../components/send_screen_to_developer_dialog.dart';

class Transaction_List_Page extends StatefulWidget {
  final String firstName;
  final String lastName;
  final String token;
  final String phoneNumber;
  const Transaction_List_Page({
    super.key,
    required this.firstName,
    required this.lastName,
    required this.token,
    required this.phoneNumber,
  });

  @override
  State<Transaction_List_Page> createState() => _Transaction_List_PageState();
}

class _Transaction_List_PageState extends State<Transaction_List_Page> {
  @override
  void initState() {
    super.initState();
    refresh();
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

  final _invoiceBox = Hive.box('Invoices');

  void refresh() {
    final data = _invoiceBox.keys.map((Key) {
      final item = _invoiceBox.get(Key);
      return {
        "key": Key,
        "salesAgent": item["salesAgent"],
        "invoiceId": item["invoiceId"],
        "invoiceItems": item["invoiceItems"],
        "transactionType": item["transactionType"],
        "syncStatus": item["syncStatus"]
      };
    }).toList();

    setState(() {
      transactionsx = data.reversed.toList();
    });
  }
  void send_message_to_support_team(screenshot) async {
    setState(() {

    });

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
      setState(() {

      });
      Timer(const Duration(seconds: 2), () {
        setState(() {
   
        });
      });
    } else if (response.statusCode == 503) {
      setState(() {

      });
      Timer(const Duration(seconds: 2), () {
        setState(() {
   
        });
      });
    } else {
      setState(() {

      });
      Timer(const Duration(seconds: 2), () {
        setState(() {
       
        });
      });
    }
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
  late AnimationController controller;

  late Animation<double> animation;
  bool rotatingIcon = false;
  bool refreshButton = true;
  final _connect = GetConnect();
  List<Map<String, dynamic>> transactionsx = [];

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Container(
      height: height * 0.8,
      width: width * 0.95,
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        const SizedBox(height: 20),
        Container(
          height: height * 0.1,
          width: width * 0.9,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Visibility(
                    visible: refreshButton,
                    child: GestureDetector(
                        onTap: refresh,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 15, vertical: 2),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.black12,
                            ),
                            color: Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Row(
                            children: [
                              Text("Refresh", style: TextStyle(fontSize: 15)),
                              Icon(
                                Icons.refresh_outlined,
                                size: 30,
                              ),
                            ],
                          ),
                        )),
                  ),
                  Visibility(
                    visible: rotatingIcon,
                    child: const SizedBox(
                      width: 23,
                      height: 23,
                      child: CircularProgressIndicator(
                          strokeWidth: 3,
                          color: Colors.white,
                          backgroundColor: Color(0xFF0022b0)),
                    ),
                  )
                ],
              ),
              const Divider(
                thickness: 0.5,
                color: Colors.black38,
              )
            ],
          ),
        ),
        transactionsx.isEmpty
            ? const Expanded(
                child: Center(
                    child: Text(
                  'No Transactions',
                  style: TextStyle(fontSize: 29),
                )),
              )
            : Expanded(
                child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    child: ListView.builder(
                        itemCount: transactionsx.length,
                        itemBuilder: (context, index) {
                          final transaction = transactionsx[index];
                          List invoice_total = transaction["invoiceItems"];

                          num total = 0;
                          invoice_total.forEach(
                              (element) => total += element["subTotal"]);
                          print(transaction);
                          return Transaction_list_Tile(
                              showList: () => _showDialog(invoice_total),
                              invoiceId: transaction["invoiceId"],
                              total: total.toString(),
                              sync: transaction["syncStatus"]);
                        })),
              ),
        const SizedBox(height: 17),
      ]),
    );
  }



  void _showDialog(product_list) {
    showDialog(
        context: context,
        builder: (context) {
          return Dialog_Box_Product_List(
            product_list: product_list,
          );
        });
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

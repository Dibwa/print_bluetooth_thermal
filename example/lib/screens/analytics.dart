import 'dart:async';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get_connect/connect.dart';
import 'package:hive/hive.dart';
import 'package:shake/shake.dart';
import 'package:url_launcher/url_launcher.dart';
import '../bar_graph/bar_graph.dart';
import '../components/product_enlisted_tile.dart';
import '../components/send_screen_to_developer_dialog.dart';

class Analytics_Page extends StatefulWidget {
  final String firstName;
  final String lastName;
  final String token;
  final String phoneNumber;
  const Analytics_Page({
    
    required this.firstName,
    required this.lastName,
    required this.token,
    required this.phoneNumber,
  });

  @override
  State<Analytics_Page> createState() => _Analytics_PageState();
}

class _Analytics_PageState extends State<Analytics_Page> {
  final _connect = GetConnect();
  List<double> weeklySummary = [4.40, 2.50, 42.42, 10.50, 100.20, 88.99, 90.10];
  List<dynamic> _productItems = [];
  List<Map<String, dynamic>> transactionsx = [];
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
    setState(() {});

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
        setState(() {});
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
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
        appBar: AppBar(
            elevation: 0,
            title: Center(
              child: Text(
                "Analytics",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            )),
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                  margin: EdgeInsets.only(left: 18, top: 15),
                  child: Row(children: [
                    Text(
                      "Weekly Sales",
                      style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey.shade400),
                    )
                  ])),
              Container(
                  margin:
                      EdgeInsets.only(left: 25, top: 15, bottom: 5, right: 25),
                  child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          "Total ",
                          style: TextStyle(fontSize: 16, color: Colors.black),
                        ),
                        Text(
                          "ZMW 1200",
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black),
                        )
                      ])),
              Container(
                height: height * 0.4,
                width: width * 0.99,
                child: MybarGraph(
                  weeklySummary: weeklySummary,
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                        margin: EdgeInsets.only(left: 10, top: 35, bottom: 3),
                        child: Text(
                          "Top Selling",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        )),
                    Expanded(
                      child: ListView.builder(
                          itemCount: transactionsx.length,
                          itemBuilder: (context, index) {
                            return ListTile(
                              title: Text("Fruiticana"),
                              trailing: Text("ZMW 20"),
                            );
                          }),
                    ),
                  ],
                ),
              )
            ],
          ),
        ));
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

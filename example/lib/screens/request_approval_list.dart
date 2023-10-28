// ignore_for_file: must_be_immutable

import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../components/request_tile.dart';
import './edit_enlisted_products.dart';
import '../components/product_enlisted_tile.dart';
import '../components/product_tile.dart';
import '../components/send_screen_to_developer_dialog.dart';
import 'package:get/get_connect/connect.dart';

class Request_Approval_List_Page extends StatefulWidget {
  String firstName;
  String lastName;
  String token;
  String phoneNumber;
  Request_Approval_List_Page({
    super.key,
    required this.firstName,
    required this.lastName,
    required this.token,
    required this.phoneNumber,
  });

  @override
  State<Request_Approval_List_Page> createState() =>
      _Request_Approval_List_PageState();
}

class _Request_Approval_List_PageState
    extends State<Request_Approval_List_Page> {
  final _connect = GetConnect();
  bool loading = false;
  bool pending_request_visibility = false;
  Color loadingColor = Colors.lightGreen;
  @override
  void initState() {
    super.initState();
    fetch_pending_request();
  }

  List<dynamic> _request_list = [
    // {
    //   "authority": "0971061190",
    //   "requestor": "0978067790",
    // },
    // {
    //   "authority": "0971061190",
    //   "requestor": "0974067794",
    // },
    // {
    //   "authority": "0971061190",
    //   "requestor": "0972068990",
    // },
  ];

  @override
  Widget build(BuildContext context) {
    if (_request_list.isEmpty) {
      pending_request_visibility = false;
    } else if (_request_list.isNotEmpty) {
      pending_request_visibility = true;
    }
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(elevation: 0, title: Center(child: Text("Requests"))),
      body: Container(
        height: height,
        width: width,
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              (_request_list.isEmpty && loading == false)
                  ? Container(
                      height: height * 0.2,
                      width: width * 0.70,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.grey.shade300,
                      ),
                      child: Center(
                        child: Text("No Pending Requests",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.bold)),
                      ))
                  : Expanded(
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 15),
                            Text("Pending Approval",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 19,
                                    color: Colors.grey.shade400)),
                            SizedBox(height: 10),
                            Visibility(
                              visible: loading,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                      height: 30,
                                      width: 30,
                                      child: CircularProgressIndicator(
                                        color: Colors.lightGreen,
                                      )),
                                ],
                              ),
                            ),
                            SizedBox(height: 10),
                            Visibility(
                              visible: pending_request_visibility,
                              child: Expanded(
                                child: ListView.builder(
                                    itemCount: _request_list.length,
                                    itemBuilder: (context, index) {
                                      final items = _request_list[index];
                                      print(items);
                                      return Request_list_Tile(
                                        approve_request: () => send_request(
                                            items["requestor"], items["_id"],index),
                                        loadingColor: loadingColor,
                                        phoneNumber: items["authority"],
                                        shopId: items["requestor"],
                                      );
                                    }),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
            ]),
      ),
    );
  }

  //AnimationController
  void _showFlashbar(title, message) {
    Flushbar(
      title: title,
      message: message,
      duration: Duration(seconds: 4),
    )..show(context);
  }

  //APPROVE CONNECTION REQUESTS
  send_request(shopId, id, index) async {
    setState(() {
      loading = true;
      loadingColor = Colors.transparent;
    });
    //https://zatuwallet.onrender.com
    //http://192.168.43.250:600

    var response = await _connect
        .post("https://shopmanager-cfmh.onrender.com/api/v1/shop/request/approval", {
      "authority": widget.phoneNumber,
      "requestor": shopId,
      "requestId": id
    }, headers: {
      "Content-Type": "application/json",
    });
    if (response.statusCode == 200) {
      print("bbb ${response.body}");
   _request_list.removeAt(index);
      setState(() {
        loading = false;
        loadingColor = Colors.lightGreen;
        _showFlashbar(
            "Approval Successfull", "request to connect to account approved");
      });
    } else if (response.body == null) {
   
      setState(() {
        loading = false;
        loadingColor = Colors.lightGreen;
      });
      _showFlashbar("Failed",
          "failed to coonect to the server. kindly check your internet");
    } else if (response.statusCode == 503) {
      setState(() {
        loading = false;
        loadingColor = Colors.lightGreen;
      });
      _showFlashbar(
          "Server Down", "Server is currently down. Try again after some time");
    } else {
      setState(() {
        loading = false;
        loadingColor = Colors.lightGreen;
      });
      _showFlashbar("Server Response", response.body["message"]);
    }
  }

  //FETCH PENDING REQUEST CONNECTION
  fetch_pending_request() async {
    setState(() {
      loading = true;
    });
    //https://zatuwallet.onrender.com
    //http://192.168.43.250:600

    var response = await _connect
        .post("https://shopmanager-cfmh.onrender.com/api/v1/shop/request/pending", {
      "authority": widget.phoneNumber,
    }, headers: {
      "Content-Type": "application/json",
    });
    if (response.statusCode == 200) {
      print("bbb ${response.body}");

      setState(() {
        loading = false;
        _request_list = response.body["message"];
      });
    } else if (response.body == null) {
      setState(() {
        loading = false;
      });
      _showFlashbar("Failed",
          "failed to coonect to the server. kindly check your internet");
    } else if (response.statusCode == 503) {
      setState(() {
        loading = false;
      });
      _showFlashbar(
          "Server Down", "Server is currently down. Try again after some time");
    } else {
      setState(() {
        loading = false;
      });
      _showFlashbar("Server Response", response.body["message"]);
    }
  }
}

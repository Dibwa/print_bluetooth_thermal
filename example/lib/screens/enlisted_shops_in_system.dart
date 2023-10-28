// ignore_for_file: must_be_immutable

import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import './edit_enlisted_products.dart';
import '../components/product_enlisted_tile.dart';
import '../components/shop_list_tile.dart';
import '../components/send_screen_to_developer_dialog.dart';
import 'package:get/get.dart';

class Shop_List_Page extends StatefulWidget {
  final String phoneNumber;
  final String token;
  Shop_List_Page({
    super.key,
    required this.phoneNumber,
    required this.token,
  });

  @override
  State<Shop_List_Page> createState() => _Shop_List_PageState();
}

class _Shop_List_PageState extends State<Shop_List_Page> {
  @override
  void initState() {
    super.initState();
    fetch_shops();
  }

  final _connect = GetConnect();
  List<dynamic> _shopList = [
    // {
    //   "shopId": "111111",
    //   "shopName": "PANADO",
    // },
    // {
    //   "shopId": "111111",
    //   "shopName": "PANADO",
    // }
  ];
  List<dynamic> _connection_list = [
    // {
    //   "shopId": "111111",
    //   "shopName": "PANADO",
    // },
    // {
    //   "shopId": "111111",
    //   "shopName": "PANADO",
    // }
  ];
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Container(
        height: height,
        width: width,
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              (_shopList.isEmpty)
                  ? SizedBox(
                      height: 30, width: 30, child: CircularProgressIndicator())
                  : Expanded(
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 10),
                        child: Column(
                          children: [
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: [
                                Expanded(
                                    child: TextField(
                                        decoration: InputDecoration(
                                            hintText: "search shop"))),
                                GestureDetector(
                                    onTap: () {},
                                    child: Icon(
                                      Icons.search,
                                      size: 35,
                                    ))
                              ],
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            Expanded(
                              child: ListView.builder(
                                  itemCount: _shopList.length,
                                  itemBuilder: (context, index) {
                                    final items = _shopList[index];
                                    print(items);
                                    return Shop_list_Tile(
                                     
                                      shopName: items["businessName"],
                                      shopId: items["businessId"].toString(),
                                      phoneNumber: widget.phoneNumber,
                                    );
                                  }),
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



  //FETCH SHOPS
  fetch_shops() async {
    //https://zatuwallet.onrender.com
    //http://192.168.43.250:600

    var response = await _connect
        .get('https://shopmanager-cfmh.onrender.com/api/v1/shop/list', headers: {
      "Content-Type": "application/json",
    });
    if (response.statusCode == 200) {
      print("bbb ${response.body}");

      setState(() {
        _shopList = response.body["message"];
      });
    } else if (response.body == null) {
      _showFlashbar("Failed",
          "failed to coonect to the server. kindly check your internet");
    } else if (response.statusCode == 503) {
      _showFlashbar(
          "Server Down", "Server is currently down. Try again after some time");
    } else {
      _showFlashbar("Server Response", response.body["message"]);
    }
  }
}

// ignore_for_file: must_be_immutable, unnecessary_null_comparison

import 'dart:async';
import '../components/button.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get_connect/connect.dart';
import 'package:hive_flutter/hive_flutter.dart';
import './edit_enlisted_products.dart';
import '../components/product_enlisted_tile.dart';
import '../components/product_tile.dart';
import '../components/send_screen_to_developer_dialog.dart';

class Product_List_Page extends StatefulWidget {
  String firstName;
  String lastName;
  String token;
  String phoneNumber;
  Product_List_Page({
    super.key,
    required this.firstName,
    required this.lastName,
    required this.token,
    required this.phoneNumber,
  });

  @override
  State<Product_List_Page> createState() => _Product_List_PageState();
}

class _Product_List_PageState extends State<Product_List_Page>
    with TickerProviderStateMixin {
  late AnimationController _controller =
      AnimationController(vsync: this, duration: Duration(seconds: 2))
        ..repeat(reverse: false);
  late final Animation<double> _animation =
      CurvedAnimation(parent: _controller, curve: Curves.linear);
  bool product_list_visibility = false;
  bool option_ = false;
  bool empty_text = true;
  bool grocery_status = false;
  bool hardware_status = false;
  bool pharmacy_status = false;
  Color downloadcolor = Colors.green;
  bool loadingIcon = false;
  String download_lable = "Download Products";
  @override
  void initState() {
    super.initState();
    if (_controller.isAnimating) {
      _controller.stop();
    }
    refresh_product_list();
  }

  final _connect = GetConnect();
  List<String> _picked_options = [];
  List<Map<String, dynamic>> _productItems = [
    // {
    //   "key": 0,
    //   "barcode": "111111",
    //   "productName": "PANADO",
    //   "price": "20",
    //   "metricQuantity": "50",
    //   "productMetric": "Ml",
    //   "stockQuantity": "200",
    // },   {
    //   "key": 0,
    //   "barcode": "111111",
    //   "productName": "COKE",
    //   "price": "10",
    //   "metricQuantity": "750",
    //   "productMetric": "Ml",
    //   "stockQuantity": "200",
    // }
  ];

  void refresh_product_list() {
    final data = _productBox.keys.map((Key) {
      final item = _productBox.get(Key);
      return {
        "key": Key,
        "barcode": item["barcode"],
        "productName": item["productName"],
        "price": item["price"],
        "metricQuantity": item["metricQuantity"],
        "productMetric": item["productMetric"],
        "stockQuantity": item["stockQuantity"]
      };
    }).toList();

    setState(() {
      _productItems = data.reversed.toList();
    });
  }

  void _deleteItem(index) {
    _productBox.delete(index);
    refresh_product_list();
  }

  bool loading = false;
  final _productBox = Hive.box('Products');
  @override
  Widget build(BuildContext context) {
    if (option_ == false && _productItems.isNotEmpty) {
      empty_text = false;
      product_list_visibility = true;
    } else if (option_ == false && _productItems.isEmpty) {
      product_list_visibility = false;
      empty_text = true;
    }
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(elevation: 0, actions: [
        GestureDetector(
            onTap: () {
              setState(() {
                empty_text = false;
                product_list_visibility = false;
                option_ = true;
              });
            },
            child: Container(
              padding: EdgeInsets.only(right: 9),
              child: Row(
                children: [
                  Text("Download Products", style: TextStyle(fontSize: 16)),
                ],
              ),
            ))
      ]),
      body: Container(
        height: height,
        width: width,
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              (_productItems.isEmpty && option_ == false)
                  ? Visibility(
                      visible: empty_text,
                      child: Container(
                          height: height * 0.2,
                          width: width * 0.70,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.grey.shade300,
                          ),
                          child: Center(
                            child: Text("No Products Enlisted",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold)),
                          )))
                  : Visibility(
                      visible: product_list_visibility,
                      child: Expanded(
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 10),
                          child: ListView.builder(
                              itemCount: _productItems.length,
                              itemBuilder: (context, index) {
                                final items = _productItems[index];
                                print(items);
                                return Products_Enlisted_Tile(
                                    function_edit: () => _show_bottom_sheet(
                                        context,
                                        items['key'],
                                        items['productName'],
                                        items['productMetric'],
                                        items['metricQuantity'],
                                        items['price'],
                                        items['stockQuantity']),
                                    function_delete: () =>
                                        _deleteItem(items['key']),
                                    productName: items['productName'],
                                    productPrice: items['price'],
                                    productQuantity: items['metricQuantity'],
                                    product_metric_quantity:
                                        items['productMetric']);
                              }),
                        ),
                      ),
                    ),
              Visibility(
                visible: option_,
                child: Container(
                  width: width * 0.8,
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("Groceries",
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey)),
                            SizedBox(
                              width: width * 0.4,
                              height: 10,
                            ),
                            Checkbox(
                                value: grocery_status,
                                onChanged: (Value) {
                                  setState(() {
                                    grocery_status = Value!;
                                    if (Value == true) {
                                      _picked_options.add("grocery");

                                      print(_picked_options);
                                    } else if (Value == false) {
                                      _picked_options.remove("grocery");
                                      print(_picked_options);
                                    }
                                  });
                                })
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("Hardware",
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey)),
                            SizedBox(
                              width: width * 0.4,
                              height: 10,
                            ),
                            Checkbox(
                                value: hardware_status,
                                onChanged: (Value) {
                                  setState(() {
                                    hardware_status = Value!;
                                    if (Value == true) {
                                      _picked_options.add("hardware");

                                      print(_picked_options);
                                    } else if (Value == false) {
                                      _picked_options.remove("hardware");
                                      print(_picked_options);
                                    }
                                  });
                                })
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("Pharmacy",
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey)),
                            SizedBox(
                              width: width * 0.4,
                              height: 10,
                            ),
                            Checkbox(
                                value: pharmacy_status,
                                onChanged: (Value) {
                                  setState(() {
                                    pharmacy_status = Value!;
                                    if (Value == true) {
                                      _picked_options.add("pharmacy");

                                      print(_picked_options);
                                    } else if (Value == false) {
                                      _picked_options.remove("pharmacy");
                                      print(_picked_options);
                                    }
                                  });
                                })
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        MyButton(
                          buttoncolor: downloadcolor,
                          isLoading: loadingIcon,
                          function: donwload_products,
                          lable: download_lable,
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        MyButton(
                          buttoncolor: Colors.red,
                          isLoading: false,
                          function: () {
                            setState(() {
                              if (_productItems.isEmpty) {
                                empty_text = true;
                                product_list_visibility = false;
                                option_ = false;
                              } else {
                                option_ = false;
                                empty_text = false;
                                product_list_visibility = true;
                              }
                            });
                          },
                          lable: "Cancel",
                        ),
                      ]),
                ),
              )
            ]),
      ),
    );
  }

  //SHOW BOTTOM SHEET
  _show_bottom_sheet(
    BuildContext context,
    index,
    productName,
    productMetric,
    metricQuantity,
    price,
    stockQuantity,
  ) {
    return showBottomSheet(
        backgroundColor: Color.fromARGB(246, 255, 255, 255),
        elevation: 0,
        enableDrag: true,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(30))),
        context: context,
        builder: (context) {
          return Edit_BarcodePage(
            firstName: widget.firstName,
            lastName: widget.lastName,
            phoneNumber: widget.phoneNumber,
            token: widget.token,
            index: index,
            productName: productName,
            productMetric: productMetric,
            metricQuantity: metricQuantity,
            price: price,
            stockQuantity: stockQuantity,
          );
        });
  }

  Future<void> saveProduct(Map<String, dynamic> newItem) async {
    await _productBox.add(newItem);
  }

  //AnimationController
  void _showFlashbar(title, message) {
    Flushbar(
      titleColor: const Color.fromARGB(178, 255, 255, 255),
      title: title,
      message: message,
      duration: Duration(seconds: 6),
    )..show(context);
  }

  donwload_products() async {
    setState(() {
      loadingIcon = true;
      download_lable = "Downaloding...";
    });
    //http://192.168.43.250:600
    //https://shopmanager-cfmh.onrender.com
    final response =
        await _connect.post('https://shopmanager-cfmh.onrender.com/api/v1/shop/products', {
      "options": _picked_options
    }, headers: {
      "Content-Type": "application/json",
    });

    print(response.body);
    if (response.statusCode == 200) {
      List<dynamic> server_product_list = response.body["message"];
      for (var i = 0; i < server_product_list.length; i++) {
        //check if product already exist on local device
        final productexisting = _productItems.where((element) =>
            element["barcode"] == server_product_list[i]["barcode"]);

        print("nnnnnnnnnnnnnnnnnnnn $productexisting");
        if (productexisting.isEmpty) {
          saveProduct({
            "barcode": server_product_list[i]["barcode"],
            "productName": server_product_list[i]["productName"],
            "productMetric": server_product_list[i]["productMetric"],
            "metricQuantity": server_product_list[i]["metricQuantity"],
            "price": "0",
            "stockQuantity": "0"
          });
        } else if (productexisting.isNotEmpty) {
          continue;
        }
      }
      refresh_product_list();
      setState(() {
        loadingIcon = false;
        download_lable = "Download Products";
        if (_productItems.isEmpty) {
          empty_text = true;
          product_list_visibility = false;
          option_ = false;
        } else {
          option_ = false;
          empty_text = false;
          product_list_visibility = true;
        }
      });
    } else if (response.body == null) {
      setState(() {
        loadingIcon = false;
        download_lable = "Download Products";
      });
      _showFlashbar("Failed",
          "failed to connect to the server. kindly check your internet");
    } else if (response.statusCode == 503) {
      setState(() {
        loadingIcon = false;
        download_lable = "Download Products";
      });
      _showFlashbar("Server Response",
          "server is currently down. kindly try again later");
    } else {
      setState(() {
        loadingIcon = false;
        download_lable = "Download Products";
      });
      _showFlashbar("Server Response", response.body["message"]);
    }
  }
}

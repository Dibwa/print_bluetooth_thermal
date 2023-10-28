


import 'dart:async';

import 'package:flutter/material.dart';
//import 'package:url_launcher/link.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../components/button.dart';
import '../components/text_input.dart';
import '../components/product_tile.dart';
import './home_tab.dart';



class Pending_Invoice_Page extends StatefulWidget {
  const Pending_Invoice_Page({Key? key}) : super(key: key);

  @override
  State<Pending_Invoice_Page> createState() => Pending_Invoice_PageState();
}

class Pending_Invoice_PageState extends State<Pending_Invoice_Page> {
  final _connect = GetConnect();
  final productName = TextEditingController();
  final price = TextEditingController();
  final quantity = TextEditingController();
  final invoicereceiverphoneNumber = TextEditingController();
  bool inputText = false;
  bool clientlist = true;
  bool submitinvoiceContainer = false;
  bool emptylistText = true;
  bool shareinvoiceContainer = false;
  var whatsappUrl = "";

  var lableadditemButton = 'Add Product';
  var lablesaveinvoiceButton = 'Process Invoice';
  Color signuperrorcolor = Colors.black;

  Color lablesaveinvoicebuttonColor = Colors.black;

  bool loadingIcon = false;

  List<Map<String, dynamic>> _invoiceItems = [];

  @override
  void initState() {
    super.initState();
    refresh();
  }

  void showinputs() {
    setState(() {
      inputText = true;
      clientlist = false;
      emptylistText = false;
    });
  }

  void switchtoSubmit() {
    setState(() {
      inputText = false;
      clientlist = false;
      emptylistText = false;
      submitinvoiceContainer = true;
    });
  }

  void refresh() {
    final data = _pendingBox.keys.map((Key) {
      final item = _pendingBox.get(Key);
      return {
        "key": Key,
        "productName": item["productName"],
        "price": item["price"],
        "quantity": item["quantity"],
        "total": item["total"]
      };
    }).toList();

    setState(() {
      _invoiceItems = data.reversed.toList();
    });
  }

  final _invoiceBox = Hive.box('Invoices');
  final _pendingBox = Hive.box('Pending');

  Future<void> saveInvoice(Map<String, dynamic> newItem) async {
    await _invoiceBox.add(newItem);
    print(_invoiceBox.values);
  }

  void addtoInvoice(Map<String, dynamic> newItem) {
    _pendingBox.add(newItem);
    print(_pendingBox.values);
    refresh();

    setState(() {
      inputText = false;
      clientlist = true;
      emptylistText = false;
      submitinvoiceContainer = false;
    });
  }

  void _deleteItem(index) {
    _pendingBox.delete(index);
    refresh();
  }



  //SEND INVOICE TO SERVER
  void processInvoice() async {
    if (_invoiceItems.isEmpty) {
      return setState(() => lablesaveinvoiceButton = "Invoice List Empty");
    }

    setState(() {
      loadingIcon = true;
    });
    var response =
        await _connect.post('https://zatuwallet.onrender.com/api/v1/invoices', {
      "to": invoicereceiverphoneNumber.text.trim(),
      "from": AppDataInvoice.of(context)?.phoneNumber,
      "products": _invoiceItems,
    }, headers: {
      "Content-Type": "application/json",
      "authorization": "bearer ${AppDataInvoice.of(context)?.token}"
    });
    print("bbbMN ${response.body}  ${response.statusCode}");

    if (response.statusCode == 201) {
      setState(() {
        _invoiceItems = [];
        _pendingBox.clear();

        loadingIcon = false;
        shareinvoiceContainer = true;
        lablesaveinvoicebuttonColor = Colors.green;
        lablesaveinvoiceButton = "Sucessful";


      });
      Timer(const Duration(seconds: 2), () {
        setState(() {
          lablesaveinvoiceButton = 'Process Invoice';
          lablesaveinvoicebuttonColor = Colors.black;
        });
      });
      saveInvoice(response.body["invoice"]);

      refresh();
    } else if (response.body == null) {
      setState(() {
        lablesaveinvoicebuttonColor = Colors.red;
        loadingIcon = false;
        lablesaveinvoiceButton = "Error Occured";
      });
    } else {
      setState(() {
        loadingIcon = false;
        lablesaveinvoiceButton = "Operation Failed";
        lablesaveinvoicebuttonColor = Colors.red;
      });

      Timer(const Duration(seconds: 2), () {
        setState(() {
          lablesaveinvoiceButton = 'Process Invoice';
          lablesaveinvoicebuttonColor = Colors.black;
        });
      });
    }
  }





  @override
  Widget build(BuildContext context) {
    num total = 0;
    _invoiceItems.forEach((element) {
      total += element["total"];
    });

    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      const SizedBox(
        height: 5,
      ),
      (_invoiceItems.isEmpty)
          ? Visibility(
              visible: emptylistText,
              child: Text('Empty List',
                  style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.black.withOpacity(0.5))),
            )

          //INVOICE ITEM LIST
          : Visibility(
              visible: clientlist,
              child: Expanded(
                child: Column(
                  children: [
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                              margin: const EdgeInsets.only(left: 10, top: 10),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: Colors.black,
                              ),
                              child: Text(
                                "ZMW $total",
                                style: const TextStyle(color: Colors.white),
                              )),
                          GestureDetector(
                            onTap: switchtoSubmit,
                            child: Container(
                                margin:
                                    const EdgeInsets.only(right: 10, top: 10),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 5),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  color: Colors.black,
                                ),
                                child: const Text(
                                  "PROCESS INVOICE",
                                  style: TextStyle(color: Colors.white),
                                )),
                          )
                        ]),
                    Expanded(
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 10),
                        child: ListView.builder(
                            itemCount: _invoiceItems.length,
                            itemBuilder: (context, index) {
                              final items = _invoiceItems[index];

                              return ProductTile(
                                function: () => _deleteItem(items['key']),
                                productName: items['productName'],
                                productPrice: items['price'],
                                productQuantity: items['quantity'],
                                productsubTotal: items['total'],
                              );
                            }),
                      ),
                    ),
                  ],
                ),
              ),
            ),

      //SUBMIT INVOICE TO SERVER
      Visibility(
        visible: submitinvoiceContainer,
        child: Container(
          height: height * 0.6,
          width: width * 0.9,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GestureDetector(
                      onTap: () {
                        setState(() {
                          submitinvoiceContainer = false;
                          emptylistText = false;
                          inputText = false;
                          clientlist = true;
                        });
                      },
                      child: const Icon(
                        Icons.cancel,
                        color: Colors.red,
                      ))
                ],
              ),
              Container(
                margin: const EdgeInsets.only(left: 5, right: 5, bottom: 10),
                child: InputField(autofocus: false,onchanged: (value) {
                  
                },
                    inputs: invoicereceiverphoneNumber,
                    keyboarType: TextInputType.phone,
                    prefixIcon: const Icon(Icons.phone),
                    secure: false,
                    textHint: "Invoice Receiver Phone #"),
              ),
              Container(
                margin: const EdgeInsets.only(left: 5, right: 5, bottom: 10),
                child: MyButton(
                  buttoncolor: lablesaveinvoicebuttonColor,
                  isLoading: loadingIcon,
                  function: processInvoice,
                  lable: lablesaveinvoiceButton,
                ),
              ),
              Visibility(
                visible: shareinvoiceContainer,
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(width: 1)),
                  child: Column(
                    children: [
                      const Text("SHARE INVOICE"),
                      Container(
                        margin: const EdgeInsets.only(top: 20),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                         
                              const SizedBox(width: 15),
                              GestureDetector(
                                  onTap: () {},
                                  child: const Icon(Icons.sms, size: 43)),
                            ]),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),

      //INPUT DETAILS CONTAINER
      Visibility(
        visible: inputText,
        child: Container(
          height: height * 0.6,
          width: width * 0.9,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GestureDetector(
                      onTap: () {
                        setState(() {
                          submitinvoiceContainer = false;
                          emptylistText = false;
                          inputText = false;
                          clientlist = true;
                        });
                      },
                      child: const Icon(
                        Icons.cancel,
                        color: Colors.red,
                      ))
                ],
              ),
              Container(
                margin: const EdgeInsets.only(left: 5, right: 5, bottom: 10),
                child: InputField(autofocus: false,onchanged: (value) {
                  
                },
                    inputs: productName,
                    keyboarType: TextInputType.text,
                    prefixIcon: const Icon(Icons.contact_page),
                    secure: false,
                    textHint: "Product Name"),
              ),
              Container(
                margin: const EdgeInsets.only(left: 5, right: 5, bottom: 10),
                child: InputField(autofocus: false,onchanged: (value) {
                  
                },
                    inputs: price,
                    keyboarType: TextInputType.phone,
                    prefixIcon: const Icon(Icons.phone),
                    secure: false,
                    textHint: "Price"),
              ),
              Container(
                margin: const EdgeInsets.only(left: 5, right: 5, bottom: 10),
                child: InputField(autofocus: false,onchanged: (value) {
                  
                },
                    inputs: quantity,
                    keyboarType: TextInputType.phone,
                    prefixIcon: const Icon(Icons.monetization_on),
                    secure: false,
                    textHint: "Quantity"),
              ),
              Container(
                margin: const EdgeInsets.only(left: 5, right: 5, bottom: 10),
                child: MyButton(
                  buttoncolor: signuperrorcolor,
                  isLoading: loadingIcon,
                  function: () => addtoInvoice({
                    "productName": productName.text.toString().toUpperCase(),
                    "price": int.parse(price.text.trim()),
                    "quantity": int.parse(quantity.text.trim()),
                    "total": (int.parse(price.text.trim()) *
                        int.parse(quantity.text.trim()))
                  }),
                  lable: lableadditemButton,
                ),
              ),
            ],
          ),
        ),
      )
    ]);
  }
}

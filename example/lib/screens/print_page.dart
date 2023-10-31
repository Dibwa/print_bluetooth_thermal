//import 'package:blue_thermal_printer_example/testprint.dart';
// ignore_for_file: non_constant_identifier_names

import 'dart:convert';

import 'package:flutter/material.dart';
import 'dart:async';
import 'package:blue_thermal_printer/blue_thermal_printer.dart';
import 'package:flutter/services.dart';
import 'package:uuid/uuid.dart';
import '../components/bottom_sheet.dart';
import '../components/product_tile.dart';
import '../components/dialog_box.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:another_flushbar/flushbar.dart';
import 'home_tab.dart';
import 'package:audioplayers/audioplayers.dart';
import 'testprint.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:shake/shake.dart';
import '../components/send_screen_to_developer_dialog.dart';

import 'dart:async';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:print_bluetooth_thermal/print_bluetooth_thermal.dart';
import 'package:esc_pos_utils_plus/esc_pos_utils.dart';
import 'package:image/image.dart' as img;

class PrintPage extends StatefulWidget {
  final String firstName;
  final String lastName;
  final String token;
  final String business_name;
  final String phoneNumber;
  final String business_Id;
  PrintPage(
      {required this.firstName,
      required this.lastName,
      required this.token,
      required this.phoneNumber,
      required this.business_name,
      required this.business_Id});

  @override
  _PrintPageState createState() => _PrintPageState();
}

class _PrintPageState extends State<PrintPage>
    with SingleTickerProviderStateMixin {
  String _info = "";
  String _msj = '';
  bool connected = false;
  List<BluetoothInfo> items = [];
  List<String> _options = [
    "permission bluetooth granted",
    "bluetooth enabled",
    "connection status",
    "update info"
  ];

  String _selectSize = "2";
  final _txtText = TextEditingController(text: "Hello developer");
  bool _progress = false;
  String _msjprogress = "";

  String optionprinttype = "58 mm";
  List<String> options = ["58 mm", "80 mm"];

  // @override
  // void initState() {
  //   super.initState();
  //   initPlatformState();
  // }

  ////////////////////////////
  @override
  void initState() {
    super.initState();
    // _pendingBox.clear();
    initPlatformState();
    connection_status();
    refresh();
    refresh_pending_products();
    refresh_product_list();
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

  void showFlashbar(context, message, Color color, title) {
    Flushbar(
      isDismissible: true,
      backgroundColor: color,
      duration: const Duration(seconds: 4),
      forwardAnimationCurve: Curves.decelerate,
      reverseAnimationCurve: Curves.easeOut,
      title: title,
      message: message,
    ).show(context);
  }

  void send_message_to_support_team(screenshot) async {
    setState(() {});

    // https://zatuwallet.onrender.com
    //http://192.168.43.250:600

    var response = await http_connect
        .post('https://zatuwallet.onrender.com/api/v1/support', {
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

  url_direct() {}
  TestPrint testPrint = TestPrint();
  //String _scanBarcode = 'Unknown';

  AudioCache cache = AudioCache();
  List<Map<String, dynamic>> _productItems_hive = [];
  List<Map<String, dynamic>> _productItems = [];
  // ignore: non_constant_identifier_names
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
      _productItems_hive = data.reversed.toList();
    });
  }

  void refresh() {
    final data = _productBox.keys.map((Key) {
      final item = _productBox.get(Key);
      return {
        "key": Key,
        "barcode": item["barcode"],
        "productName": item["productName"],
        "price": item["price"],
        "metricQuantity": item["metricQuantity"],
        "stockQuantity": item["stockQuantity"]
      };
    }).toList();

    setState(() {
      _productItems = data.reversed.toList();
    });
  }

  // ignore: non_constant_identifier_names
  void refresh_pending_products() {
    final data = _pendingBox.keys.map((Key) {
      final item = _pendingBox.get(Key);
      return {
        "key": Key,
        "barcode": item["barcode"],
        "productName": item["productName"],
        "price": item["price"],
        "subTotal": item["subTotal"],
        "quantity": item["quantity"]
      };
    }).toList();

    setState(() {
      _invoiceItems = data.reversed.toList();
    });
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> scanBarcodeNormal() async {
    String barcodeScanRes;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, ScanMode.BARCODE);
      await cache.play("beep_sound.mp3");
      if (barcodeScanRes == "-1") return;

      final barcode_results = _productItems
          .where((element) => element["barcode"] == barcodeScanRes)
          .toList();
      if (barcode_results.isEmpty)
        return showFlashbar(context, "Product doesn't exist in the system",
            Colors.red, "Error");
      print(barcode_results);
      //print(barcode_results);

      _show_dialog(barcode_results);
      //  print(barcode_results);
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;
  }

  //____________THERMAL PRINTER SECTION FUNCTIONS
  BlueThermalPrinter bluetooth = BlueThermalPrinter.instance;
  late double sheetheight;
  final http_connect = GetConnect();
  final productName = TextEditingController();
  final price = TextEditingController();
  final quantity = TextEditingController();
  final product_quantity = TextEditingController();
  final invoicereceiverphoneNumber = TextEditingController();
  bool inputText = false;
  bool clientlist = true;
  bool submitinvoiceContainer = false;
  bool emptylistText = true;
  bool shareinvoiceContainer = false;
  bool printerContainer = false;
  bool errorContainer = false;
  var lableadditemButton = 'Add Product';
  var lablesaveinvoiceButton = 'Process Invoice';
  Color signuperrorcolor = Colors.black;
  var total_invoice = "0";
  var id_invoice = "";

  Color lablesaveinvoicebuttonColor = Colors.black;

  bool loadingIcon = false;

  List<Map<String, dynamic>> _invoiceItems = [];

  //TestPrint testPrint = TestPrint();

  //LOCAL DATABASES
  final _invoiceBox = Hive.box('Invoices');
  final _pendingBox = Hive.box('Pending');
  final _productBox = Hive.box('Products');
  List<Map<String, dynamic>> _productItems_ = [
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

  void transact(type) {
    var uuid = Uuid();
    var id = uuid.v4();
    id_invoice = id;
    refresh_pending_products();
    printTest();
    saveInvoice({
      "key": id,
      "salesAgent": widget.phoneNumber,
      "invoiceId": id,
      "invoiceItems": _invoiceItems,
      "transactionType": type,
      "syncStatus": false
    });

    refresh_pending_products();
    // setState(() {
    //   _invoiceItems = [];
    // });
    showFlashbar(
        context, "invoice successfully generated", Colors.green, "Successful");
  }

  void showSheet() {
    showBottomSheet(
        context: context,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20), topRight: Radius.circular(20))),
        builder: ((context) {
          return Container(
            height: sheetheight * 0.7,
          );
        }));
  }

  Future<void> saveInvoice(Map<String, dynamic> newItem) async {
    List<dynamic> L = newItem["invoiceItems"];
    for (var i = 0; i < L.length; i++) {
      print("ffffffffffffffffffffff $L");

      final g = _productItems_hive.where((element) =>
          element["barcode"] == newItem["invoiceItems"][i]["barcode"]);

      print(
          "$g CCCCCCCCCCCCCCCCC ${g.first["stockQuantity"]}  CCCCCC ${newItem["invoiceItems"][i]["quantity"]} CCCCC $newItem");
      final int k = int.parse(g.first["stockQuantity"]) -
          int.parse(newItem["invoiceItems"][i]["quantity"]);

      await _invoiceBox.add(newItem);
      final key = g.first["key"];
      await _productBox.put(key, {
        "barcode": g.first["barcode"],
        "productName": g.first["productName"],
        "productMetric": g.first["productMetric"],
        "metricQuantity": g.first["metricQuantity"],
        "price": g.first["price"],
        "stockQuantity": k.toString()
      });

      refresh_product_list();
    }

    _pendingBox.clear();
    // newItem.forEach((key, value) {
    //   _productBox.get(key);
    //   //var chi = _productItems_hive[];
    // });

    //print(_invoiceBox.values);
  }

  void addtoInvoice(Map<String, dynamic> newItem) async {
    await _pendingBox.add(newItem);

    print(_pendingBox.values);
    refresh_pending_products();

    setState(() {
      inputText = false;
      clientlist = true;
      emptylistText = false;
      submitinvoiceContainer = false;
    });
  }

  void _deleteItem(index) {
    _pendingBox.delete(index);
    refresh_pending_products();
  }

//check connection
  connection_status() async {
    final bool result = await PrintBluetoothThermal.connectionStatus;
    setState(() {
      connected = result;
      print("connection status: $result");
    });
  }

  @override
  Widget build(BuildContext context) {
    num total_subTotal = 0;

    _invoiceItems.forEach((element) {
      total_subTotal += element["subTotal"];
    });
    double height = MediaQuery.of(context).size.height;

    double width = MediaQuery.of(context).size.width;
    setState(() => sheetheight = height);
    return Scaffold(
      body: Container(
        height: height,
        width: width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            (connected == false)
                ? SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Container(
                      padding: EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('info: $_info\n '),
                          Text(_msj),
                          Row(
                            children: [
                              Text("Type print"),
                              SizedBox(width: 10),
                              DropdownButton<String>(
                                value: optionprinttype,
                                items: options.map((String option) {
                                  return DropdownMenuItem<String>(
                                    value: option,
                                    child: Text(option),
                                  );
                                }).toList(),
                                onChanged: (String? newValue) {
                                  setState(() {
                                    optionprinttype = newValue!;
                                  });
                                },
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              ElevatedButton(
                                onPressed: () {
                                  this.getBluetoots();
                                },
                                child: Row(
                                  children: [
                                    Visibility(
                                      visible: _progress,
                                      child: SizedBox(
                                        width: 25,
                                        height: 25,
                                        child:
                                            CircularProgressIndicator.adaptive(
                                                strokeWidth: 1,
                                                backgroundColor: Colors.white),
                                      ),
                                    ),
                                    SizedBox(width: 5),
                                    Text(_progress ? _msjprogress : "Search"),
                                  ],
                                ),
                              ),
                              ElevatedButton(
                                onPressed: connected ? this.disconnect : null,
                                child: Text("Disconnect"),
                              ),
                              ElevatedButton(
                                onPressed: connected ? this.printTest : null,
                                child: Text("Test"),
                              ),
                            ],
                          ),
                          Container(
                              height: 200,
                              decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                                color: Colors.grey.withOpacity(0.3),
                              ),
                              child: ListView.builder(
                                itemCount: items.length > 0 ? items.length : 0,
                                itemBuilder: (context, index) {
                                  return ListTile(
                                    onTap: () {
                                      String mac = items[index].macAdress;
                                      this.connect(mac);
                                    },
                                    title: Text('Name: ${items[index].name}'),
                                    subtitle: Text(
                                        "macAddress: ${items[index].macAdress}"),
                                  );
                                },
                              )),
                          SizedBox(height: 10),
                          Container(
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                              color: Colors.grey.withOpacity(0.3),
                            ),
                            child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column( crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    ElevatedButton(
                                      onPressed: () async {
                                        bool status =
                                            await PrintBluetoothThermal
                                                .isPermissionBluetoothGranted;
                                        setState(() {
                                          print(
                                              "permission bluetooth granted: $status");
                                        });
                                        // connected ? this.printWithoutPackage : null
                                      },
                                      child: Text("Permission status",
                                          style: TextStyle(fontSize: 12)),
                                    ),
                                    ElevatedButton(
                                      onPressed: () async {
                                        bool state = await PrintBluetoothThermal
                                            .bluetoothEnabled;

                                        if (state == false) {
                                          showFlashbar(
                                              context,
                                              "Bluetooth connection is currently off",
                                              Colors.red,
                                              "Bluetooth Connection");
                                        } else if (state == true) {
                                          showFlashbar(
                                              context,
                                              "Bluetooth connection is currently on",
                                              Colors.green,
                                              "Bluetooth Connection");
                                        }

                                        setState(() {
                                          print(
                                              "permission bluetooth granted: $state");
                                        });

                                        // connected ? this.printWithoutPackage : null
                                      },
                                      child: Text("Bluetooth enabled",
                                          style: TextStyle(fontSize: 12)),
                                    ),
                                  ],
                                ),
                                Column(crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    ElevatedButton(
                                      onPressed: () async {
                                        initPlatformState();
                                               showFlashbar(
                                              context,
                                              "Bluetooth connection is currently on",
                                              Colors.black,
                                              "Bluetooth Infor Updated");

                                        // connected ? this.printWithoutPackage : null
                                      },
                                      child: Text("update info"),
                                    ),
                                    ElevatedButton(
                                      onPressed: () async {
                                        final bool result =
                                            await PrintBluetoothThermal
                                                .connectionStatus;

                                                
                                        if (result  == false) {
                                          showFlashbar(
                                              context,
                                              "Printer currently not connected",
                                              Colors.red,
                                              "Printer Connection");
                                        } else if (result == true) {
                                          showFlashbar(
                                              context,
                                              "Printer currently connected",
                                              Colors.green,
                                              "Printer connection");
                                        }
                                        setState(() {
                                          print("connection status: $result");
                                        });

                                        // connected ? this.printWithoutPackage : null
                                      },
                                      child: Text("connection status",
                                          style: TextStyle(fontSize: 12)),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 10),
                        ],
                      ),
                    ),
                  )
                : Expanded(
                    child: Container(
                      width: width * 0.95,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            width: width * 0.93,
                            margin: const EdgeInsets.only(top: 10),
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  primary: Colors.grey),
                              onPressed: () {
                                scanBarcodeNormal();
                              },
                              child: const Text('SCAN PRODUCT',
                                  style: TextStyle(color: Colors.white)),
                            ),
                          ),
                          Row(children: [
                            Container(
                              width: width * 0.45,
                              margin: const EdgeInsets.only(top: 2),
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    primary: Colors.black),
                                onPressed: () {
                                  //testPrint.sample();

                                  transact("CASH");
                                },
                                child: const Text('PRINT RECEIPT',
                                    style: TextStyle(color: Colors.white)),
                              ),
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            Container(
                              width: width * 0.45,
                              margin: const EdgeInsets.only(top: 2),
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    primary: Colors.black),
                                onPressed: () {
                                  //  if (_invoiceItems.isEmpty) return;

                                  _show_bottom_sheet(context);
                                },
                                child: const Text('MOBILE PAYMENT',
                                    style: TextStyle(color: Colors.white)),
                              ),
                            )
                          ]),
                          (_invoiceItems.isEmpty)
                              ? Visibility(
                                  visible: emptylistText,
                                  child: Expanded(
                                    child: Container(
                                      width: width * 0.93,
                                      color: Colors.grey.shade200,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Text('No Products Added',
                                              style: TextStyle(
                                                  fontSize: 28,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black
                                                      .withOpacity(0.5))),
                                        ],
                                      ),
                                    ),
                                  ),
                                )
                              : Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        margin: const EdgeInsets.only(left: 10),
                                        child: Text("Total ZMW $total_subTotal",
                                            style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold)),
                                      ),
                                      Expanded(
                                        child: Container(
                                          margin: const EdgeInsets.symmetric(
                                              horizontal: 10),
                                          child: ListView.builder(
                                              itemCount: _invoiceItems.length,
                                              itemBuilder: (context, index) {
                                                final items =
                                                    _invoiceItems[index];
                                                print(items);
                                                return ProductTile(
                                                  function: () =>
                                                      _deleteItem(items['key']),
                                                  productName:
                                                      items['productName'],
                                                  productPrice: items['price'],
                                                  productQuantity:
                                                      items['quantity'],
                                                  productsubTotal:
                                                      items['subTotal'],
                                                );
                                              }),
                                        ),
                                      ),
                                    ],
                                  ),
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

  Future show(
    String message, {
    Duration duration: const Duration(seconds: 3),
  }) async {
    await new Future.delayed(new Duration(milliseconds: 100));
    ScaffoldMessenger.of(context).showSnackBar(
      new SnackBar(
        content: new Text(
          message,
          style: new TextStyle(
            color: Colors.white,
          ),
        ),
        duration: duration,
      ),
    );
  }

  //SHOW BOTTOM SHEET
  _show_bottom_sheet(BuildContext context) {
    var kadi = jsonEncode(_invoiceItems);
    String encodedData = base64Url.encode(kadi.codeUnits);
    print(encodedData);
    return showModalBottomSheet(
        enableDrag: true,
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(30))),
        context: context,
        builder: (context) {
          return Bottom_sheet(
            firstName: widget.firstName,
            lastName: widget.lastName,
            phoneNumber: widget.phoneNumber,
            token: widget.token,
            invoice_data: encodedData,
          );
        });
  }

  _show_dialog(temp_holder) {
    print(temp_holder);
    showDialog(
        context: context,
        builder: (context) {
          return DialogBox(
            product_name: temp_holder[0]["productName"],
            product_barcode: temp_holder[0]["barcode"],
            product_price: temp_holder[0]["price"],
            product_quantity: product_quantity,
            buttonFunction: () {
              addtoInvoice({
                "barcode": temp_holder[0]["barcode"],
                "subTotal": int.parse(temp_holder[0]["price"]) *
                    int.parse(product_quantity.text),
                "productName": temp_holder[0]["productName"],
                "quantity": product_quantity.text,
                "price": temp_holder[0]["price"],
              });
              Navigator.pop(context);
            },
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

  ///////////////////////////////

  Future<void> initPlatformState() async {
    String platformVersion;
    int porcentbatery = 0;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      platformVersion = await PrintBluetoothThermal.platformVersion;
      print("patformversion: $platformVersion");
      porcentbatery = await PrintBluetoothThermal.batteryLevel;
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    final bool result = await PrintBluetoothThermal.bluetoothEnabled;
    print("bluetooth enabled: $result");
    if (result) {
      _msj = "Bluetooth enabled, please search and connect";
    } else {
      _msj = "Bluetooth not enabled";
    }

    setState(() {
      _info = platformVersion + " ($porcentbatery% battery)";
    });
  }

  Future<void> getBluetoots() async {
    setState(() {
      _progress = true;
      _msjprogress = "Wait";
      items = [];
    });
    final List<BluetoothInfo> listResult =
        await PrintBluetoothThermal.pairedBluetooths;

    /*await Future.forEach(listResult, (BluetoothInfo bluetooth) {
      String name = bluetooth.name;
      String mac = bluetooth.macAdress;
    });*/

    setState(() {
      _progress = false;
    });

    if (listResult.length == 0) {
      _msj =
          "There are no bluetoohs linked, go to settings and link the printer";
    } else {
      _msj = "Touch an item in the list to connect";
    }

    setState(() {
      items = listResult;
    });
  }

  connect(String mac) async {
    setState(() {
      _progress = true;
      _msjprogress = "Connecting...";
      connected = false;
    });
    final bool result =
        await PrintBluetoothThermal.connect(macPrinterAddress: mac);
    print("state conected $result");
    if (result) connected = true;
    setState(() {
      _progress = false;
    });
  }

  Future<void> disconnect() async {
    final bool status = await PrintBluetoothThermal.disconnect;
    setState(() {
      connected = false;
    });
    print("status disconnect $status");
  }

  Future<void> printTest() async {
    bool conexionStatus = await PrintBluetoothThermal.connectionStatus;
    //print("connection status: $conexionStatus");
    if (conexionStatus) {
      List<int> ticket = await testTicket();
      final result = await PrintBluetoothThermal.writeBytes(ticket);
      print("print test result:  $result");
    } else {
      //no conectado, reconecte
    }
  }

  Future<void> printString() async {
    bool conexionStatus = await PrintBluetoothThermal.connectionStatus;
    if (conexionStatus) {
      String enter = '\n';
      await PrintBluetoothThermal.writeBytes(enter.codeUnits);
      //size of 1-5
      String text = "Hello";
      await PrintBluetoothThermal.writeString(
          printText: PrintTextSize(size: 1, text: text));
      await PrintBluetoothThermal.writeString(
          printText: PrintTextSize(size: 2, text: text + " size 2"));
      await PrintBluetoothThermal.writeString(
          printText: PrintTextSize(size: 3, text: text + " size 3"));
    } else {
      //desconectado
      print("desconectado bluetooth $conexionStatus");
    }
  }

  Future<List<int>> testTicket() async {
    List<int> bytes = [];
    // Using default profile
    final profile = await CapabilityProfile.load();
    final generator = Generator(
        optionprinttype == "58 mm" ? PaperSize.mm58 : PaperSize.mm80, profile);
    //bytes += generator.setGlobalFont(PosFontType.fontA);
    bytes += generator.reset();

    final ByteData data = await rootBundle.load('assets/mylogo.jpg');
    final Uint8List bytesImg = data.buffer.asUint8List();
    img.Image? image = img.decodeImage(bytesImg);

    if (Platform.isIOS) {
      // Resizes the image to half its original size and reduces the quality to 80%
      final resizedImage = img.copyResize(image!,
          width: image.width ~/ 1.3,
          height: image.height ~/ 1.3,
          interpolation: img.Interpolation.nearest);
      final bytesimg = Uint8List.fromList(img.encodeJpg(resizedImage));
      //image = img.decodeImage(bytesimg);
    }

    //Using `ESC *`
    // bytes += generator.image(image!);

    // bytes += generator.text(
    //     'Regular: aA bB cC dD eE fF gG hH iI jJ kK lL mM nN oO pP qQ rR sS tT uU vV wW xX yY zZ');
    // bytes += generator.text('Special 1: ñÑ àÀ èÈ éÉ üÜ çÇ ôÔ',
    //     styles: PosStyles(codeTable: 'CP1252'));
    // bytes += generator.text('Special 2: blåbærgrød',
    //     styles: PosStyles(codeTable: 'CP1252'));

    bytes += generator.text('Shop Name:  ${widget.business_name}',
        styles: PosStyles(bold: true));
    bytes += generator.text('Shop id:  ${widget.business_Id}');

    // bytes += generator.text('Reverse text', styles: PosStyles(reverse: true));
    // bytes += generator.text('Underlined text',
    //     styles: PosStyles(underline: true), linesAfter: 1);

    bytes += generator.text(
      'invoiceID: $id_invoice',
      styles: PosStyles(
        fontType: PosFontType.fontB,
      ),
    );

    // bytes += generator.hr();
    bytes += generator.emptyLines(2);
    // bytes +=
    //     generator.text('Align left', styles: PosStyles(align: PosAlign.left));
    // bytes += generator.text('Align center',
    //     styles: PosStyles(align: PosAlign.center));
    // bytes += generator.text('Align right',
    //     styles: PosStyles(align: PosAlign.right), linesAfter: 1);

    num total = 0;
    //_invoiceItems.
    print("ffffffffffffffffffffff PPPPPPPPPPPPPPPPPPP ${_invoiceItems}");
    for (var i = 0; i < _invoiceItems.length; i++) {
      total += _invoiceItems[i]['subTotal'];
      print("ffffffffffffffffffffff PPPPPPPPPPPPPPPPPPP");

      bytes += generator.row([
        PosColumn(
          text: "${_invoiceItems[i]['productName']}",
          width: 7,
          styles: PosStyles(align: PosAlign.left, underline: false),
        ),
        PosColumn(
          text: "x ${_invoiceItems[i]['quantity']}",
          width: 2,
          styles: PosStyles(align: PosAlign.center, underline: false),
        ),
        PosColumn(
          text: "ZMW ${_invoiceItems[i]['subTotal']}",
          width: 3,
          styles: PosStyles(align: PosAlign.right, underline: false),
        ),
      ]);
    }
    bytes += generator.emptyLines(1);
    bytes += generator.row([
      PosColumn(
        text: "Total",
        width: 6,
        styles: PosStyles(align: PosAlign.left, underline: false),
      ),
      PosColumn(
        text: "ZMW $total",
        width: 6,
        styles: PosStyles(align: PosAlign.right, underline: false, bold: true),
      ),
    ]);
    // bytes += generator.row([
    //   PosColumn(
    //     text: 'col3',
    //     width: 6,
    //     styles: PosStyles(align: PosAlign.center, underline: true),
    //   ),
    //   PosColumn(
    //     text: 'col3',
    //     width: 6,
    //     styles: PosStyles(align: PosAlign.center, underline: true),
    //   ),
    // ]);

    //barcode

    // final List<int> barData = [1, 2, 3, 4, 5, 6, 7, 8, 9, 0, 4];
    // bytes += generator.barcode(Barcode.upcA(barData));

    // //QR code
    // bytes += generator.qrcode('example.com');

    bytes += generator.emptyLines(3);
    bytes += generator.text(
      'Cashier: ${widget.firstName} ${widget.lastName}',
      styles: PosStyles(
        fontType: PosFontType.fontA,
      ),
    );

    bytes += generator.emptyLines(2);
    bytes += generator.text(
      'Shop Manager',
      styles: PosStyles(
        height: PosTextSize.size2,
        width: PosTextSize.size2,
      ),
    );
    bytes += generator.emptyLines(3);
    // bytes += generator.feed(2);
    //bytes += generator.cut();
    setState(() {
      _invoiceItems = [];
    });
    return bytes;
  }

  Future<void> printWithoutPackage() async {
    //impresion sin paquete solo de PrintBluetoothTermal
    bool connectionStatus = await PrintBluetoothThermal.connectionStatus;
    if (connectionStatus) {
      String text = _txtText.text.toString() + "\n";
      bool result = await PrintBluetoothThermal.writeString(
          printText: PrintTextSize(size: int.parse(_selectSize), text: text));
      print("status print result: $result");
      setState(() {
        _msj = "printed status: $result";
      });
    } else {
      //no conectado, reconecte
      setState(() {
        _msj = "no connected device";
      });
      print("no conectado");
    }
  }
}

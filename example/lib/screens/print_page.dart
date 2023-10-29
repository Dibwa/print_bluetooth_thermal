//import 'package:blue_thermal_printer_example/testprint.dart';
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

  final String phoneNumber;

  PrintPage({

    required this.firstName,
    required this.lastName,
    required this.token,
    required this.phoneNumber,
  });

  @override
  _PrintPageState createState() => _PrintPageState();
}

class _PrintPageState extends State<PrintPage>
    with SingleTickerProviderStateMixin {




 String _info = "";
  String _msj = '';
  bool connected = false;
  List<BluetoothInfo> items_ = [];
  List<String> _options = ["permission bluetooth granted", "bluetooth enabled", "connection status", "update info"];

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
  List<BluetoothInfo> _devices = [];
  BluetoothInfo? _device;
  bool _connected = false;

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
    saveInvoice({
      "key": id,
      "salesAgent": widget.phoneNumber,
      "invoiceId": id,
      "invoiceItems": _invoiceItems,
      "transactionType": type,
      "syncStatus": false
    });

  
    refresh_pending_products();
    setState(() {
      _invoiceItems = [];
    });
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

  // Future<void> initPlatformState() async {
  //   bool? isConnected = await bluetooth.isConnected;
  //   List<BluetoothDevice> devices = [];
  //   try {
  //     devices = await bluetooth.getBondedDevices();
  //   } on PlatformException {}

  //   bluetooth.onStateChanged().listen((state) {
  //     switch (state) {
  //       case BlueThermalPrinter.CONNECTED:
  //         setState(() {
  //           _connected = true;
  //           print("bluetooth device state: connected");
  //         });
  //         break;
  //       case BlueThermalPrinter.DISCONNECTED:
  //         setState(() {
  //           _connected = false;
  //           print("bluetooth device state: disconnected");
  //         });
  //         break;
  //       case BlueThermalPrinter.DISCONNECT_REQUESTED:
  //         setState(() {
  //           _connected = false;
  //           print("bluetooth device state: disconnect requested");
  //         });
  //         break;
  //       case BlueThermalPrinter.STATE_TURNING_OFF:
  //         setState(() {
  //           _connected = false;
  //           printerContainer = false;
  //           errorContainer = true;
  //           print("bluetooth device state: bluetooth turning off");
  //         });
  //         break;
  //       case BlueThermalPrinter.STATE_OFF:
  //         setState(() {
  //           _connected = false;

  //           printerContainer = false;
  //           errorContainer = true;
  //           print("bluetooth device state: bluetooth off");
  //         });
  //         break;
  //       case BlueThermalPrinter.STATE_ON:
  //         setState(() {
  //           _connected = false;
  //           printerContainer = true;
  //           errorContainer = false;
  //           print("bluetooth device state: bluetooth on");
  //         });
  //         break;
  //       case BlueThermalPrinter.STATE_TURNING_ON:
  //         setState(() {
  //           _connected = false;
  //           printerContainer = true;
  //           errorContainer = false;
  //           print("bluetooth device state: bluetooth turning on");
  //         });
  //         break;
  //       case BlueThermalPrinter.ERROR:
  //         setState(() {
  //           _connected = false;
  //           printerContainer = false;
  //           errorContainer = true;
  //           print("bluetooth device state: error");
  //         });
  //         break;
  //       default:
  //         print(state);
  //         break;
  //     }
  //   });

  //   if (!mounted) return;
  //   setState(() {
  //     _devices = devices;
  //   });

  //   if (isConnected == true) {
  //     setState(() {
  //       _connected = true;
  //     });
  //   }
  // }

  Future<void> saveInvoice(Map<String, dynamic> newItem) async {
    List<dynamic> L = newItem["invoiceItems"];
    for (var i = 0; i < L.length; i++) {
      print("ffffffffffffffffffffff $L");

      final g = _productItems_hive.where((element) =>
          element["barcode"] == newItem["invoiceItems"][i]["barcode"]);

      print("$g CCCCCCCCCCCCCCCCC ${g.first["stockQuantity"]}  CCCCCC ${newItem["invoiceItems"][i]["quantity"]} CCCCC $newItem");
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
            Visibility(
                visible: errorContainer,
                child: Container(
                    height: height * 0.2,
                    width: width * 0.70,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.red,
                    ),
                    child: Center(
                      child: Text("Kindly switch on your Bluetooth",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold)),
                    ))),
            Visibility(
              visible: printerContainer,
              child: Expanded(
                child: Container(
                  width: width * 0.95,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: width * 0.93,
                        margin: const EdgeInsets.only(top: 15),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            const Text(
                              'Device:',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(
                              width: 30,
                            ),
                            Expanded(
                              child: DropdownButton(
                         items: _getDeviceItems(),
                                onChanged: (BluetoothInfo? value) =>
                                    setState(() => _device = value),
                                value: _device,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Container(
                        width: width * 0.93,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  primary: Colors.pink),
                              onPressed: () {
                                initPlatformState();
                              },
                              child: const Text(
                                'Refresh',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                            const SizedBox(
                              width: 20,
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  primary:
                                      _connected ? Colors.red : Colors.green),
                              onPressed: connect(_device!.macAdress),
                              child: Text(connected ? 'Disconnect' : 'Connect',
                                style: const TextStyle(color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: width * 0.93,
                        margin: const EdgeInsets.only(top: 10),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(primary: Colors.grey),
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
                            style:
                                ElevatedButton.styleFrom(primary: Colors.black),
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
                            style:
                                ElevatedButton.styleFrom(primary: Colors.black),
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
                                    mainAxisAlignment: MainAxisAlignment.center,
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
                                crossAxisAlignment: CrossAxisAlignment.start,
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
                                            final items = _invoiceItems[index];
                                            print(items);
                                            return ProductTile(
                                              function: () =>
                                                  _deleteItem(items['key']),
                                              productName: items['productName'],
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
            ),
          ],
        ),
      ),
    );
  }

  List<DropdownMenuItem<BluetoothInfo>> _getDeviceItems() {
    List<DropdownMenuItem<BluetoothInfo>> items = [];
    if (_devices.isEmpty) {
      items.add(const DropdownMenuItem(
        child: Text('NONE'),
      ));
    } else {
      _devices.forEach((device) {
        items.add(DropdownMenuItem(
          child: Text(device.name ?? ""),
          value: device,
        ));
      });
    }
    return items;
  }

  // void _connect() {
  //   if (_device != null) {
  //     bluetooth.isConnected.then((isConnected) {
  //       if (isConnected == true) {
  //         bluetooth.connect(_device!).catchError((error) {
  //           setState(() => _connected = false);
  //         });
  //         setState(() => _connected = true);
  //       }
  //     });
  //   } else {
  //     show('No device selected.');
  //   }
  // }

  void _disconnect() {
    bluetooth.disconnect();
    setState(() => _connected = false);
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
      items_ = [];
    });
    final List<BluetoothInfo> listResult = await PrintBluetoothThermal.pairedBluetooths;

    /*await Future.forEach(listResult, (BluetoothInfo bluetooth) {
      String name = bluetooth.name;
      String mac = bluetooth.macAdress;
    });*/

    setState(() {
      _progress = false;
    });

    if (listResult.length == 0) {
      _msj = "There are no bluetoohs linked, go to settings and link the printer";
    } else {
      _msj = "Touch an item in the list to connect";
    }

    setState(() {
      items_ = listResult;
    });
  }

  connect(String mac) async {   
    
    
    // if (_device != null) {
    //   bluetooth.isConnected.then((isConnected) {
    //     if (isConnected == true) {
    //       bluetooth.connect(_device!).catchError((error) {
    //         setState(() => _connected = false);
    //       });
    //       setState(() => _connected = true);
    //     }
    //   });
    // } else {
    //   show('No device selected.');
    // }
    setState(() {
      _progress = true;
      _msjprogress = "Connecting...";
      connected = false;
    });
    final bool result = await PrintBluetoothThermal.connect(macPrinterAddress: mac);
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
      await PrintBluetoothThermal.writeString(printText: PrintTextSize(size: 1, text: text));
      await PrintBluetoothThermal.writeString(printText: PrintTextSize(size: 2, text: text + " size 2"));
      await PrintBluetoothThermal.writeString(printText: PrintTextSize(size: 3, text: text + " size 3"));
    } else {
      //desconectado
      print("desconectado bluetooth $conexionStatus");
    }
  }

  Future<List<int>> testTicket() async {
    List<int> bytes = [];
    // Using default profile
    final profile = await CapabilityProfile.load();
    final generator = Generator(optionprinttype == "58 mm" ? PaperSize.mm58 : PaperSize.mm80, profile);
    //bytes += generator.setGlobalFont(PosFontType.fontA);
    bytes += generator.reset();

    final ByteData data = await rootBundle.load('assets/mylogo.jpg');
    final Uint8List bytesImg = data.buffer.asUint8List();
    img.Image? image = img.decodeImage(bytesImg);

    if (Platform.isIOS) {
      // Resizes the image to half its original size and reduces the quality to 80%
      final resizedImage = img.copyResize(image!, width: image.width ~/ 1.3, height: image.height ~/ 1.3, interpolation: img.Interpolation.nearest);
      final bytesimg = Uint8List.fromList(img.encodeJpg(resizedImage));
      //image = img.decodeImage(bytesimg);
    }

    //Using `ESC *`
    bytes += generator.image(image!);

    bytes += generator.text('Regular: aA bB cC dD eE fF gG hH iI jJ kK lL mM nN oO pP qQ rR sS tT uU vV wW xX yY zZ');
    bytes += generator.text('Special 1: ñÑ àÀ èÈ éÉ üÜ çÇ ôÔ', styles: PosStyles(codeTable: 'CP1252'));
    bytes += generator.text('Special 2: blåbærgrød', styles: PosStyles(codeTable: 'CP1252'));

    bytes += generator.text('Bold text', styles: PosStyles(bold: true));
    bytes += generator.text('Reverse text', styles: PosStyles(reverse: true));
    bytes += generator.text('Underlined text', styles: PosStyles(underline: true), linesAfter: 1);
    bytes += generator.text('Align left', styles: PosStyles(align: PosAlign.left));
    bytes += generator.text('Align center', styles: PosStyles(align: PosAlign.center));
    bytes += generator.text('Align right', styles: PosStyles(align: PosAlign.right), linesAfter: 1);

    bytes += generator.row([
      PosColumn(
        text: 'col3',
        width: 3,
        styles: PosStyles(align: PosAlign.center, underline: true),
      ),
      PosColumn(
        text: 'col6',
        width: 6,
        styles: PosStyles(align: PosAlign.center, underline: true),
      ),
      PosColumn(
        text: 'col3',
        width: 3,
        styles: PosStyles(align: PosAlign.center, underline: true),
      ),
    ]);

    //barcode

    final List<int> barData = [1, 2, 3, 4, 5, 6, 7, 8, 9, 0, 4];
    bytes += generator.barcode(Barcode.upcA(barData));

    //QR code
    bytes += generator.qrcode('example.com');

    bytes += generator.text(
      'Text size 50%',
      styles: PosStyles(
        fontType: PosFontType.fontB,
      ),
    );
    bytes += generator.text(
      'Text size 100%',
      styles: PosStyles(
        fontType: PosFontType.fontA,
      ),
    );
    bytes += generator.text(
      'Text size 200%',
      styles: PosStyles(
        height: PosTextSize.size2,
        width: PosTextSize.size2,
      ),
    );

    bytes += generator.feed(2);
    //bytes += generator.cut();
    return bytes;
  }

  Future<void> printWithoutPackage() async {
    //impresion sin paquete solo de PrintBluetoothTermal
    bool connectionStatus = await PrintBluetoothThermal.connectionStatus;
    if (connectionStatus) {
      String text = _txtText.text.toString() + "\n";
      bool result = await PrintBluetoothThermal.writeString(printText: PrintTextSize(size: int.parse(_selectSize), text: text));
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

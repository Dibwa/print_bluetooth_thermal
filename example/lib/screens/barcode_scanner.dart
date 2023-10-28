import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import '../components/send_screen_to_developer_dialog.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shake/shake.dart';
import '../components/button.dart';
import '../components/text_input.dart';
import 'package:get/get.dart';

class BarcodePage extends StatefulWidget {
  final String firstName;
  final String lastName;
  final String token;

  final String phoneNumber;
  BarcodePage({
    
    required this.firstName,
    required this.lastName,
    required this.token,
    required this.phoneNumber,
  });

  @override
  _BarcodePageState createState() => _BarcodePageState();
}

class _BarcodePageState extends State<BarcodePage> {
  String _scanBarcode = 'Barcode';
  String dropdownValue = 'Metric';
  AudioCache cache = AudioCache();
  @override
  void initState() {
    super.initState();
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

  final _productBox = Hive.box('Products');

  Future<void> saveProduct(Map<String, dynamic> newItem) async {
    if (in_stock_quantity.text == "" ||
        _scanBarcode.isEmpty ||
        _scanBarcode == "-1" ||
        product_name.text == "" ||
        dropdownValue.isEmpty ||
        price.text == "" ||
        quantity.text == "") {
      setState(() {
        loadingIcon = false;
        button_message = "Fill out inputs";
        button_color = Colors.red;
      });

      Timer(const Duration(seconds: 2), () {
        setState(() {
          button_message = 'SAVE PRODUCT';
          button_color = Colors.black;
        });
      });

      return;
    }

    await _productBox.add(newItem);
    setState(() {
      button_color = const Color.fromARGB(255, 5, 117, 20);
      button_message = "SUCCESSFULLY SAVED";
    });
    Timer(const Duration(seconds: 1), () {
      setState(() {
        button_color = Colors.black;
        button_message = 'SAVE PRODUCT';
      });
    });
    print(_productBox.values);
  }

  Future<void> startBarcodeScanStream() async {
    FlutterBarcodeScanner.getBarcodeStreamReceiver(
            '#ff6666', 'Cancel', true, ScanMode.BARCODE)!
        .listen((barcode) => print(barcode));
  }

  Future<void> scanQR() async {
    String barcodeScanRes;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, ScanMode.QR);
      print(barcodeScanRes);
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _scanBarcode = barcodeScanRes;
    });
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> scanBarcodeNormal() async {
    String barcodeScanRes;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, ScanMode.BARCODE);
      setState(() {
        _scanBarcode = barcodeScanRes;
      });
      print(barcodeScanRes);
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _scanBarcode = barcodeScanRes;
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
  //DEFAULTS
  var barcode = TextEditingController();
  var product_name = TextEditingController();
  var price = TextEditingController();
  var quantity = TextEditingController();
  var in_stock_quantity = TextEditingController();
  bool loadingIcon = false;
  var button_message = 'SAVE PRODUCT';
  Color button_color = Colors.black;

  final _connect = GetConnect();
  @override
  Widget build(BuildContext context) {
    final iskeyBoard = MediaQuery.of(context).viewInsets.bottom != 0;
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
        body: ListView(physics: BouncingScrollPhysics(), children: [
      Column(mainAxisAlignment: MainAxisAlignment.start, children: [
        Container(
          margin: EdgeInsets.only(top: 65),
          height: height * 0.63,
          width: width * 0.9,
          decoration: BoxDecoration(
            boxShadow: const [
              BoxShadow(
                  color: Color.fromARGB(255, 168, 158, 158),
                  blurRadius: 5,
                  spreadRadius: 1,
                  offset: Offset(2, 2))
            ],
            borderRadius: BorderRadius.circular(10),
            color: Colors.white,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 35),
              Column(children: [
                //BARCODE
                GestureDetector(
                  onTap: () => scanBarcodeNormal(),
                  child: Container(
                    padding: const EdgeInsets.only(left: 15),
                    height: 47,
                    width: width * 0.87,
                    decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(color: Colors.black, width: 1)),
                    margin: const EdgeInsets.symmetric(horizontal: 15),
                    child: Row(
                      children: [
                        Icon(Icons.barcode_reader),
                        const SizedBox(width: 5),
                        Text(_scanBarcode, style: TextStyle(fontSize: 16)),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 5),

                //PRODUCT NAME
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 15),
                  child: InputField(
                    autofocus: false,
                    onchanged: (value) {},
                    keyboarType: TextInputType.text,
                    prefixIcon: const Icon(Icons.person),
                    inputs: product_name,
                    textHint: 'Product Name',
                    secure: false,
                  ),
                ),
              ]),
              const SizedBox(height: 5),
              //METRICS
              Container(
                height: 47,
                padding: EdgeInsets.symmetric(horizontal: 15),
                width: width * 0.83,
                decoration: BoxDecoration(
                  border: Border.all(width: 1, color: Colors.black),
                  borderRadius: BorderRadius.circular(30),
                  color: Colors.grey.shade100,
                ),
                child: Row(
                  children: [
                    Icon(Icons.arrow_drop_down_circle),
                    const SizedBox(width: 10),
                    Expanded(
                      child: DropdownButton<String>(
                        icon:
                            Icon(Icons.architecture, color: Colors.transparent),
                        value: dropdownValue,
                        underline: null,
                        items: <String>['Metric', 'L', 'Ml', 'Kg', 'g']
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(
                              value,
                              style: TextStyle(fontSize: 17),
                            ),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            dropdownValue = newValue!;
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 5),

              //QUANTITY
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 15),
                child: InputField(
                  autofocus: false,
                  onchanged: (value) {},
                  keyboarType: TextInputType.phone,
                  prefixIcon: const Icon(Icons.numbers),
                  inputs: quantity,
                  textHint: 'Quantity',
                  secure: false,
                ),
              ),
              const SizedBox(
                height: 5,
              ),

              // IN STOCK QUANTITY
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 15),
                child: InputField(
                  autofocus: false,
                  onchanged: (value) {},
                  keyboarType: TextInputType.phone,
                  prefixIcon: const Icon(Icons.add_business_sharp),
                  inputs: in_stock_quantity,
                  textHint: 'In stock quantity',
                  secure: false,
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 15),
                child: InputField(
                  autofocus: false,
                  onchanged: (value) {},
                  keyboarType: TextInputType.phone,
                  prefixIcon: const Icon(Icons.monetization_on),
                  inputs: price,
                  textHint: 'Product Price',
                  secure: false,
                ),
              ),
              const SizedBox(
                height: 9,
              ),

              //MY BUTTON
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 15),
                decoration: BoxDecoration(
                  boxShadow: const [
                    BoxShadow(
                        color: Color.fromARGB(255, 153, 138, 138),
                        blurRadius: 5,
                        spreadRadius: 1,
                        offset: Offset(2, 4))
                  ],
                  borderRadius: BorderRadius.circular(30),
                  color: Colors.white,
                ),
                child: MyButton(
                  buttoncolor: button_color,
                  isLoading: loadingIcon,
                  function: () => saveProduct({
                    "barcode": _scanBarcode,
                    "productName": product_name.text.toUpperCase(),
                    "productMetric": dropdownValue,
                    "metricQuantity": quantity.text,
                    "price": price.text,
                    "stockQuantity": in_stock_quantity.text
                  }),
                  lable: button_message,
                ),
              ),
            ],
          ),
        ),
      ]),
    ]));
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

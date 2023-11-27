import 'package:flutter/material.dart';
import 'package:get/get_connect/connect.dart';
import 'product_list_page.dart';
import 'request_approval_list.dart';
import '../login_signup_page.dart';
import 'analytics.dart';
import 'first_login.dart';
import 'print_page.dart';
import 'dart:io';
import 'package:shake/shake.dart';
import 'dart:async';
import 'dart:convert';
import 'utils.dart';

import 'package:flutter/services.dart';

import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';

import 'package:install_plugin/install_plugin.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_client_sse/flutter_client_sse.dart';
import 'barcode_scanner.dart';
import 'profile_page.dart';
import 'settings_page.dart';
import 'wallet_page.dart';
import 'transaction_history_page.dart';
import 'package:uuid/uuid.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'shop_link.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:another_flushbar/flushbar.dart';

//LOCAL DATABASES
final _invoiceBox = Hive.box('Invoices');
String decodeBase64(String str) {
  //'-', '+' 62nd char of encoding,  '_', '/' 63rd char of encoding
  String output = str.replaceAll('-', '+').replaceAll('_', '/');
  switch (output.length % 4) {
    // Pad with trailing '='
    case 0: // No pad chars in this case
      break;
    case 2: // Two pad chars
      output += '==';
      break;
    case 3: // One pad char
      output += '=';
      break;
    default:
      throw Exception('Illegal base64url string!"');
  }

  return utf8.decode(base64Url.decode(output));
}

Future<void> saveInvoice(Map<String, dynamic> newItem) async {
  await _invoiceBox.add(newItem);
  print(_invoiceBox.values);
}

var uuid = Uuid();
var id = uuid.v4();

class HomePage extends StatefulWidget {
  final String firstName;
  final String lastName;
  final String token;
  var balance;
  final String business_name;
  final String business_whatsapp_number;
  final String business_phone_number;
  final String business_Id;
  double creditScore;
  int creditLimit;
  final String phoneNumber;
  HomePage(
      {
      required this.firstName,
      required this.lastName,
      required this.token,
      required this.phoneNumber,
      this.balance,
      required this.creditScore,
      required this.creditLimit,
      required this.business_name,
      required this.business_whatsapp_number,
      required this.business_phone_number,
      required this.business_Id});

  @override
  State<HomePage> createState() => HomePageState();
}

class HomePageState extends State<HomePage> with TickerProviderStateMixin {
  /// 默认使用了再惠合伙人的下载地址
  static const _defaultUrl =
      'https://itunes.apple.com/cn/app/%E5%86%8D%E6%83%A0%E5%90%88%E4%BC%99%E4%BA%BA/id1375433239?l=zh&ls=1&mt=8';
  TextEditingController _textEditingController = TextEditingController();
  String _appUrl = '';
  double _progressValue = 0.0;

  /////
  Map _source = {ConnectivityResult.none: false};
  final NetworkConnectivity _networkConnectivity = NetworkConnectivity.instance;
  String string = '';
  late TabController _tabcontroller;
  int _selectedIndex = 0;
  var token = "";
  int request_count = 0;
  late AnimationController _controller =
      AnimationController(vsync: this, duration: Duration(seconds: 2))
        ..repeat(reverse: false);
  late final Animation<double> _animation =
      CurvedAnimation(parent: _controller, curve: Curves.linear);
  final _connect = GetConnect();
  List<Map<String, dynamic>> _invoiceItems = [];
  void refresh_pending_products() {
    _invoiceBox.values;
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
      _invoiceItems = data.reversed.toList();
    });
  }

  //AnimationController
  void _showFlashbar(title, message) {
    Flushbar(
      title: title,
      message: message,
      duration: Duration(seconds: 4),
    )..show(context);
  }

  @override
  void initState() {
    get_request_count();
    ShakeDetector detector = ShakeDetector.autoStart(onPhoneShake: () {
      // Do stuff on phone shake
    });
    if (_controller.isAnimating) {
      _controller.stop();
    }
    // _invoiceBox.clear();
    refresh_pending_products();
    streams_connection(context, id);

    super.initState();
    _tabcontroller = TabController(length: 3, vsync: this);
    _tabcontroller.addListener(() {
      setState(() {
        _selectedIndex = _tabcontroller.index;
      });

      print("MASTER THE TAB HAS CHANGED + ${_tabcontroller.index}");
    });

    _networkConnectivity.initialise();
    _networkConnectivity.myStream.listen((source) {
      _source = source;
      print('source $_source');
      // 1.
      switch (_source.keys.toList()[0]) {
        case ConnectivityResult.mobile:
          string =
              _source.values.toList()[0] ? 'Mobile: Online' : 'Mobile: Offline';
          break;
        case ConnectivityResult.wifi:
          string =
              _source.values.toList()[0] ? 'WiFi: Online' : 'WiFi: Offline';
          break;
        case ConnectivityResult.none:
        default:
          string = 'Offline';
      }
      // 2.
      setState(() {});
      // 3.
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            string,
            style: const TextStyle(fontSize: 10),
          ),
        ),
      );
    });
  }

  void onSelected(BuildContext context, int item) {
    switch (item) {
      case 0:
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => Request_Approval_List_Page(
                  firstName: widget.firstName,
                  lastName: widget.lastName,
                  phoneNumber: widget.phoneNumber,
                  token: widget.token,
                )));
        break;

      case 1:
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => Analytics_Page(
                  firstName: widget.firstName,
                  lastName: widget.lastName,
                  phoneNumber: widget.phoneNumber,
                  token: widget.token,
                )));
        break;
      case 2:
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => SettingsPage( 
                  firstName: widget.firstName,
                  lastName: widget.lastName,
                  phoneNumber: widget.phoneNumber,
                  token: widget.token,
                   business_Id: widget.business_Id,
                  business_name: widget.business_name,
                  business_phone_number: widget.business_phone_number,
                  business_whatsapp_number: widget.business_whatsapp_number,   
                  creditScore: widget.creditScore,
                 
                   creditLimit: widget.creditLimit,

                )));
        break;

      case 3:
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => Product_List_Page(
                  firstName: widget.firstName,
                  lastName: widget.lastName,
                  phoneNumber: widget.phoneNumber,
                  token: widget.token,

                )));
        break;

      case 4:
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => ProfilePage(
                  firstName: widget.firstName,
                  lastName: widget.lastName,
                  phoneNumber: widget.phoneNumber,
                  token: widget.token,
                  business_Id: widget.business_Id,
                  business_name: widget.business_name,
                  business_phone_number: widget.business_phone_number,
                  business_whatsapp_number: widget.business_whatsapp_number,
                )));
        break;

      case 5:
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => Wallet(
                  eventName: "",
                  refreshtoken: "",
                  creditScore: widget.creditScore,
                  balance: widget.balance,
                  creditLimit: widget.creditLimit,
                  firstName: widget.firstName,
                  lastName: widget.lastName,
                  phoneNumber: widget.phoneNumber,
                  token: widget.token,
                )));
        break;

      case 6:
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => Shop_Link_Page(
                  phoneNumber: widget.phoneNumber,
                  token: widget.token,
                )));
        break;
      case 7:
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const LoginPage()),
          (route) => false,
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final upgrade = 1;
    //get_request_count();
    return DefaultTabController(
      length: 3,
      child: SafeArea(
        child: AppDataInvoice(
          firstName: widget.firstName,
          lastName: widget.lastName,
          phoneNumber: widget.phoneNumber,
          token: widget.token,
          child: Scaffold(
             resizeToAvoidBottomInset: false,
              appBar: AppBar(
                automaticallyImplyLeading: false,
                title: Row(children: [
                  Icon(Icons.person),
                  Container(
                      margin: EdgeInsets.only(left: 5),
                      child: Text(widget.firstName.toUpperCase()))
                ]),
                backgroundColor: Colors.green,
                elevation: 0,
                actions: [
                  GestureDetector(
                      onTap: () {
                        processInvoice();
                      },
                      child: RotationTransition(
                          turns: _animation,
                          child: const Icon(Icons.sync, size: 30))),
                  PopupMenuButton<int>(
                    icon: (upgrade==1)? Icon(Icons.upgrade_outlined,size: 35,color: Colors.green.shade100,) : null,
                    onSelected: (item) => onSelected(context, item),
                    itemBuilder: (context) => [
                            PopupMenuItem<int>(
                          value: 0,
                          child: Row(
                            children: [
                              Text('Upgrade'),
                              Container(
                                  margin: EdgeInsets.only(left: 10),
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 5, vertical: 2.5),
                                  decoration: BoxDecoration(
                                      color: Colors.grey,
                                      borderRadius: BorderRadius.circular(10)),
                                  child: Icon(Icons.upgrade_outlined)),
                            ],
                          )),
                      PopupMenuItem<int>(
                          value: 0,
                          child: Row(
                            children: [
                              Text('Requests'),
                              Container(
                                  margin: EdgeInsets.only(left: 10),
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 5),
                                  decoration: BoxDecoration(
                                      color: Colors.green,
                                      borderRadius: BorderRadius.circular(10)),
                                  child: Text(
                                    request_count.toString(),
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: const Color.fromARGB(
                                            164, 255, 255, 255)),
                                  )),
                            ],
                          )),
                      const PopupMenuItem<int>(
                          value: 1, child: Text('Analytics')),
                      const PopupMenuItem<int>(
                          value: 2, child: Text('Settings')),
                      const PopupMenuItem<int>(
                          value: 3, child: Text('Inventory')),
                      const PopupMenuItem<int>(
                          value: 4, child: Text('Profile')),
                      const PopupMenuItem<int>(value: 5, child: Text('Wallet')),
                      const PopupMenuItem<int>(
                          value: 6, child: Text('Shop Link')),
                      const PopupMenuDivider(),
                      PopupMenuItem<int>(
                          value: 7,
                          child: Row(
                            children: const [
                              Icon(Icons.logout, color: Colors.black),
                              SizedBox(
                                width: 5,
                              ),
                              Text('Logout'),
                            ],
                          ))
                    ],
                  )
                ],
              ),
              body: Column(
                children: [
                  TabBar(
                    controller: _tabcontroller,
                    indicatorPadding:
                        const EdgeInsets.symmetric(horizontal: 11),
                    tabs: const [
                      Tab(
                          child: Text('Print Receipt',
                              style: TextStyle(
                                  color: Colors.black, fontSize: 13))),
                      Tab(
                          child: Text('Transactions',
                              style: TextStyle(
                                  color: Colors.black, fontSize: 13))),
                      Tab(
                          child: Text('Add Product',
                              style:
                                  TextStyle(color: Colors.black, fontSize: 13)))
                    ],
                  ),
                  Expanded(
                    child: TabBarView(controller: _tabcontroller, children: [
                      PrintPage(
                        firstName: widget.firstName,
                        lastName: widget.lastName,
                        phoneNumber: widget.phoneNumber,
                        token: widget.token,
                        business_name:widget.business_name,
                        business_Id:widget.business_Id
                      ),
                      Transaction_List_Page(
                        firstName: widget.firstName,
                        lastName: widget.lastName,
                        phoneNumber: widget.phoneNumber,
                        token: widget.token,
                      ),
                      BarcodePage(
                        firstName: widget.firstName,
                        lastName: widget.lastName,
                        phoneNumber: widget.phoneNumber,
                        token: widget.token,
                      )
                    ]),
                  )
                ],
              )),
        ),
      ),
    );
  }

  //SEND INVOICE TO SERVER
  void processInvoice() async {
    _controller.repeat();
    refresh_pending_products();
    _showFlashbar("Synchronizing", "sync in progresss");
    print(_invoiceItems);

    if (_invoiceItems.isEmpty) {}
//http://192.168.43.250:600
    var response = await _connect
        .post('https://zatuwallet.onrender.com/api/v1/physicalshops', {
      "eventChannel": id,
      "invoices": _invoiceItems,
    }, headers: {
      "Content-Type": "application/json",
      "authorization": "bearer ${widget.token}"
    });
    print("bbbMN ${response.body}  ${response.statusCode}");

    if (response.statusCode == 201) {
      _controller.stop();
      _showFlashbar("Server Reponse", response.body["message"]);
    } else if (response.body == null) {
      _controller.stop();
      _showFlashbar("Error", "connection couldn't be established");
    } else {
      _controller.stop();
      _showFlashbar("Server Reponse", response.body["message"]);
    }
  }

  //AnimationController
  void _showFlashbar_(title, message) {
    Flushbar(
      titleColor: const Color.fromARGB(178, 255, 255, 255),
      title: title,
      message: message,
      duration: Duration(seconds: 6),
    )..show(context);
  }

  //FETCH CONNECTIONS COUNT
  get_request_count() async {
    //https://zatuwallet.onrender.com
    //http://192.168.43.250:600

    var response = await _connect.post(
        "https://shopmanager-cfmh.onrender.com/api/v1/shop/requestcount", {
      "phoneNumber": widget.phoneNumber,
    },
        headers: {
          "Content-Type": "application/json",
        });
    if (response.statusCode == 200) {
      print("bbb ${response.body}");

      setState(() {
        request_count = response.body["message"];
      });
    } else if (response.body == null) {
      _showFlashbar("Failed",
          "failed to connect to the server. kindly check your internet");
    } else if (response.statusCode == 503) {
      _showFlashbar_(
          "Server Down", "Server is currently down. Try again after some time");
    } else {
      _showFlashbar_("Server Response", response.body["message"]);
    }
  }

////////////////////

  _showResMsg(String msg) {
    print(msg);
    Utils.toast(msg);
  }

//install package from the internet
  _networkInstallApk() async {
    if (_progressValue != 0 && _progressValue < 1) {
      _showResMsg("Wait a moment, downloading");
      return;
    }

    _progressValue = 0.0;
    var appDocDir = await getTemporaryDirectory();
    String savePath = appDocDir.path + "/takeaway_phone_release_1.apk";
    String fileUrl =
        "https://s3.cn-north-1.amazonaws.com.cn/mtab.kezaihui.com/apk/takeaway_phone_release_1.apk";
    await Dio().download(fileUrl, savePath, onReceiveProgress: (count, total) {
      final value = count / total;
      if (_progressValue != value) {
        setState(() {
          if (_progressValue < 1.0) {
            _progressValue = count / total;
          } else {
            _progressValue = 0.0;
          }
        });
        print((_progressValue * 100).toStringAsFixed(0) + "%");
      }
    });

    final res = await InstallPlugin.install(savePath);
    _showResMsg(
        "install apk ${res['isSuccess'] == true ? 'success' : 'fail:${res['errorMessage'] ?? ''}'}");
  }

  //install package from local storage
  _localInstallApk() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null) {
      final res = await InstallPlugin.install(result.files.single.path ?? '');
      _showResMsg(
          "install apk ${res['isSuccess'] == true ? 'success' : 'fail:${res['errorMessage'] ?? ''}'}");
    } else {
      // User canceled the picker
      _showResMsg("User canceled the picker apk");
    }
  }

  /////////////////////////
}

//EVETS FROM THE SERVER
void streams_connection(context, id) {
  // print("STREAMMMMMMMMMMMMMMMMMZZZZZ");

  List<Map<String, dynamic>> _invoiceItems = [];
  void refresh_pending_products() {
    _invoiceBox.values;
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

    _invoiceItems = data.reversed.toList();
  }

  //https://zatuwallet.onrender.com
//http://192.168.43.250:600

  SSEClient.subscribeToSSE(
      url: 'https://zatuwallet.onrender.com/stream?id=$id',
      header: {
        "Accept": "text/event-stream",
        "Cache-Control": "no-cache",
      }).listen((event) async {
    refresh_pending_products();
    //  print("STREAMMMMMMMMMMMMMMMMMZZZZZ ${_invoiceBox.values}");
    print('Id: ${event.id!}');
    print('Event: ${event.event!}');
    print('Data: ${event.data!}');
    if (event.event == "invoice_process_successful") {
      final payload = parseJwtPayLoad(event.data!);

      print(payload);

      final invoice_results = _invoiceItems.firstWhere(
          (element) => element["invoiceId"] == payload["invoice"]["invoiceId"]);

      print("STREAMMMMMMMMMMMMMMMMMZZZZZ $invoice_results");
      if (invoice_results.isEmpty) return;
      var key = invoice_results["key"];

      await _invoiceBox.putAt(key, {
        "salesAgent": invoice_results["salesAgent"],
        "invoiceId": invoice_results["invoiceId"],
        "invoiceItems": invoice_results["invoiceItems"],
        "transactionType": invoice_results["transactionType"],
        "syncStatus": true,
        "date": payload["invoice"]["date"]
      });

      print("STREAMMMMMMMMMMMMMMMMMZZZZZ ${_invoiceBox.values}");
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          "Server connection established",
          style: const TextStyle(fontSize: 10),
        ),
      ),
    );
  });
}

class AppDataInvoice extends InheritedWidget {
  final String? firstName;
  final String? lastName;
  final String? token;

  final String? phoneNumber;

  final Widget child;
  const AppDataInvoice({
    Key? key,
    required this.firstName,
    required this.lastName,
    required this.token,
    required this.phoneNumber,
    required this.child,
  }) : super(key: key, child: child);

  static AppDataInvoice? of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<AppDataInvoice>();

  @override
  bool updateShouldNotify(covariant AppDataInvoice oldWidget) {
    return oldWidget.token != token;
  }
}

Map<String, dynamic> parseJwtPayLoad(String token) {
  final parts = token.split('.');
  if (parts.length != 3) {
    throw Exception('invalid token');
  }

  final payload = decodeBase64(parts[1]);
  final payloadMap = json.decode(payload);
  if (payloadMap is! Map<String, dynamic>) {
    throw Exception('invalid payload');
  }

  return payloadMap;
}

class NetworkConnectivity {
  NetworkConnectivity._();
  static final _instance = NetworkConnectivity._();
  static NetworkConnectivity get instance => _instance;
  final _networkConnectivity = Connectivity();
  final _controller = StreamController.broadcast();
  Stream get myStream => _controller.stream;
  void initialise() async {
    ConnectivityResult result = await _networkConnectivity.checkConnectivity();
    _checkStatus(result);
    _networkConnectivity.onConnectivityChanged.listen((result) {
      print(result);
      _checkStatus(result);
    });
  }

  void _checkStatus(ConnectivityResult result) async {
    bool isOnline = false;
    try {
      final result = await InternetAddress.lookup('example.com');
      isOnline = result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } on SocketException catch (_) {
      isOnline = false;
    }
    _controller.sink.add({result: isOnline});
  }

  void disposeStream() => _controller.close();
}

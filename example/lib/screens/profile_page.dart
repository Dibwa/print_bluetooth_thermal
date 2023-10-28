import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/material.dart';
import 'package:get/get_connect/connect.dart';
import 'package:hive/hive.dart';
import '../components/send_screen_to_developer_dialog.dart';
import '../components/check_out_tile.dart';
import '../components/button.dart';
import '../components/text_input.dart';
import 'home_tab.dart';

final loginBox = Hive.box('Login');

class ProfilePage extends StatefulWidget {
  final String firstName;
  final String lastName;
  final String token;
  final String business_name;
  final String business_whatsapp_number;
  final String business_phone_number;
  final String business_Id;
  final String phoneNumber;
  const ProfilePage(
      {super.key,
      required this.firstName,
      required this.lastName,
      required this.token,
      required this.phoneNumber,
      required this.business_name,
      required this.business_whatsapp_number,
      required this.business_phone_number,
      required this.business_Id});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  void initState() {
    super.initState();
    refresh_login_credentials();
  }

  final company_name = TextEditingController();
  final company_whatsapp_number = TextEditingController();
  final comapany_phone_number = TextEditingController();
  final _connect = GetConnect();
  Color buttoncolor = Colors.black;
  bool loadingIcon = false;
  String buttonlable = "Create Business";
  var company_credentials = false;
  var company_inputs = true;
  @override
  Widget build(BuildContext context) {
    if (widget.business_Id.isEmpty) {
      company_credentials = false;
      company_inputs = true;
    } else if (widget.business_Id.isNotEmpty) {
      company_credentials = true;
      company_inputs = false;
    }
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(title: const Center(child: Text('PROFILE')), elevation: 0),
      body: Container(
          width: width,
          height: height,
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
            Container(
              margin: const EdgeInsets.only(top: 40),
              width: width * 0.9,
              height: height * 0.25,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10), color: Colors.white),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: const [
                          Icon(Icons.contact_page,
                              size: 40, color: Colors.amber),
                        ],
                      ),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Container(
                              margin: const EdgeInsets.only(right: 10, top: 3),
                              child: Text('Owner details',
                                  style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey.withOpacity(0.5))),
                            ),
                          ]),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Container(
                              margin: const EdgeInsets.only(right: 10),
                              child: Text('Names',
                                  style: TextStyle(
                                      fontSize: 17,
                                      color: Colors.grey.withOpacity(0.5))),
                            ),
                            Row(
                              children: [
                                Text(
                                  widget.firstName.toUpperCase(),
                                  style: TextStyle(
                                      fontSize: 20,
                                      color: Colors.grey.withOpacity(0.9)),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  widget.lastName.toUpperCase(),
                                  style: TextStyle(
                                      fontSize: 20,
                                      color: Colors.grey.withOpacity(0.9)),
                                ),
                              ],
                            )
                          ]),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Container(
                              margin: const EdgeInsets.only(right: 10),
                              child: Text('Phone Number',
                                  style: TextStyle(
                                      fontSize: 17,
                                      color: Colors.grey.withOpacity(0.5))),
                            ),
                            Text("${widget.phoneNumber}",
                                style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.grey.withOpacity(0.9)))
                          ]),
                    ]),
              ),
            ),
            //COMPANY INPUTS
            Visibility(
              visible: company_inputs,
              child: Expanded(
                child: Column(
                  children: [
                    Container(
                      margin:
                          const EdgeInsets.only(bottom: 5, left: 15, right: 15),
                      child: InputField(
                          autofocus: false,
                          onchanged: (value) {},
                          keyboarType: TextInputType.text,
                          prefixIcon: const Icon(Icons.store),
                          inputs: company_name,
                          textHint: 'Business Name ',
                          secure: false),
                    ),
                    Container(
                      margin:
                          const EdgeInsets.only(bottom: 5, left: 15, right: 15),
                      child: InputField(
                          autofocus: false,
                          onchanged: (value) {},
                          keyboarType: TextInputType.phone,
                          prefixIcon: const Icon(Icons.phone_android_outlined),
                          inputs: company_whatsapp_number,
                          textHint: 'Business whatsapp number',
                          secure: false),
                    ),
                    Container(
                      margin: const EdgeInsets.only(
                          bottom: 15, left: 15, right: 15),
                      child: InputField(
                          autofocus: false,
                          onchanged: (value) {},
                          keyboarType: TextInputType.phone,
                          prefixIcon: const Icon(Icons.phone),
                          inputs: comapany_phone_number,
                          textHint: 'Business phone number',
                          secure: false),
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                      child: MyButton(
                        buttoncolor: buttoncolor,
                        isLoading: loadingIcon,
                        function: register_shop,
                        lable: buttonlable,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            //COMPANY CREDENTIALS
            Visibility(
              visible: company_credentials,
              child: Expanded(
                child: Column(
                  children: [
                    Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                      Container(
                          margin: const EdgeInsets.only(
                              bottom: 5, left: 20, right: 15, top: 20),
                          child: Text(
                            "Business Details",
                            style: TextStyle(
                                color: Colors.grey,
                                fontWeight: FontWeight.bold),
                          ))
                    ]),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Container(
                            margin: const EdgeInsets.only(
                                bottom: 5, left: 15, top: 20),
                            child: Icon(Icons.store, size: 30)),
                        Container(
                          margin: const EdgeInsets.only(
                              bottom: 5, left: 5, right: 15, top: 20),
                          child: Text(
                            widget.business_name,
                            style: TextStyle(fontSize: 22),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Container(
                            margin: const EdgeInsets.only(
                                bottom: 5, left: 15, top: 20),
                            child: Icon(FontAwesomeIcons.whatsapp, size: 30)),
                        Container(
                          margin: const EdgeInsets.only(
                              bottom: 5, left: 5, right: 15, top: 20),
                          child: Text(
                            widget.business_whatsapp_number,
                            style: TextStyle(fontSize: 20),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Container(
                            margin: const EdgeInsets.only(
                                bottom: 5, left: 15, top: 20),
                            child: Icon(Icons.phone_android, size: 30)),
                        Container(
                          margin: const EdgeInsets.only(
                              bottom: 5, left: 5, right: 15, top: 20),
                          child: Text(
                            widget.business_phone_number,
                            style: TextStyle(fontSize: 20),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Container(
                            margin: const EdgeInsets.only(
                                bottom: 5, left: 20, top: 20),
                            child: Text(
                              "ID: ",
                              style: TextStyle(color: Colors.grey),
                            )),
                        Container(
                          margin: const EdgeInsets.only(
                              bottom: 5, left: 5, right: 15, top: 20),
                          child: Text(
                            widget.business_Id,
                            style: TextStyle(fontSize: 14, color: Colors.grey),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ])),
    );
  }

  //REGISTER FUNCTION
  void register_shop() async {
    if (company_name.text.isEmpty ||
        company_whatsapp_number.text.isEmpty ||
        comapany_phone_number.text.isEmpty) {
      setState(() {
        loadingIcon = false;
        buttoncolor = const Color.fromARGB(255, 176, 0, 0);
        buttonlable = "missing field";
      });
      Timer(const Duration(seconds: 2), () {
        setState(() {});
      });
      return;
    }
    setState(() {
      loadingIcon = true;
    });

    final response =
        await _connect.post('https://shopmanager-cfmh.onrender.com/api/v1/shop/register', {
      "ownerfirstName": widget.firstName,
      "ownerlastName": widget.lastName,
      "ownerphoneNumber": widget.phoneNumber,
      "businessName": company_name.text.trim(),
      "businesswhatsappNumber": company_whatsapp_number.text.trim(),
      "businessphoneNumber": comapany_phone_number.text.trim(),
    });

    print(response.body);
    if (response.statusCode == 201) {
      setState(() {
        buttonlable = response.body["message"];
        buttoncolor = Colors.green;
        loadingIcon = false;
      });
      Timer(const Duration(seconds: 2), () {
        setState(() {
          loadingIcon = true;
          buttonlable = "Redirecting";
          buttoncolor = Colors.black;
        });
      });

      var data = await loginRequest();

      print(data);
      (data != null)
          ? Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => HomePage(
                      firstName: data["user"]["firstName"],
                      lastName: data["user"]["lastName"],
                      phoneNumber: data["user"]["phoneNumber"],
                      token: data["token"],
                      creditLimit: data["user"]["creditLimit"],
                      creditScore: data["user"]["creditScore"],
                      balance: data["user"]["balance"],
                      business_Id: data["user"]["business"]["businessId"],
                      business_name: data["user"]["business"]["businessName"],
                      business_phone_number: data["user"]["business"]
                          ["businessphoneNumber"],
                      business_whatsapp_number: data["user"]["business"]
                          ["businesswhatsappNumber"])))
          : setState(() {
              buttonlable = "connection error";
              buttoncolor = Colors.red;
              loadingIcon = false;
            });
      Timer(const Duration(seconds: 4), () {
        setState(() {
          buttonlable = "Create Business";
          buttoncolor = Colors.black;
          loadingIcon = false;
        });
      });
    } else if (response.body == null) {
      setState(() {
        buttonlable = "connection error";
        buttoncolor = Colors.red;
        loadingIcon = false;
      });
      Timer(const Duration(seconds: 2), () {
        setState(() {
          buttonlable = "Create Business";
          buttoncolor = Colors.black;
          loadingIcon = false;
        });
      });
    } else if (response.statusCode == 503) {
      setState(() {
        buttonlable = "server down";
        buttoncolor = Colors.red;
        loadingIcon = false;
      });
      Timer(const Duration(seconds: 2), () {
        setState(() {
          buttonlable = "Create Business";
          buttoncolor = Colors.black;
          loadingIcon = false;
        });
      });
    } else {
      setState(() {
        buttonlable = response.body["message"];
        buttoncolor = Colors.grey;
        loadingIcon = false;
      });
      Timer(const Duration(seconds: 2), () {
        setState(() {
          buttonlable = "Create Business";
          buttoncolor = Colors.black;
          loadingIcon = false;
        });
      });
    }
  }

  List<Map<String, dynamic>> _login = [];
  void refresh_login_credentials() {
    print("MORE LIFE");
    final data = loginBox.keys.map((Key) {
      final item = loginBox.get(Key);
      return {
        "key": Key,
        "phoneNumber": item["phoneNumber"],
        "password": item["password"],
      };
    }).toList();

    _login = data.reversed.toList();

    print(_login);
  }

  //LOGIN FUNCTION
  loginRequest() async {
    //final payload = parseJwtPayLoad(widget.token);
    //https://zatuwallet.onrender.com
    //http://192.168.43.250:600

    var response =
        await _connect.post('https://shopmanager-cfmh.onrender.com/api/v1/login', {
      "phoneNumber": _login[0]["phoneNumber"],
      "password": _login[0]["password"],
    }, headers: {
      "Content-Type": "application/json",
    });
    if (response.statusCode == 200) {
      print("bbb ${response.body}");
      return response.body;
    } else if (response.body == null) {
      return null;
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
}

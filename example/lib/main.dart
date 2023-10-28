
// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'screens/home_tab.dart';
import 'screens/first_login.dart';
import 'login_signup_page.dart';
import 'screens/profile_page.dart';
import 'screens/settings_page.dart';
import 'screens/shop_link.dart';
import 'package:get/get.dart';

import 'dart:async';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:print_bluetooth_thermal/print_bluetooth_thermal.dart';
import 'package:esc_pos_utils_plus/esc_pos_utils.dart';
import 'package:image/image.dart' as img;
final loginBox = Hive.box('Login');

final _connect = GetConnect();
void main() async{ 
   WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  await Hive.openBox('Invoices');
  await Hive.openBox('Pending');
  await Hive.openBox('Products');
  await Hive.openBox('Settings');
  await Hive.openBox('Login');
  refresh_login_credentials();
  var kadi = await loginRequest();
  runApp(MyApp(
    data: kadi,
  ));

}

class MyApp extends StatelessWidget {
    var data;
  MyApp({ required this.data});

  @override
  Widget build(BuildContext context) {
    //LOCAL DATABASES
    print(data);

    if (data != null && data["user"]["business"]["businessId"] == "") {
      return MaterialApp(
          theme: ThemeData(primarySwatch: Colors.green),
          debugShowCheckedModeBanner: false,
          home: First_Login_Page(
              firstName: data["user"]["firstName"],
              lastName: data["user"]["lastName"],
              phoneNumber: data["user"]["phoneNumber"],
              token: data["token"],
              business_Id: data["user"]["business"]["businessId"],
              business_name: data["user"]["business"]["businessName"],
              business_phone_number: data["user"]["business"]
                  ["businessphoneNumber"],
              business_whatsapp_number: data["user"]["business"]
                  ["businesswhatsappNumber"]));
    }
    return MaterialApp(
      theme: ThemeData(primarySwatch: Colors.green),
      debugShowCheckedModeBanner: false,
      home: (data != null)
          ? HomePage(
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
                  ["businesswhatsappNumber"])
          : const LoginPage(),
    );
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
  //https://shopmanager-cfmh.onrender.com
  //http://192.168.43.250:600
  if (_login.isNotEmpty) {
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
  } else {
    return null;
  }
}





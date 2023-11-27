import 'dart:async';
import '../components/send_screen_to_developer_dialog.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:hive/hive.dart';

import '../components/button.dart';
import '../components/text_input.dart';

class SettingsPage extends StatefulWidget {
  String firstName;
  String lastName;
  String token;
  String phoneNumber;

  final String business_name;
  final String business_whatsapp_number;
  final String business_phone_number;
  final String business_Id;
  double creditScore;
  int creditLimit;
  SettingsPage(
      {required this.firstName,
      required this.lastName,
      required this.token,
      required this.phoneNumber,
  
      required this.creditScore,
      required this.creditLimit,
      required this.business_name,
      required this.business_whatsapp_number,
      required this.business_phone_number,
      required this.business_Id});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final _settingsBox = Hive.box('Settings');

  var newpassword = TextEditingController();
  var oldpassword = TextEditingController();
  final _connect = GetConnect();
  bool loadingIcon = false;
  bool boimetric_status = false;
  Color resetErrorcolor = Colors.amber;

  var resetErrormessage = 'Reset Password';

  //RESET PASSWORD FUNCTION
  void resetpassword() async {
    setState(() {
      loadingIcon = true;
    });

    final response = await _connect
        .post('https://zatuwallet.onrender.com/api/v1/user/register', {
      "newpassword": newpassword.text.trim(),
      "oldpassword": oldpassword.text.trim(),
    }, headers: {
      "Content-Type": "application/json",
      "authorization": "bearer ${widget.token}"
    });

    print(response.statusCode);
    if (response.statusCode == 201) {
      setState(() {
        loadingIcon = false;
        resetErrorcolor = const Color.fromARGB(255, 5, 117, 20);
        resetErrormessage = "password reset Successfully";
      });
      Timer(const Duration(seconds: 2), () {
        setState(() {
          resetErrorcolor = Colors.amber;
          resetErrormessage = 'Reset Password';

          loadingIcon = false;
        });
      });
    } else {
      setState(() {
        loadingIcon = false;
        resetErrorcolor = const Color.fromARGB(255, 176, 0, 0);
        resetErrormessage = 'Reset Password error';
      });
      Timer(const Duration(seconds: 2), () {
        setState(() {
          resetErrorcolor = Colors.amber;
          resetErrormessage = 'Reset Password';
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_settingsBox.isNotEmpty) {
      boimetric_status = true;
    }
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar:
          AppBar(title: const Center(child: Text('SETTINGS')), elevation: 0),
      body: Container(
        width: width,
        height: height,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: width * 0.8,
              child: Row(
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        Text(
                          "Biometric settings",
                          style: TextStyle(fontSize: 18, color: Colors.grey),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Icon(
                          Icons.fingerprint,
                          color: Colors.grey,
                        )
                      ],
                    ),
                  ),
                  Checkbox(
                      value: boimetric_status,
                      onChanged: (Value) {
                        setState(() {
                          boimetric_status = Value!;
                        });

                        if (boimetric_status == true) {
                          _settingsBox.put("0", {
                            "firstName": widget.firstName,
                            "lastName": widget.lastName,
                            "token": widget.token,
                            "phoneNumber": widget.phoneNumber,
                         
                            "creditScore": widget.creditScore,
                            "creditLimit": widget.creditLimit,
                            "businessName": widget.business_name,
                            "businesswhatsappNumber": widget.business_whatsapp_number,
                            "businessphoneNumber": widget.business_phone_number,
                            "businessId": widget.business_Id,
                          });
                        } else if (boimetric_status == false) {
                          _settingsBox.clear();
                        }
                      })
                ],
              ),
            ),
            Container(
              width: width * 0.8,
              height: height * 0.4,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.white,
              ),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text('Reset your password',
                        style: TextStyle(
                            fontSize: 29, color: Colors.grey.withOpacity(0.5))),
                    const SizedBox(
                      height: 40,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: InputField(
                          autofocus: false,
                          onchanged: (value) {},
                          inputs: oldpassword,
                          keyboarType: TextInputType.text,
                          prefixIcon: Icon(Icons.lock),
                          secure: true,
                          textHint: 'Old Password'),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 10),
                      child: InputField(
                          autofocus: false,
                          onchanged: (value) {},
                          inputs: newpassword,
                          keyboarType: TextInputType.text,
                          prefixIcon: Icon(Icons.lock),
                          secure: true,
                          textHint: 'New Password'),
                    ),
                    MyButton(
                      isLoading: loadingIcon,
                      lable: resetErrormessage,
                      function: () => resetpassword,
                      buttoncolor: resetErrorcolor,
                    )
                  ]),
            ),
          ],
        ),
      ),
    );
  }
}

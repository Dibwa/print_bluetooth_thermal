// ignore_for_file: sized_box_for_whitespace
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'dart:async';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:shop_manager/screens/first_login.dart';
import 'package:shop_manager/screens/profile_page.dart';
import '../components/button.dart';
import '../components/text_input.dart';
import 'package:hive_flutter/hive_flutter.dart';
import './screens/home_tab.dart';
import 'package:flutter/services.dart';
import '../components/square_tile.dart';
import 'package:local_auth/error_codes.dart' as auth_error;
import 'package:local_auth/local_auth.dart';
import 'package:local_auth_android/local_auth_android.dart';
import 'package:local_auth_ios/local_auth_ios.dart';
import '../../components/send_screen_to_developer_dialog.dart';
import 'package:shake/shake.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:url_launcher/link.dart';
import 'package:url_launcher/url_launcher.dart';

//LOCAL DATABASES
final loginBox = Hive.box('Login');
final biometricBox = Hive.box('Settings');

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // Future<void> _launchUrl(_url) async {
  //   if (!await launchUrl(_url)) {
  //     throw Exception('Could not launch $_url');
  //   }
  // }

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

  final LocalAuthentication auth = LocalAuthentication();

  void biometic_authentication() async {
    try {
      final bool didAuthenticate = await auth.authenticate(
          localizedReason: 'Please authenticate to login',
          options: const AuthenticationOptions(useErrorDialogs: false));

      print("AUTH DONE $didAuthenticate");

      if (didAuthenticate == true) {
        final response = biometricBox.get("0");
        String firstName = response["firstName"];
        String lastName = response["lastName"];
        String token = response["token"];

        String phoneNumber = response["phoneNumber"];
        int creditLimit = response["phoneNumber"];
        double creditScore = response["phoneNumber"];
        var balance = response["phoneNumber"];
        String business_Id = response.body["business"]["businessId"];
        String business_name = response.body["business"]["businessName"];
        String business_phone_number =
            response.body["business"]["businessphoneNumber"];
        String business_whatsapp_number =
            response.body["business"]["businesswhatsappNumber"];
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => HomePage(
                      firstName: firstName,
                      lastName: lastName,
                      token: token,
                      phoneNumber: phoneNumber,
                      creditLimit: creditLimit,
                      creditScore: creditScore,
                      balance: balance,
                      business_Id: business_Id,
                      business_name: business_name,
                      business_phone_number: business_phone_number,
                      business_whatsapp_number: business_whatsapp_number,
                    )));
      }
    } on PlatformException catch (e) {
      if (e.code == auth_error.notEnrolled) {
        // Add handling of no hardware here.
      } else if (e.code == auth_error.lockedOut ||
          e.code == auth_error.permanentlyLockedOut) {
        // ...
      } else {
        // ...
      }
    }
  }

  void plat() async {
    final bool didAuthenticate = await auth.authenticate(
        localizedReason: 'Please authenticate to show account balance',
        authMessages: const <AuthMessages>[
          AndroidAuthMessages(
            signInTitle: 'Oops! Biometric authentication required!',
            cancelButton: 'No thanks',
          ),
          IOSAuthMessages(
            cancelButton: 'No thanks',
          ),
        ]);
  }

  void err() async {
    try {
      final bool didAuthenticate = await auth.authenticate(
          localizedReason: 'Please authenticate to show account balance',
          options: const AuthenticationOptions(useErrorDialogs: false));
      // ···
    } on PlatformException catch (e) {
      if (e.code == auth_error.notAvailable) {
        // Add handling of no hardware here.
      } else if (e.code == auth_error.notEnrolled) {
        // ...
      } else {
        // ...
      }
    }
  }

  //RESET CODE FUNCTION: send pin to phone number
  void resetPassword() async {
    setState(() {
      loadingIcon = true;
    });

    var response = await _connect
        .post('https://shopmanager-cfmh.onrender.com/api/v1/resetcode', {
      "phoneNumber": resetphonenumber.text.trim(),
    }, headers: {
      "Content-Type": "application/json",
    });
    print("bbb ${response.body}");

    if (response.statusCode == 200) {
      setState(() {
        loadingIcon = false;
        phonenuberandbuttonContainer = false;
        resetpinContainer = true;
        setcodeHeight = 0.45;
        resetpinerrormessage = response.body["message"];
      });
    } else if (response.body == null) {
      setState(() {
        loadingIcon = false;
        resetpinerrorcolor = Colors.red;
        resetpinerrormessage = "Fatal Error Occured";
      });
      Timer(const Duration(seconds: 2), () {
        setState(() {
          resetpinerrorcolor = Colors.black;
          resetpinerrormessage = 'Reset Password';
        });
      });
    } else {
      setState(() {
        loadingIcon = false;
        resetpinerrorcolor = const Color.fromARGB(255, 176, 0, 0);
        resetpinerrormessage = response.body["message"];
      });
      Timer(const Duration(seconds: 2), () {
        setState(() {
          resetpinerrorcolor = Colors.black;
          resetpinerrormessage = 'Reset Password';
        });
      });
    }
  }

//RESET CODE FUNCTION: send phone, pin-code and new password
  resetpasswordFinal() async {
    if (newpasswordfirst.text != newpassword.text) {
      setState(() {
        reseterrormessage = 'password mismatch';
        reseterrorcolor = Colors.red;
      });
      Timer(const Duration(seconds: 2), () {
        setState(() {
          reseterrorcolor = Colors.black;
          reseterrormessage = 'Submit Pin';
        });
      });
      return;
    }

    setState(() {
      loadingIcon = true;
    });

    var response = await _connect
        .post('https://shopmanager-cfmh.onrender.com/api/v1/resetcode/pin', {
      "phoneNumber": resetphonenumberHolder,
      "pin": pincodenumber.text.trim(),
      "password": newpassword.text.trim(),
    }, headers: {
      "Content-Type": "application/json",
    });
    print("bbb ${response.body}");

    if (response.statusCode == 200) {
      setState(() {
        loadingIcon = false;
        resetpinerrormessage = "${response.body["message"]}";
      });
    } else if (response.body == null) {
      setState(() {
        loadingIcon = false;
        resetpinerrorcolor = Colors.black;
        resetpinerrormessage = "Fatal Error Occured";
      });
      Timer(const Duration(seconds: 2), () {
        setState(() {
          loginerrorcolor = Colors.red;
          reseterrormessage = 'Reset Password';
        });
      });
    } else {
      setState(() {
        loadingIcon = false;
        resetpinerrorcolor = const Color.fromARGB(255, 176, 0, 0);
        reseterrormessage = "${response.body["message"]}";
      });
      Timer(const Duration(seconds: 2), () {
        setState(() {
          resetpinerrorcolor = Colors.black;
          reseterrormessage = 'Reset Password';
        });
      });
    }
  }

  //SIGN UP FUNCTION (MOMO)
  void momosignup() async {
    setState(() {
      loadingIcon = true;
    });

    final response = await _connect
        .post('https://shopmanager-cfmh.onrender.com/api/v1/momo/user/register', {
      "phoneNumber": momosignupphonenumber.text.trim(),
      "email": momosignupemail.text.trim(),
      "password": momosignuppassword.text.trim()
    });

    print(response.body);
    if (response.statusCode == 201) {
      setState(() {
        loadingIcon = false;
        signuperrorcolor = const Color.fromARGB(255, 5, 117, 20);
        signuperrormessage = "Successfully Registered";
      });
      Timer(const Duration(seconds: 2), () {
        setState(() {
          signuperrorcolor = const Color(0xFF0022b0);
          signuperrormessage = "Sign up";
          isvisibleLogin = true;
          isvisibleSignup = false;
        });
      });
    } else if (response.body == null) {
      setState(() {
        loadingIcon = false;
        signuperrorcolor = const Color.fromARGB(255, 176, 0, 0);
        signuperrormessage = "connection error";
      });
      Timer(const Duration(seconds: 2), () {
        setState(() {
          signuperrorcolor = const Color(0xFF0022b0);
          signuperrormessage = "Sign up";
        });
      });
    } else {
      setState(() {
        loadingIcon = false;
        signuperrorcolor = const Color.fromARGB(255, 176, 0, 0);
        signuperrormessage = "Already Registered";
      });
      Timer(const Duration(seconds: 2), () {
        setState(() {
          signuperrorcolor = const Color(0xFF0022b0);
          signuperrormessage = "Sign up";
        });
      });
    }
  }

  void resetcontainerSwitch() {
    setState(() {
      isvisibleLogin = false;
      isvisibleSignup = false;
      resetpinContainer = false;
      resetcodeContainer = true;
      phonenuberandbuttonContainer = true;
    });
  }

  void resetcontainerSwitchback() {
    setState(() {
      setcodeHeight = 0.35;
      isvisibleSignup = false;
      resetcodeContainer = false;
      isvisibleLogin = true;
    });
  }

  bool resetcodeContainer = false;
  bool resetpinContainer = false;

  //RESET CODE DEFAULTS
  Color reseterrorcolor = Colors.green;
  Color resetpinerrorcolor = Colors.black;
  var reseterrormessage = 'Submit Pin';
  bool phonenuberandbuttonContainer = true;
  var resetpinerrormessage = 'Reset Password';
  var resetphonenumber = TextEditingController();
  var resetphonenumberHolder = '';
  double setcodeHeight = 0.35;
  var pincodenumber = TextEditingController();
  var newpassword = TextEditingController();
  var newpasswordfirst = TextEditingController();

  final _connect = GetConnect();
  bool loadingIcon = false;
  bool isvisibleLogin = true;
  bool isvisibleSignup = false;
  String switch_between = 'Sign up';
  String acccount_message = "Don't have an account?";

  String agent_id = '';

  //MOMO SIGN UP INPUTS
  var momosignupphonenumber = TextEditingController();
  var momosignuppassword = TextEditingController();
  var momosignupemail = TextEditingController();
  bool momosignupswitch = false;
//LOGIN INPUTS
  var loginphonenumber = TextEditingController();
  var loginpassword = TextEditingController();
  var loginerrormessage = 'Login';
  Color loginerrorcolor = Colors.black;

  //SIGN UP INPUTS
  var signupphonenumber = TextEditingController();
  var signuppassword = TextEditingController();
  var signuppassword_confirm = TextEditingController();

  var signupfirstname = TextEditingController();
  var signuplastname = TextEditingController();
  var signuperrormessage = 'Sign up';
  Color signuperrorcolor = Colors.black;

  Future<void> savelogin(Map<String, dynamic> newItem) async {
    if (loginBox.isEmpty) {
      await loginBox.add(newItem);
    } else {
      await loginBox.putAt(0, newItem);
    }

    print(loginBox.values);
  }

  void send_message_to_support_team(screenshot) async {
    setState(() {
      loadingIcon = true;
    });

    // https://shopmanager-cfmh.onrender.com
    //https://shopmanager-cfmh.onrender.com

    var response =
        await _connect.post('https://shopmanager-cfmh.onrender.com/api/v1/support', {
      "phoneNumber": loginphonenumber.text.trim(),
      "screenshot": screenshot,
    }, headers: {
      "Content-Type": "application/json",
    });
    print("bbb ${response.body} ${response.statusCode}");

    if (response.statusCode == 200) {
    } else if (response.body == null) {
      setState(() {
        loadingIcon = false;
        loginerrorcolor = const Color.fromARGB(255, 176, 0, 0);
        loginerrormessage = "Connection Error";
      });
      Timer(const Duration(seconds: 2), () {
        setState(() {
          loginerrorcolor = Colors.black;
          loginerrormessage = "Login";
        });
      });
    } else if (response.statusCode == 503) {
      setState(() {
        loadingIcon = false;
        loginerrorcolor = const Color.fromARGB(255, 176, 0, 0);
        loginerrormessage = "Server down";
      });
      Timer(const Duration(seconds: 2), () {
        setState(() {
          loginerrorcolor = Colors.black;
          loginerrormessage = "Login";
        });
      });
    } else {
      setState(() {
        loadingIcon = false;
        loginerrorcolor = const Color.fromARGB(255, 176, 0, 0);
        loginerrormessage = "${response.body["message"]}";
      });
      Timer(const Duration(seconds: 2), () {
        setState(() {
          loginerrorcolor = Colors.black;
          loginerrormessage = "Login";
        });
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

  //LOGIN FUNCTION
  void loginRequest() async {
    setState(() {
      loadingIcon = true;
    });

    // https://shopmanager-cfmh.onrender.com
    //http://192.168.43.250:600

    var response =
        await _connect.post('https://shopmanager-cfmh.onrender.com/api/v1/login', {
      "phoneNumber": loginphonenumber.text.trim(),
      "password": loginpassword.text.trim(),
    }, headers: {
      "Content-Type": "application/json",
    });
    print("bbb ${response.body} ${response.statusCode}");

    if (response.statusCode == 200) {
      String firstName = response.body["user"]["firstName"];
      String lastName = response.body["user"]["lastName"];
      String token = response.body["token"];
      var balance = response.body["user"]["balance"];
      String phoneNumber = response.body["user"]["phoneNumber"];
      double creditScore = response.body["user"]["creditScore"];
      int creditLimit = response.body["user"]["creditLimit"];

      String business_Id = response.body["user"]["business"]["businessId"];
      String business_name = response.body["user"]["business"]["businessName"];
      String business_phone_number =
          response.body["user"]["business"]["businessphoneNumber"];
      String business_whatsapp_number =
          response.body["user"]["business"]["businesswhatsappNumber"];
      savelogin({
        "phoneNumber": loginphonenumber.text.trim(),
        "password": loginpassword.text.trim()
      });
      if (business_Id.isEmpty) {
        setState(() {
          loadingIcon = false;
        });
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => First_Login_Page(
                      firstName: firstName,
                      lastName: lastName,
                      phoneNumber: phoneNumber,
                      token: token,
                      business_Id: business_Id,
                      business_name: business_name,
                      business_phone_number: business_phone_number,
                      business_whatsapp_number: business_whatsapp_number,
                    )));
      } else {
        setState(() {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => HomePage(
                        creditLimit: creditLimit,
                        creditScore: creditScore,
                        balance: balance,
                        firstName: firstName,
                        lastName: lastName,
                        token: token,
                        phoneNumber: phoneNumber,
                        business_Id: business_Id,
                        business_name: business_name,
                        business_phone_number: business_phone_number,
                        business_whatsapp_number: business_whatsapp_number,
                      )));
          loadingIcon = false;
          savelogin({
            "phoneNumber": loginphonenumber.text.trim(),
            "password": loginpassword.text.trim()
          });
        });
      }
    } else if (response.body == null) {
      setState(() {
        loadingIcon = false;
        loginerrorcolor = const Color.fromARGB(255, 176, 0, 0);
        loginerrormessage = "Connection Error";
      });
      Timer(const Duration(seconds: 2), () {
        setState(() {
          loginerrorcolor = Colors.black;
          loginerrormessage = "Login";
        });
      });
    } else if (response.statusCode == 503) {
      setState(() {
        loadingIcon = false;
        loginerrorcolor = const Color.fromARGB(255, 176, 0, 0);
        loginerrormessage = "Server down";
      });
      Timer(const Duration(seconds: 2), () {
        setState(() {
          loginerrorcolor = Colors.black;
          loginerrormessage = "Login";
        });
      });
    } else {
      setState(() {
        loadingIcon = false;
        loginerrorcolor = const Color.fromARGB(255, 176, 0, 0);
        loginerrormessage = "${response.body["message"]}";
      });
      Timer(const Duration(seconds: 2), () {
        setState(() {
          loginerrorcolor = Colors.black;
          loginerrormessage = "Login";
        });
      });
    }
  }

  //SIGN UP FUNCTION
  void signupRequest() async {
    if (signuppassword_confirm.text.isNotEmpty &&
        signuppassword.text.isNotEmpty &&
        signuppassword_confirm.text != signuppassword.text) {
      setState(() {
        loadingIcon = false;
        signuperrorcolor = const Color.fromARGB(255, 176, 0, 0);
        signuperrormessage = "Password mismatch";
      });
      Timer(const Duration(seconds: 2), () {
        setState(() {
          signuperrorcolor = Colors.black;
          signuperrormessage = "Sign up";
        });
      });
      return;
    }
    setState(() {
      loadingIcon = true;
    });

    final response = await _connect
        .post('https://shopmanager-cfmh.onrender.com/api/v1/user/register', {
      "phoneNumber": signupphonenumber.text.trim(),
      "firstName": signupfirstname.text.trim(),
      "lastName": signuplastname.text.trim(),
      "password": signuppassword.text.trim()
      // "agentId": agent_id
    });

    print(response.body);
    if (response.statusCode == 201) {
      setState(() {
        loadingIcon = false;
        signuperrorcolor = const Color.fromARGB(255, 5, 117, 20);
        signuperrormessage = "Successfully Registered";
      });
      Timer(const Duration(seconds: 2), () {
        setState(() {
          signuperrorcolor = Colors.black;
          signuperrormessage = "Sign up";
          isvisibleLogin = true;
          isvisibleSignup = false;
        });
      });
    } else if (response.body == null) {
      setState(() {
        loadingIcon = false;
        signuperrorcolor = const Color.fromARGB(255, 176, 0, 0);
        signuperrormessage = "Connection error";
      });
      Timer(const Duration(seconds: 2), () {
        setState(() {
          signuperrorcolor = Colors.black;
          signuperrormessage = "Sign up";
        });
      });
    } else if (response.statusCode == 503) {
      setState(() {
        loadingIcon = false;
        signuperrorcolor = const Color.fromARGB(255, 176, 0, 0);
        signuperrormessage = "Server down";
      });
      Timer(const Duration(seconds: 2), () {
        setState(() {
          signuperrorcolor = Colors.black;
          signuperrormessage = "Sign up";
        });
      });
    } else {
      setState(() {
        loadingIcon = false;
        signuperrorcolor = const Color.fromARGB(255, 176, 0, 0);
        signuperrormessage = response.body["message"];
      });
      Timer(const Duration(seconds: 2), () {
        setState(() {
          signuperrorcolor = Colors.black;
          signuperrormessage = "Sign up";
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double loginboxSize = 0.4;
    bool biometric_login = false;
    var istokenSaved = biometricBox.get("0");
    if (istokenSaved != null) {
      biometric_login = true;
      loginboxSize = 0.45;
    }
    final iskeyBoard = MediaQuery.of(context).viewInsets.bottom != 0;
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("images/banner.png"), fit: BoxFit.fill)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(
                height: 40,
              ),
              //Sign up container
              Visibility(
                visible: isvisibleSignup,
                child: Container(
                  height: height * 0.60,
                  width: width * 0.9,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 35),
                      Column(children: [
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 15),
                          child: InputField(
                            autofocus: false,
                            onchanged: (value) {},
                            keyboarType: TextInputType.text,
                            prefixIcon: const Icon(Icons.person),
                            inputs: signupfirstname,
                            textHint: 'First Name',
                            secure: false,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 15),
                          child: InputField(
                            autofocus: false,
                            onchanged: (value) {},
                            keyboarType: TextInputType.text,
                            prefixIcon: const Icon(Icons.person),
                            inputs: signuplastname,
                            textHint: 'Last Name',
                            secure: false,
                          ),
                        ),
                      ]),
                      const SizedBox(height: 20),
                      //phone number field
                      Container(
                          margin: const EdgeInsets.symmetric(horizontal: 15),
                          child: InputField(
                              autofocus: false,
                              onchanged: (value) {},
                              keyboarType: TextInputType.phone,
                              prefixIcon: const Icon(Icons.phone_android),
                              inputs: signupphonenumber,
                              textHint: 'Phone #',
                              secure: false)),
                      const SizedBox(height: 20),
                      //Passord input field
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 15),
                        child: InputField(
                          autofocus: false,
                          onchanged: (value) {},
                          keyboarType: TextInputType.text,
                          prefixIcon: const Icon(Icons.lock_person),
                          inputs: signuppassword,
                          textHint: 'Password',
                          secure: true,
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
                          keyboarType: TextInputType.text,
                          prefixIcon: const Icon(Icons.lock_person),
                          inputs: signuppassword_confirm,
                          textHint: 'Confirm Password',
                          secure: true,
                        ),
                      ),

                      const SizedBox(
                        height: 20,
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 15),
                        decoration: BoxDecoration(
                          boxShadow: const [
                            BoxShadow(
                                color: Color.fromARGB(255, 59, 42, 42),
                                blurRadius: 10,
                                spreadRadius: 1,
                                offset: Offset(4, 4))
                          ],
                          borderRadius: BorderRadius.circular(30),
                          color: Colors.white,
                        ),
                        child: MyButton(
                          buttoncolor: signuperrorcolor,
                          isLoading: loadingIcon,
                          function: signupRequest,
                          lable: signuperrormessage,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              //Login container
              Visibility(
                visible: isvisibleLogin,
                child: Container(
                  height: height * loginboxSize,
                  width: width * 0.9,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(
                        height: 39,
                      ),
                      //Emaill address input field
                      Container(
                          margin: const EdgeInsets.symmetric(horizontal: 15),
                          child: InputField(
                              autofocus: false,
                              onchanged: (value) {},
                              keyboarType: TextInputType.phone,
                              prefixIcon:
                                  const Icon(Icons.phone_android_outlined),
                              inputs: loginphonenumber,
                              textHint: 'Phone #',
                              secure: false)),
                      const SizedBox(height: 10),
                      //Passord input field
                      Container(
                          margin: const EdgeInsets.symmetric(horizontal: 15),
                          child: InputField(
                              autofocus: false,
                              onchanged: (value) {},
                              keyboarType: TextInputType.text,
                              prefixIcon: const Icon(Icons.lock_person),
                              inputs: loginpassword,
                              textHint: 'Password',
                              secure: true)),
                      const SizedBox(
                        height: 10,
                      ),
                      GestureDetector(
                        onTap: plat,
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 25),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                'Forgot password',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black.withOpacity(0.5)),
                              )
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 15),
                        decoration: BoxDecoration(
                          boxShadow: const [
                            BoxShadow(
                                color: Color.fromARGB(255, 59, 42, 42),
                                blurRadius: 4,
                                spreadRadius: 1,
                                offset: Offset(2, 2))
                          ],
                          borderRadius: BorderRadius.circular(30),
                          color: Colors.white,
                        ),
                        child: MyButton(
                          buttoncolor: loginerrorcolor,
                          isLoading: loadingIcon,
                          function: loginRequest,
                          lable: loginerrormessage,
                        ),
                      ),
                      Visibility(
                        visible: biometric_login,
                        child: GestureDetector(
                          onTap: biometic_authentication,
                          child: Container(
                              padding: EdgeInsets.symmetric(vertical: 13),
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 15, vertical: 10),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30),
                                color: Colors.green.shade200,
                              ),
                              child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text("Scan finger print to login"),
                                    Icon(Icons.fingerprint)
                                  ])),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              //MOMO SIGN UP SECTION
              Visibility(
                visible: momosignupswitch,
                child: Container(
                  margin: const EdgeInsets.only(top: 80),
                  height: height * 0.4,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      //MOMO SIGN UP PHONE NUMBER
                      Container(
                        height: 47,
                        child: TextField(
                            controller: momosignupphonenumber,
                            cursorColor: Colors.black,
                            obscureText: false,
                            keyboardType: TextInputType.phone,
                            decoration: InputDecoration(
                                prefixIcon: const Icon(
                                  Icons.phone_android_rounded,
                                  color: Colors.grey,
                                ),
                                focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(30),
                                    borderSide: const BorderSide(
                                        color: Color(0xFF0022b0))),
                                enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(30),
                                    borderSide: const BorderSide(
                                        color: Color(0xFF0022b0))),
                                hintText: 'Phone Number',
                                focusColor: const Color(0xFF0022b0),
                                fillColor: const Color(0xFFf2f2f2),
                                filled: true)),
                      ),
                      const SizedBox(height: 7),

                      //MOMO EMAIL SIGN UP
                      Container(
                        height: 47,
                        child: TextField(
                            controller: momosignupemail,
                            cursorColor: Colors.black,
                            obscureText: false,
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                                prefixIcon: const Icon(
                                  Icons.mark_email_read_outlined,
                                  color: Colors.grey,
                                ),
                                focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(30),
                                    borderSide: const BorderSide(
                                        color: Color(0xFF0022b0))),
                                enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(30),
                                    borderSide: const BorderSide(
                                        color: Color(0xFF0022b0))),
                                hintText: 'Email',
                                focusColor: const Color(0xFF0022b0),
                                fillColor: const Color(0xFFf2f2f2),
                                filled: true)),
                      ),
                      const SizedBox(height: 10),

                      //MOMO SIGN UP PASSWORD
                      Container(
                        height: 50,
                        child: TextField(
                            controller: momosignuppassword,
                            cursorColor: Colors.black,
                            obscureText: true,
                            decoration: InputDecoration(
                                prefixIcon: const Icon(
                                  Icons.lock_person_rounded,
                                  color: Colors.grey,
                                ),
                                focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(30),
                                    borderSide: const BorderSide(
                                        color: Color(0xFF0022b0))),
                                enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(30),
                                    borderSide: const BorderSide(
                                        color: Color(0xFF0022b0))),
                                hintText: 'Password',
                                fillColor: const Color(0xFFf2f2f2),
                                filled: true)),
                      ),
                      const SizedBox(
                        height: 10,
                      ),

                      MyButton(
                        buttoncolor: signuperrorcolor,
                        isLoading: loadingIcon,
                        function: momosignup,
                        lable: signuperrormessage,
                      ),
                    ],
                  ),
                ),
              ),

              //RESET CODE SECTION
              Visibility(
                visible: resetcodeContainer,
                child: Container(
                  height: height * setcodeHeight,
                  width: width * 0.9,
                  decoration: BoxDecoration(
                    boxShadow: const [
                      BoxShadow(
                          color: Color.fromARGB(255, 59, 42, 42),
                          blurRadius: 10,
                          spreadRadius: 1,
                          offset: Offset(4, 4))
                    ],
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white,
                  ),
                  child: Column(children: [
                    Container(
                      margin:
                          const EdgeInsets.only(left: 10, top: 20, bottom: 20),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            GestureDetector(
                                onTap: resetcontainerSwitchback,
                                child: const Icon(
                                  Icons.arrow_back,
                                  size: 40,
                                ))
                          ]),
                    ),
                    Visibility(
                      visible: phonenuberandbuttonContainer,
                      child: Column(
                        children: [
                          //phone number input field
                          Container(
                              margin: const EdgeInsets.only(
                                  bottom: 15, left: 10, right: 10),
                              child: InputField(
                                  autofocus: false,
                                  onchanged: (value) {},
                                  keyboarType: TextInputType.phone,
                                  prefixIcon:
                                      const Icon(Icons.phone_android_outlined),
                                  inputs: resetphonenumber,
                                  textHint: 'Phone #',
                                  secure: false)),

                          //RESET PASSWORD BUTTON: send pin to phone number
                          Container(
                            margin: const EdgeInsets.symmetric(horizontal: 10),
                            child: MyButton(
                              buttoncolor: resetpinerrorcolor,
                              isLoading: loadingIcon,
                              function: resetPassword,
                              lable: resetpinerrormessage,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Visibility(
                      visible: resetpinContainer,
                      child: Column(children: [
                        //reset code input field PIN CODE
                        Container(
                            margin: const EdgeInsets.symmetric(horizontal: 15),
                            child: InputField(
                                autofocus: false,
                                onchanged: (value) {},
                                keyboarType: TextInputType.phone,
                                prefixIcon:
                                    const Icon(Icons.phone_android_outlined),
                                inputs: pincodenumber,
                                textHint: 'Pin Code',
                                secure: false)),
                        //reset code input field NEW PASSWORD
                        Container(
                            margin: const EdgeInsets.symmetric(
                                horizontal: 15, vertical: 5),
                            child: InputField(
                                autofocus: false,
                                onchanged: (value) {},
                                keyboarType: TextInputType.text,
                                prefixIcon: const Icon(Icons.lock_clock),
                                inputs: newpasswordfirst,
                                textHint: 'New Password',
                                secure: true)),
                        //reset code input field CONFIRM PASSWORD
                        Container(
                            margin: const EdgeInsets.symmetric(horizontal: 15),
                            child: InputField(
                                autofocus: false,
                                onchanged: (value) {},
                                keyboarType: TextInputType.text,
                                prefixIcon: const Icon(Icons.lock_clock),
                                inputs: newpassword,
                                textHint: 'Confirm Password',
                                secure: true)),

                        //RESET PASSWORD BUTTON: send pin and phone number to server
                        Container(
                          margin: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 5),
                          child: MyButton(
                            buttoncolor: reseterrorcolor,
                            isLoading: loadingIcon,
                            function: resetpasswordFinal,
                            lable: reseterrormessage,
                          ),
                        ),
                      ]),
                    ),
                  ]),
                ),
              ),
              const SizedBox(
                height: 40,
              ),

              Container(
                width: width * 0.9,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      children: const [
                        Expanded(
                            child: Divider(
                          thickness: 0.5,
                          color: Colors.black,
                        )),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 5),
                          child: Text('or continue with'),
                        ),
                        Expanded(
                            child: Divider(
                          thickness: 0.5,
                          color: Colors.black,
                        )),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        GestureDetector(
                            onTap: () {
                              setState(() {
                                isvisibleLogin = false;
                                isvisibleSignup = false;
                                momosignupswitch = true;
                              });
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color: Colors.white, width: 2)),
                              child: SquareTile(
                                  pictureUrl: 'images/New-mtn-logo.jpg'),
                            )),
                        const SizedBox(
                          width: 40,
                        ),
                        GestureDetector(
                            onTap: () {
                              setState(() {
                                isvisibleLogin = false;
                                isvisibleSignup = false;
                                momosignupswitch = true;
                              });
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color: Colors.white, width: 2)),
                              child: SquareTile(
                                  pictureUrl: 'images/zamtel-logo.png'),
                            ))
                      ],
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(acccount_message),
                        const SizedBox(width: 5),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              isvisibleLogin = !isvisibleLogin;
                              isvisibleSignup = !isvisibleSignup;
                              if (switch_between == 'Sign up') {
                                acccount_message = "Have an account?";
                                switch_between = 'Login';
                              } else {
                                acccount_message = "Don't have an account?";
                                switch_between = 'Sign up';
                              }
                            });
                          },
                          child: Container(
                            child: Text(
                              switch_between,
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
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

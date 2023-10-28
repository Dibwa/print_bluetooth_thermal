// ignore_for_file: must_be_immutable

import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import '../components/linked_accounts_tile.dart';
import '../components/send_screen_to_developer_dialog.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:get/get.dart';
import 'enlisted_shops_in_system.dart';

class Shop_Link_Page extends StatefulWidget {
  final String token;
  final String phoneNumber;
  Shop_Link_Page({super.key, required this.token, required this.phoneNumber});

  @override
  Shop_Link_PageState createState() => Shop_Link_PageState();
}

class Shop_Link_PageState extends State<Shop_Link_Page> {
  @override
  void initState() {
    super.initState();
    fetch_connections();
  }

  final _connect = GetConnect();
  bool connected_accounts_list = false;
  bool empty_list = false;
  bool loading = true;
  List<dynamic> _connection_list = [
    {
      "accountName": "Mandy Mulenga",
      "accountphoneNumber": "0971067788",
      "syncDate": "02 Feb 2023"
    },
    {
      "accountName": "John Limonga",
      "accountphoneNumber": "0971062788",
      "syncDate": "02 Feb 2023"
    },
    {
      "accountName": "Reagan Banda",
      "accountphoneNumber": "0971067447",
      "syncDate": "02 Feb 2023"
    },
    {
      "accountName": "Lee Kunda",
      "accountphoneNumber": "0961097788",
      "syncDate": "02 Feb 2023"
    },
    {
      "accountName": "Charity Mundia",
      "accountphoneNumber": "0971067423",
      "syncDate": "02 Feb 2023"
    },
    {
      "accountName": "Mulenga Chileshe",
      "accountphoneNumber": "0971067712",
      "syncDate": "02 Feb 2023"
    },
  ];
  @override
  Widget build(BuildContext context) {
if( _connection_list.isEmpty && loading == false){
empty_list = true;
connected_accounts_list = false;

}else if(_connection_list.isNotEmpty && loading == false){
empty_list  = false;
connected_accounts_list = true;
}
   
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
        appBar: AppBar(title: Text("SHOP LINK"), elevation: 0),
        body: Container(
            height: height,
            width: width,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.white,
            ),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                      margin: EdgeInsets.only(bottom: 7),
                      child: Text(
                        "Scan to link shop",
                        style: TextStyle(color: Colors.grey),
                      )),
                  QrImageView(
                      data: widget.token, version: QrVersions.auto, size: 200),
                  Container(
                    width: width * 0.5,
                    margin: EdgeInsets.only(top: 25),
                    child: GestureDetector(
                      onTap: () {
                        _show_bottom_sheet(context);
                      },
                      child: Container(
                        padding: EdgeInsets.only(
                            top: 5, left: 5, right: 5, bottom: 5),
                        decoration: BoxDecoration(
                            border: Border.all(
                                color: Colors.grey,
                                width: 1.4,
                                style: BorderStyle.solid),
                            borderRadius: BorderRadius.circular(30)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "link account",
                              style:
                                  TextStyle(color: Colors.grey, fontSize: 17),
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Icon(Icons.connect_without_contact)
                          ],
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                            margin: EdgeInsets.only(left: 12, top: 30),
                            child: Text(
                              "Linked Accounts",
                              style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey),
                            )),
                        (_connection_list.isEmpty && loading == true)
                            ? Expanded(
                                child: Center(
                                  child: SizedBox(
                                    width: 30,
                                    height: 30,
                                    child: CircularProgressIndicator(),
                                  ),
                                ),
                              )
                            : Visibility(
                                visible: connected_accounts_list,
                                child: Expanded(
                                  child: Container(
                                      margin: const EdgeInsets.symmetric(
                                          horizontal: 10),
                                      child: ListView.builder(
                                          itemCount: _connection_list.length,
                                          itemBuilder: (context, index) {
                                            final item =
                                                _connection_list[index];
                                            return Linked_Account_Tile(
                                          
                                              accountphoneNumber:
                                                  item["phoneNumber"],
                                              buttonFunction: () {},
                                            );
                                          })),
                                ),
                              ),
                        Visibility(
                            visible: empty_list,
                            child: Expanded(
                              child: Center(
                                child: Text("No connected accounts",
                                    style: TextStyle(
                                        fontSize: 19,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.grey.shade300)),
                              ),
                            ))
                      ],
                    ),
                  ),
                ])));
  }

  // ignore: unused_element
  _show_bottom_sheet(
    BuildContext context,
  ) {
    return showModalBottomSheet(
        backgroundColor: Color.fromARGB(246, 255, 255, 255),
        elevation: 0,
        enableDrag: true,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(30))),
        context: context,
        builder: (context) {
          return Shop_List_Page(
              phoneNumber: widget.phoneNumber, token: widget.token);
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

  //FETCH CONNECTIONS
  fetch_connections() async {
    setState(() {
      loading = true;
    });
    //https://shopmanager-cfmh.onrender.com
    //http://192.168.43.250:600

    var response = await _connect
        .post("https://shopmanager-cfmh.onrender.com/api/v1/shop/accountconnections", {
      "phoneNumber": widget.phoneNumber
    }, headers: {
      "Content-Type": "application/json",
    });
    if (response.statusCode == 200) {
      print("bbb ${response.body}");

      setState(() {
        loading = false;
        _connection_list = response.body["message"];

        if (_connection_list.isEmpty) {
          connected_accounts_list = false;
          empty_list = true;
        }
      });
    } else if (response.body == null) {
      setState(() {
        loading = false;
      });
      _showFlashbar("Failed",
          "failed to coonect to the server. kindly check your internet");
    } else if (response.statusCode == 503) {
      setState(() {
        loading = false;
      });
      _showFlashbar(
          "Server Down", "Server is currently down. Try again after some time");
    } else {
      setState(() {
        loading = false;
      });
      _showFlashbar("Server Response", response.body["message"]);
    }
  }
}

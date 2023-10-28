import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get_connect/connect.dart';

class Shop_list_Tile extends StatefulWidget {
  final String shopName;
  final String shopId;
  final String phoneNumber;

  const Shop_list_Tile({
 
    required this.shopName,
    required this.shopId,
    required this.phoneNumber,
  });

  @override
  State<Shop_list_Tile> createState() => _Shop_list_TileState();
}

final _connect = GetConnect();
bool loading = false;
Color loadingColor = Colors.lightGreen;

class _Shop_list_TileState extends State<Shop_list_Tile> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 20.0, bottom: 20),
      margin: const EdgeInsets.only(top: 2),
      color: const Color(0xFFf2f2f2),
      child: Container(
        margin: const EdgeInsets.only(left: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.shopName,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Text(
                    widget.shopId,
                    style: const TextStyle(fontSize: 12),
                  ),
                ]),
            Column(
              children: [
                Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    margin: const EdgeInsets.only(right: 7),
                    decoration: BoxDecoration(
                        color: loadingColor,
                        borderRadius: BorderRadius.circular(30)),
                    child: GestureDetector(
                        onTap: () {
                          connect_to_selected_shop(widget.shopId);
                        },
                        child: (loading != true)
                            ? Text(
                                "Request Connection",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey.shade200),
                              )
                            : SizedBox(
                                width: 30,
                                height: 30,
                                child: CircularProgressIndicator(
                                    color: Colors.lightGreen),
                              )))
              ],
            )
          ],
        ),
      ),
    );
  }

  //AnimationController
  void _showFlashbar(title, message) {
    Flushbar(
      title: title,
      message: message,
      duration: Duration(seconds: 4),
    )..show(context);
  }

  //CONNECT TO SELECTED SHOPS
  connect_to_selected_shop(shopId) async {
    setState(() {
      loading = true;
      loadingColor = Colors.white;
    });
    //https://zatuwallet.onrender.com
    //http://192.168.43.250:600

    var response = await _connect
        .post('https://shopmanager-cfmh.onrender.com/api/v1/shop/connect', {
      "shopId": shopId,
      "requestor": widget.phoneNumber,
    }, headers: {
      "Content-Type": "application/json",
    });
    if (response.statusCode == 200) {
      print("bbb ${response.body}");

      setState(() {
        loading = false;
        loadingColor = Colors.lightGreen;
      });
      _showFlashbar("Successfull", response.body["message"]);
    } else if (response.body == null) {
      setState(() {
        loading = false;
        loadingColor = Colors.lightGreen;
      });
      _showFlashbar("Failed",
          "failed to connect to the server. kindly check your internet");
    } else if (response.statusCode == 503) {
      setState(() {
        loading = false;
        loadingColor = Colors.lightGreen;
      });
      _showFlashbar(
          "Server Down", "Server is currently down. Try again after some time");
    } else {
      setState(() {
        loading = false;
        loadingColor = Colors.lightGreen;
      });
      _showFlashbar("Server Response", response.body["message"]);
    }
  }
}

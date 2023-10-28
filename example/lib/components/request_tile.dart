import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';


class Request_list_Tile extends StatefulWidget {
  final String shopId;
  final String phoneNumber;

  Color loadingColor;
  final Function()? approve_request;
  Request_list_Tile(
      {super.key,
      required this.shopId,
      required this.phoneNumber,
   required this.loadingColor,
      required this.approve_request});

  @override
  State<Request_list_Tile> createState() => _Request_list_TileState();
}

class _Request_list_TileState extends State<Request_list_Tile> {

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
                  const SizedBox(
                    width: 10,
                  ),
                  Text(
                    widget.shopId,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ]),
            Column(
              children: [
                Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                        color: widget.loadingColor,
                        borderRadius: BorderRadius.circular(30)),
                    child: GestureDetector(
                        onTap: widget.approve_request,
                        child:
                          Text(
                                "Approve Request",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey.shade200),
                              )
                          ))
              ],
            )
          ],
        ),
      ),
    );
  }


}

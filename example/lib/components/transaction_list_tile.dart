import 'package:flutter/material.dart';

import '../screens/home_tab.dart';

class Transaction_list_Tile extends StatelessWidget {
  final String invoiceId;

  final String total;
  final sync;
  final Function()? showList;
  const Transaction_list_Tile(
      {
      required this.showList,
      required this.invoiceId,
      required this.total,
      required this.sync});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: showList,
      child: Container(
        padding: const EdgeInsets.only(top: 20.0, bottom: 20),
        margin: const EdgeInsets.only(top: 10),
        color: const Color(0xFFf2f2f2),
        child: Container(
          margin: const EdgeInsets.only(left: 8),
          child: Row(
            children: [
              Expanded(
                flex: 6,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(children: [
                      Text("Invoice Id: ",
                          style: TextStyle(
                              fontSize: 10, color: Colors.grey.shade500)),
                      Text(
                        invoiceId,
                        style: TextStyle(
                            fontSize: 11, color: Colors.grey.shade500),
                      )
                    ]),
                    Row(children: [
                      Text("Total: ZMW ", style: TextStyle(fontSize: 15)),
                      Text(total, style: TextStyle(fontSize: 15))
                    ]),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Icon(Icons.sync,
                        color: (sync == true) ? Colors.green : Colors.black)
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

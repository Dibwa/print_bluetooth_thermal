// ignore_for_file: camel_case_types, must_be_immutable, prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';

import 'invoice_bill_list_tile.dart';
//import 'package:slide_to_act/slide_to_act.dart';

class Invoice_Payment_DialogBox extends StatelessWidget {
  String invoiceId;
  var invoiceData;

  Invoice_Payment_DialogBox(
      {super.key, required this.invoiceId, required this.invoiceData});

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return AlertDialog(
        backgroundColor: Color(0xFFf2f2f2),
        content: Container(
          width: 300,
          height: height * 0.8,
          child: Column(children: [
            Expanded(
              child: ListView.builder(
                  itemCount: invoiceData.length,
                  itemBuilder: (context, index) {
                    final kadi = invoiceData[index];
                    return Invoice_Bill_Tile(
                      buttonFunction: () {},
                      productName: kadi["productName"],
                      productAmount: kadi["productAmount"],
                      productUnit: kadi["productUnit"],
                    );
                  }),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Total: ZMW 500"),
                Container(
                    decoration: BoxDecoration(
                      boxShadow: const [
                        BoxShadow(
                            color: Color.fromARGB(255, 59, 42, 42),
                            blurRadius: 10,
                            spreadRadius: 1,
                            offset: Offset(4, 4))
                      ],
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.green,
                    ),
                    child: Text("PAY")),
              ],
            )
          ]),
        ));
  }
}

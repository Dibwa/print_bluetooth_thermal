import 'package:flutter/material.dart';
//import 'package:slide_to_act/slide_to_act.dart';
import './invoice_product_tile.dart';

// ignore: must_be_immutable
class Dialog_Box_Product_List extends StatefulWidget {
  var product_list;

  Dialog_Box_Product_List({super.key, required this.product_list});

  @override
  State<Dialog_Box_Product_List> createState() =>
      _Dialog_Box_Product_ListState();
}

class _Dialog_Box_Product_ListState extends State<Dialog_Box_Product_List> {
  List _productItems = [];

  @override
  Widget build(BuildContext context) {
    _productItems = widget.product_list;
    print(_productItems);
    num total = 0;
    _productItems.forEach((element) {
      total += element["subTotal"];
    });
    return AlertDialog(
        backgroundColor: Color(0xFFf2f2f2),
        content: Container(
          width: 350,
          height: 500,
          child: Column(
            children: [
              Expanded(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 2),
                  child: ListView.builder(
                      itemCount: _productItems.length,
                      itemBuilder: (context, index) {
                        final items = _productItems[index];
                        print(items);
                        return Invoice_Product_Tile(
                            quantity: items['quantity'],
                            productName: items['productName'],
                            subTotal: items['subTotal']);
                      }),
                ),
              ),
              Container(
                width: 295,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      "Total ",
                      style: TextStyle(color: Colors.grey.shade700),
                    ),
                    Text("ZMW ${total.toString()}"),
                  ],
                ),
              )
            ],
          ),
        ));
  }
}

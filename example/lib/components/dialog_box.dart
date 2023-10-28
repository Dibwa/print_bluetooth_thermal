import 'package:flutter/material.dart';
//import 'package:slide_to_act/slide_to_act.dart';
import 'text_input.dart';

// ignore: must_be_immutable
class DialogBox extends StatelessWidget {
  String product_name;
  String product_price;
  String product_barcode;
  TextEditingController product_quantity;
  final Function()? buttonFunction;
  DialogBox(
      {super.key,
      required this.product_quantity,
      required this.buttonFunction,
      required this.product_name,
      required this.product_price,
      required this.product_barcode});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        backgroundColor: Color(0xFFf2f2f2),
        content: Container(
          width: 300,
          height: 200,
          child: Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  margin: const EdgeInsets.only(left: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        product_barcode,
                        style: TextStyle(
                            fontSize: 13, color: Colors.grey.shade500),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(product_name, style: TextStyle(fontSize: 15)),
                      SizedBox(
                        height: 3,
                      ),
                      Text("ZMW ${product_price}",
                          style: TextStyle(fontSize: 15)),
                    ],
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  height: 40,
                  width: 295,
                  child: InputField(
                    autofocus: true,
                    onchanged: (value) {},
                    keyboarType: TextInputType.phone,
                    prefixIcon: const Icon(Icons.calculate_outlined),
                    inputs: product_quantity,
                    textHint: 'Quantity',
                    secure: false,
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                Container(
                  width: 295,
                  height: 47,
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(20)),
                  child: MaterialButton(
                      color: Colors.black,
                      onPressed: buttonFunction,
                      child: Text("Add",
                          style: TextStyle(fontSize: 13, color: Colors.white))),
                )
              ],
            ),
          ),
        ));
  }
}

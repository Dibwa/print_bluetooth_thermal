import 'package:flutter/material.dart';

import '../screens/home_tab.dart';

class Invoice_Product_Tile extends StatelessWidget {
  final String productName;
  final String quantity;
  final int subTotal;

  const Invoice_Product_Tile({
     required this.productName,
    required this.subTotal,
    required this.quantity,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 15.0, bottom: 15),
      margin: const EdgeInsets.only(top: 10),
      color: Colors.green.shade100,
      child: Container(
        margin: const EdgeInsets.only(left: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Quantity ${quantity}",
              style: TextStyle(fontSize: 10,color: Colors.black.withOpacity(0.5)),
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              children: [
                Expanded(
                  flex: 6,
                  child: Text(
                    productName,
                    style: TextStyle(
                        fontSize: 11, color: Colors.black.withOpacity(0.8)),
                  ),
                ),
                Expanded(
                  flex: 4,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [Text("ZMW "), Text(subTotal.toString())],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
